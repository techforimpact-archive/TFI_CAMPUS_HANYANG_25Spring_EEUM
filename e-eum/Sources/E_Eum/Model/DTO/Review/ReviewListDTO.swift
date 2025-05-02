import Foundation

struct ReviewListDTO: Decodable {
    let reviews: [ReviewDTO]
    let hasNext: Bool
    let nextCursor: String
}
