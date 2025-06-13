import SwiftUI

struct PlaceListView: View {
    @State private var placeService = PlaceService()
    @State private var places: [PlaceUIO] = []
    @State private var hasNext: Bool = false
    @State private var nextCursor: String? = nil
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @State private var selectedAll: Bool = true
    @State private var selectedCategories: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                header
                
                ScrollView {
                    LazyVStack {
                        ForEach(places) { place in
                            if selectedCategories.isEmpty {
                                NavigationLink {
                                    PlaceDetailView(placeID: place.id)
                                } label: {
                                    PlaceListCell(place: place)
                                        .onAppear {
                                            loadMorePlaces(placeID: place.id, isSearching: isSearching, keyword: searchText)
                                        }
                                }
                            } else {
                                if !Set(selectedCategories).intersection(Set(place.categories)).isEmpty {
                                    NavigationLink {
                                        PlaceDetailView(placeID: place.id)
                                    } label: {
                                        PlaceListCell(place: place)
                                            .onAppear {
                                                loadMorePlaces(placeID: place.id, isSearching: isSearching, keyword: searchText)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    isSearching = false
                    places = []
                    hasNext = false
                    nextCursor = nil
                    searchText = ""
                    selectedAll = true
                    selectedCategories = []
                    loadPlaces(isSearching: false, keyword: nil)
                }
            }
            .onAppear {
                loadPlaces(isSearching: false, keyword: nil)
            }
            #if os(iOS)
            .sensoryFeedback(.selection, trigger: selectedCategories)
            #endif
        }
    }
}

private extension PlaceListView {
    var header: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .foregroundStyle(Color.pink)
                .background(Color.white.opacity(0.9))
                .frame(height: 50)
                .overlay {
                    HStack(spacing: 8) {
                        TextField("검색어를 입력하세요.", text: $searchText)
                            .textFieldStyle(.plain)
                            .lineLimit(1)
                            .submitLabel(.search)
                            .onSubmit {
                                isSearching = true
                                loadPlaces(isSearching: isSearching, keyword: searchText)
                            }
                        
                        Button {
                            isSearching = true
                            loadPlaces(isSearching: isSearching, keyword: searchText)
                        } label: {
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .overlay {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                        .bold()
                                        .foregroundStyle(Color.white)
                                }
                        }
                    }
                    .padding(8)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        selectedCategories.removeAll()
                        selectedAll = true
                    } label: {
                        PlaceCategoryAllTag()
                            .opacity(selectedAll ? 1.0 : 0.5)
                    }
                    
                    ForEach(PlaceCategory.allCases, id: \.self) { category in
                        Button {
                            if selectedCategories.contains(category.rawValue) {
                                selectedCategories.remove(at: selectedCategories.firstIndex(of: category.rawValue)!)
                                if selectedCategories.isEmpty {
                                    selectedAll = true
                                }
                            } else {
                                selectedCategories.append(category.rawValue)
                                selectedAll = false
                            }
                        } label: {
                            PlaceCategoryTag(category: category.rawValue)
                                .opacity(selectedCategories.contains(category.rawValue) ? 1.0 : 0.5)
                        }
                    }
                }
                .onChange(of: selectedCategories, {
                    Task {
                        do {
                            places = try await placeService.getPlacesOnMapByCategories(categories: selectedCategories)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            
            Divider()
                .padding(.bottom, 8)
        }
    }
}

private extension PlaceListView {
    func loadPlaces(isSearching: Bool, keyword: String?) {
        Task {
            do {
                var placeList: PlaceListUIO = .init(places: [], hasNext: false, nextCursor: nil)
                if isSearching {
                    if let keyword = keyword {
                        placeList = try await placeService.getPlacesOnListByKeyword(keyword: keyword, lastID: "", size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC")
                        print(placeList.places)
                    }
                } else {
                    placeList = try await placeService.getAllPlacesOnList(lastID: "", size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC")
                }
                self.places = placeList.places
                self.hasNext = placeList.hasNext
                if let nextCursor = placeList.nextCursor {
                    self.nextCursor = nextCursor
                } else {
                    self.nextCursor = nil
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMorePlaces(placeID: String, isSearching: Bool, keyword: String?) {
        Task {
            do {
                if let lastID = places.last?.id {
                    if placeID == lastID {
                        var additionalPlaceList: PlaceListUIO = .init(places: [], hasNext: false, nextCursor: nil)
                        if isSearching {
                            if let keyword = keyword {
                                additionalPlaceList = try await placeService.getPlacesOnListByKeyword(keyword: keyword, lastID: placeID, size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC")
                            }
                        } else {
                            additionalPlaceList = try await placeService.getAllPlacesOnList(lastID: placeID, size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC")
                        }
                        self.places.append(contentsOf: additionalPlaceList.places)
                        self.hasNext = additionalPlaceList.hasNext
                        if let nextCursor = additionalPlaceList.nextCursor {
                            self.nextCursor = nextCursor
                        } else {
                            self.nextCursor = nil
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
