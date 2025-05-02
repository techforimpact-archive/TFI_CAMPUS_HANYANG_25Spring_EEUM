import Foundation

struct ListSearchResultDTO: Decodable {
    let places: [PlaceResponseDTO]
    let hasNext: Bool
    let nextCursor: String
}
