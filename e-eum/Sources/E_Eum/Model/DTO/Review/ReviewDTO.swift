import Foundation

struct ReviewDTO: Decodable {
    let id: String
    let placeId: String
    let userId: String
    let userNickname: String
    let content: String
    let rating: Int
    let createdAt: String
    let recommended: Bool
}
