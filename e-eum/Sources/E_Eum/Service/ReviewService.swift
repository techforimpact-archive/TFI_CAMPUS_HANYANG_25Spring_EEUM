import Foundation

class ReviewService: ReviewServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    private func getAccessToken() -> String {
        if let accessToken = KeychainUtility.shared.getAuthToken(tokenType: .accessToken) {
            print("accessToken 불러오기 성공")
            return accessToken
        }
        print("accessToken 불러오기 실패")
        return ""
    }
    
    private func getRefreshToken() -> String {
        if let refreshToken = KeychainUtility.shared.getAuthToken(tokenType: .refreshToken) {
            print("refreshToken 불러오기 성공")
            return refreshToken
        }
        print("refreshToken 불러오기 실패")
        return ""
    }
    
    func getReview(reviewID: String) async throws -> ReviewUIO {
        let accessToken = getAccessToken()
        let router = ReviewHTTPRequestRouter.getReview(token: accessToken, reviewID: reviewID)
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
        let accessToken = getAccessToken()
        let router = ReviewHTTPRequestRouter.deleteReview(token: accessToken, reviewID: reviewID)
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
        let accessToken = getAccessToken()
        let router = ReviewHTTPRequestRouter.getQuestions(token: accessToken)
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
    
    func myReviews(cursor: String, size: Int, sortBy: String, sortDirection: String) async throws -> MyReviewListUIO {
        let accessToken = getAccessToken()
        let router = ReviewHTTPRequestRouter.myReviews(token: accessToken, cursor: cursor, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let reviewListResponse = try jsonDecoder.decode(MyReviewListResponseDTO.self, from: data)
        var reviewsList: MyReviewListUIO
        guard let reviewListDTO = reviewListResponse.result else {
            throw PlaceServiceError.noData
        }
        reviewsList = MyReviewListUIO(reviews: reviewListDTO.contents, hasNext: reviewListDTO.hasNext, nextCursor: reviewListDTO.nextCursor)
        return reviewsList
    }
}

enum ReviewServiceError: Error {
    case noData
}
