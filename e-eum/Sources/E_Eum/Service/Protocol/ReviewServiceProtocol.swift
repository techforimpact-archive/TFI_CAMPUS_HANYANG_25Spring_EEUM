import Foundation

protocol ReviewServiceProtocol {
    func getReview(reviewID: String) async throws -> ReviewResponseDTO
    func modifyReview(reviewID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewResponseDTO
    func deleteReview(reviewID: String) async throws -> ReviewResponseDTO
    func getQuestions() async throws -> QuestionResponseDTO
}
