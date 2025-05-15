import Foundation

class ReviewSevice: ReviewServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func getReview(reviewID: String) async throws -> ReviewUIO {
        let router = ReviewHTTPRequestRouter.getReview(reviewID: reviewID)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        var review: ReviewUIO
        guard let reviewDTO = reviewResponse.result else {
            throw ReviewServiceError.noData
        }
        review = ReviewUIO(reviewDTO: reviewDTO)
        return review
    }
    
    func modifyReview(reviewID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewUIO {
        let reviewBodyData = try jsonEncoder.encode(reviewBody)
        let router = ReviewHTTPRequestRouter.modifyReview(reviewID: reviewID, reviewBody: reviewBodyData)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        var review: ReviewUIO
        guard let reviewDTO = reviewResponse.result else {
            throw ReviewServiceError.noData
        }
        review = ReviewUIO(reviewDTO: reviewDTO)
        return review
    }
    
    func deleteReview(reviewID: String) async throws -> ReviewUIO {
        let router = ReviewHTTPRequestRouter.deleteReview(reviewID: reviewID)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        var review: ReviewUIO
        guard let reviewDTO = reviewResponse.result else {
            throw ReviewServiceError.noData
        }
        review = ReviewUIO(reviewDTO: reviewDTO)
        return review
    }
    
    func getQuestions() async throws -> [QuestionUIO] {
        let router = ReviewHTTPRequestRouter.getQuestions
        let data = try await networkUtility.request(router: router)
        let questionResponse = try jsonDecoder.decode(QuestionResponseDTO.self, from: data)
        var questions: [QuestionUIO] = []
        if let questionDTOs = questionResponse.result {
            for question in questionDTOs {
                questions.append(QuestionUIO(questionDTO: question))
            }
        }
        return questions
    }
}

enum ReviewServiceError: Error {
    case noData
}
