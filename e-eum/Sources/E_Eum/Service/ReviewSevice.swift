import Foundation

class ReviewSevice: ReviewServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func getReview(reviewID: String) async throws -> ReviewResponseDTO {
        let router = ReviewHTTPRequestRouter.getReview(reviewID: reviewID)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        return reviewResponse
    }
    
    func modifyReview(reviewID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewResponseDTO {
        let reviewBodyData = try jsonEncoder.encode(reviewBody)
        let router = ReviewHTTPRequestRouter.modifyReview(reviewID: reviewID, reviewBody: reviewBodyData)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        return reviewResponse
    }
    
    func deleteReview(reviewID: String) async throws -> ReviewResponseDTO {
        let router = ReviewHTTPRequestRouter.deleteReview(reviewID: reviewID)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        return reviewResponse
    }
    
    func getQuestions() async throws -> QuestionResponseDTO {
        let router = ReviewHTTPRequestRouter.getQuestions
        let data = try await networkUtility.request(router: router)
        let questionResponse = try jsonDecoder.decode(QuestionResponseDTO.self, from: data)
        return questionResponse
    }
}
