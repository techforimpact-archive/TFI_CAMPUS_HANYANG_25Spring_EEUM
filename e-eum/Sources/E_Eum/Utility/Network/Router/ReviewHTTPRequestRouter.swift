import Foundation

enum ReviewHTTPRequestRouter {
    case getReview(reviewID: String)
    case modifyReview(reviewID: String, reviewBody: Data)
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
    
    var body: Data? {
        switch self {
        case .getReview, .deleteReview, .getQuestions:
            return nil
        case .modifyReview(_, let reviewBody):
            return reviewBody
        }
    }
    
    var host: String {
        #if os(iOS)
        return AppEnvironment.serverAddress
        #elseif os(Android)
        return ServerConfig.getServerAddress()
        #endif
    }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getReview(let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .modifyReview(_, let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .deleteReview(let reviewID):
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
