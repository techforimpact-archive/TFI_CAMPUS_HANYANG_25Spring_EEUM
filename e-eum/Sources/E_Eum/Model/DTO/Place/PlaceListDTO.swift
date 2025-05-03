import Foundation

struct PlaceListDTO: Decodable {
    let places: [PlaceDTO]
    let hasNext: Bool
    let nextCursor: String
}
