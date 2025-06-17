import Foundation

struct FavoritePlaceDTO: Decodable {
    let favoriteId: String
    let placeId: String
    let placeName: String
    let categories: [String]
    let address: String
}
