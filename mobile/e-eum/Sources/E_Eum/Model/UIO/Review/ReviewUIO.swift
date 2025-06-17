import Foundation

struct ReviewUIO: Identifiable {
    let id: String
    let placeId: String
    let userId: String
    let userNickname: String
    let content: String?
    let rating: Int
    let imageUrls: [String]
    let createdAt: String
    let recommended: Bool
    
    init(id: String, placeId: String, userId: String, userNickname: String, content: String?, rating: Int, imageUrls: [String], createdAt: String, recommended: Bool) {
        self.id = id
        self.placeId = placeId
        self.userId = userId
        self.userNickname = userNickname
        self.content = content
        self.rating = rating
        self.imageUrls = imageUrls
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
        self.imageUrls = reviewDTO.imageUrls
        self.createdAt = reviewDTO.createdAt
        self.recommended = reviewDTO.recommended
    }
}

extension ReviewUIO {
    static let sample0: ReviewUIO = .init(
        id: "sampleReview0",
        placeId: "6808f62a8b1ef1775814ebd9",
        userId: "user0",
        userNickname: "user0",
        content: "아주 좋아요",
        rating: 10,
        imageUrls: [],
        createdAt: "2025-05-13T14:01:18.925Z",
        recommended: true
    )
    
    static let sample1: ReviewUIO = .init(
        id: "sampleReview1",
        placeId: "6808f62a8b1ef1775814ebd9",
        userId: "user1",
        userNickname: "user1",
        content: "최악이에요",
        rating: 0,
        imageUrls: [],
        createdAt: "2025-05-13T14:01:18.925Z",
        recommended: false
    )
    
    static let sample2: ReviewUIO = .init(
        id: "sampleReview2",
        placeId: "6808f62a8b1ef1775814ebd9",
        userId: "user2",
        userNickname: "user2",
        content: "좋아요",
        rating: 7,
        imageUrls: [],
        createdAt: "2025-05-13T14:01:18.925Z",
        recommended: true
    )
    
    static let samples: [ReviewUIO] = [sample0, sample1, sample2]
}
