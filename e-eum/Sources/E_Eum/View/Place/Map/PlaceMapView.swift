import SwiftUI
import SkipKit
import SkipDevice

struct PlaceMapView: View {
    @State private var placeService = PlaceService()
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    @State private var places: [PlaceUIO] = []
    @State private var searchText: String = ""
    @State private var selectedCategories: [String] = []
    
    var body: some View {
        ZStack {
            if let latitude = latitude, let longitude = longitude {
                #if os(iOS)
                MapiOSView(latitude: latitude, longitude: longitude, places: $places)
                #elseif os(Android)
                MapAndroidView(latitude: latitude, longitude: longitude, places: $places)
                #endif
            }
            
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(Color.pink)
                    .background(Color.white.opacity(0.9))
                    .frame(height: 50)
                    .overlay {
                        HStack(spacing: 8) {
                            TextField("검색어를 입력하세요.", text: $searchText)
                                .lineLimit(1)
                                .submitLabel(.search)
                                .onSubmit {
                                    searchPlaces(keyword: searchText)
                                }
                            
                            Button {
                                searchPlaces(keyword: searchText)
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
                
                HStack {
                    ForEach(PlaceCategory.allCases, id: \.self) { category in
                        Button {
                            if selectedCategories.contains(category.rawValue) {
                                selectedCategories.remove(at: selectedCategories.firstIndex(of: category.rawValue)!)
                            } else {
                                selectedCategories.append(category.rawValue)
                            }
                        } label: {
                            PlaceCategoryTag(category: category.rawValue)
                                .opacity(selectedCategories.contains(category.rawValue) ? 1.0 : 0.6)
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
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .task {
            await requestLocationAndStartMonitoring()
        }
    }
}

extension PlaceMapView {
    func requestLocationAndStartMonitoring() async {
        let permissionResult = await PermissionManager.requestLocationPermission(precise: true, always: false)
        
        if permissionResult.isAuthorized == false {
            logger.warning("permission refused for ACCESS_FINE_LOCATION")
            return
        }
        
        let provider = LocationProvider()
        
        do {
            if let firstLocation = try await provider.monitor().first(where: { _ in true }) {
                self.latitude = firstLocation.latitude
                self.longitude = firstLocation.longitude
                if let latitude = latitude, let longitude = longitude {
                    places = try await placeService.getAllPlacesOnMap(latitude: latitude, longitude: longitude, radius: 100000)
                }
                
                do {
                    for try await event in provider.monitor() {
                        self.latitude = event.latitude
                        self.longitude = event.longitude
                    }
                } catch {
                    logger.error("error updating location: \(error)")
                }
            }
        } catch {
            logger.error("error getting initial location: \(error)")
        }
    }
    
    func searchPlaces(keyword: String) {
        Task {
            do {
                places = try await placeService.getPlacesOnMapByKeyword(keyword: keyword)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
