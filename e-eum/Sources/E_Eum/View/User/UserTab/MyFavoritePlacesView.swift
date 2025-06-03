import SwiftUI

struct MyFavoritePlacesView: View {
    @State private var placeService = PlaceService()
    @State private var favoritePlaces: [FavoritePlaceUIO] = []
    @State private var hasNext: Bool = false
    @State private var nextCursor: String? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(favoritePlaces) { place in
                    NavigationLink {
                        PlaceDetailView(placeID: place.placeId)
                    } label: {
                        myFavoritePlaceCell(place: place)
                    }
                    .onAppear {
                        loadMoreFavoritePlaces(placeID: place.placeId)
                    }
                }
            }
        }
        .onAppear {
            loadFavoritePlaces()
        }
    }
}

private extension MyFavoritePlacesView {
    func myFavoritePlaceCell(place: FavoritePlaceUIO) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.placeName)
                
                Text(place.address)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

private extension MyFavoritePlacesView {
    func loadFavoritePlaces() {
        Task {
            do {
                let placeList = try await placeService.myFavoritePlaces(cursor: "", size: 10, sortBy: "createdAt", sortDirection: "DESC")
                self.favoritePlaces = placeList.places
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
    
    func loadMoreFavoritePlaces(placeID: String) {
        Task {
            do {
                if let lastID = favoritePlaces.last?.id {
                    if placeID == lastID {
                        let additionalPlaceList = try await placeService.myFavoritePlaces(cursor: placeID, size: 10, sortBy: "createdAt", sortDirection: "DESC")
                        self.favoritePlaces.append(contentsOf: additionalPlaceList.places)
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
