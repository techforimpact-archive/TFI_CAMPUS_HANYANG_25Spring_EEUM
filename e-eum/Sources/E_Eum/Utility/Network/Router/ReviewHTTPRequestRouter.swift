import Foundation

enum ReviewHTTPRequestRouter {
    case getReview(reviewID: String)
    case modifyReview(reviewID: String)
    case deleteReview(reviewID: String)
    case getQuestions
}

extension ReviewHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getReview, .getQuestions:
            return .get
        case .modifyReview:
            return .put
        case .deleteReview:
            return .delete
        }
    }
    
    var headers: [String : String]? { return nil }
    
    var body: Data? { return nil }
    
    var host: String { return AppEnvironment.serverAddress }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getReview(let reviewID), .modifyReview(let reviewID), .deleteReview(let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .getQuestions:
            return ["v1", "reviews", "questions"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getReview, .modifyReview, .deleteReview, .getQuestions:
            return nil
        }
    }
}
