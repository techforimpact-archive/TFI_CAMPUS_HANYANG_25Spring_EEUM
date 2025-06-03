import Foundation

struct MyReviewUIO: Identifiable {
    let id: String
    let placeId: String
    let placeName: String
    let placeCategories: [String]
    let placeAddress: String
    let content: String
    let createdAt: String
    let updatedAt: String
    
    init(reviewId: String, placeId: String, placeName: String, placeCategories: [String], placeAddress: String, content: String, createdAt: String, updatedAt: String) {
        self.id = reviewId
        self.placeId = placeId
        self.placeName = placeName
        self.placeCategories = placeCategories
        self.placeAddress = placeAddress
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(myReviewDTO: MyReviewDTO) {
        self.id = myReviewDTO.reviewId
        self.placeId = myReviewDTO.placeId
        self.placeName = myReviewDTO.placeName
        self.placeCategories = myReviewDTO.placeCategories
        self.placeAddress = myReviewDTO.placeAddress
        self.content = myReviewDTO.content
        self.createdAt = myReviewDTO.createdAt
        self.updatedAt = myReviewDTO.updatedAt
    }
}
