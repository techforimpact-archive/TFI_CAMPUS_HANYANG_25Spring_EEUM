import Foundation

protocol ReviewServiceProtocol {
    func getReview(reviewID: String) async throws -> ReviewUIO
    func modifyReview(reviewID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewUIO
    func deleteReview(reviewID: String) async throws -> ReviewUIO
    func getQuestions() async throws -> [QuestionUIO]
}
