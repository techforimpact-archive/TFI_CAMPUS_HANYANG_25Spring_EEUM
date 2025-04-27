import Foundation

enum PlaceHTTPRequestRouter {
    case getAllPlaces(mode: String, categories: [String])
    case getPlaceDetails(placeID: String)
}

extension PlaceHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getAllPlaces, .getPlaceDetails:
                return .get
        }
    }
    
    var headers: [String : String]? { return nil }
    
    var body: Data? { return nil }
    
    var host: String { return AppEnvironment.serverIPAddress }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getAllPlaces:
            return ["v1", "places"]
        case .getPlaceDetails(let placeID):
            return ["v1", "places", "\(placeID)"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllPlaces:
            return nil
        case .getPlaceDetails:
            return nil
        }
    }
}
