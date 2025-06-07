import Foundation

protocol ReviewServiceProtocol {
    func getReview(reviewID: String) async throws -> ReviewUIO
    func deleteReview(reviewID: String) async throws -> Bool
    func getQuestions() async throws -> [QuestionUIO]
    func myReviews(cursor: String, size: Int, sortBy: String, sortDirection: String) async throws -> MyReviewListUIO
}
