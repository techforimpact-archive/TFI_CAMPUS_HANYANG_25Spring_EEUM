import Foundation

struct MyReviewDTO: Decodable {
    let reviewId: String
    let placeId: String
    let placeName: String
    let placeCategories: [String]
    let placeAddress: String
    let content: String
    let createdAt: String
    let updatedAt: String
}
