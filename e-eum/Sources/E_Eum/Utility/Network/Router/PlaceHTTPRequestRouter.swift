import Foundation

enum PlaceHTTPRequestRouter {
    case getPlaceDetails(placeID: String)
}

extension PlaceHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getPlaceDetails:
                return .get
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
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPlaceDetails:
            return nil
        }
    }
}
