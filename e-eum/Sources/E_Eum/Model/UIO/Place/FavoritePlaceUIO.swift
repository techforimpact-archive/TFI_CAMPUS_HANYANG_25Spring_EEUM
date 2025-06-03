import Foundation

struct FavoritePlaceUIO: Identifiable {
    let id: String
    let placeId: String
    let placeName: String
    let categories: [String]
    let address: String
    
    init(favoriteId: String, placeId: String, placeName: String, categories: [String], address: String) {
        self.id = favoriteId
        self.placeId = placeId
        self.placeName = placeName
        self.categories = categories
        self.address = address
    }
    
    init(favoritePlaceDTO: FavoritePlaceDTO) {
        self.id = favoritePlaceDTO.favoriteId
        self.placeId = favoritePlaceDTO.placeId
        self.placeName = favoritePlaceDTO.placeName
        self.categories = favoritePlaceDTO.categories
        self.address = favoritePlaceDTO.address
    }
}
