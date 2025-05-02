import Foundation

enum PlaceHTTPRequestRouter {
    case getPlaceDetails(placeID: String)
    case getPlaceReviews(placeID: String, lastId: String, size: Int, sortBy: String, sortDirection: String)
    case createPlaceReview(placeID: String)
}

extension PlaceHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getPlaceDetails, .getPlaceReviews:
            return .get
        case .createPlaceReview:
            return .post
        }
    }
    
    var headers: [String : String]? { return nil }
    
    var body: Data? { return nil }
    
    var host: String { return AppEnvironment.serverAddress }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getPlaceDetails(let placeID):
            return ["v1", "places", "\(placeID)"]
        case .getPlaceReviews(let placeID, _, _, _, _):
            return ["v1", "places", "\(placeID)", "reviews"]
        case .createPlaceReview(let placeID):
            return ["v1", "places", "\(placeID)", "reviews"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPlaceDetails, .createPlaceReview:
            return nil
        case .getPlaceReviews(_, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "lastID", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        }
    }
}
