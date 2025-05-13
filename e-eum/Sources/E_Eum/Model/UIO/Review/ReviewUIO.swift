import Foundation

struct ReviewUIO: Identifiable {
    let id: String
    let placeId: String
    let userId: String
    let userNickname: String
    let content: String
    let rating: Int
    let createdAt: String
    let recommended: Bool
    
    init(id: String, placeId: String, userId: String, userNickname: String, content: String, rating: Int, createdAt: String, recommended: Bool) {
        self.id = id
        self.placeId = placeId
        self.userId = userId
        self.userNickname = userNickname
        self.content = content
        self.rating = rating
        self.createdAt = createdAt
        self.recommended = recommended
    }
    
    init(reviewDTO: ReviewDTO) {
        self.id = reviewDTO.id
        self.placeId = reviewDTO.placeId
        self.userId = reviewDTO.userId
        self.userNickname = reviewDTO.userNickname
        self.content = reviewDTO.content
        self.rating = reviewDTO.rating
        self.createdAt = reviewDTO.createdAt
        self.recommended = reviewDTO.recommended
    }
}
