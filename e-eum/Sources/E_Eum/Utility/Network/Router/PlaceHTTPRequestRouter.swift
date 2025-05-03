import Foundation

enum PlaceHTTPRequestRouter {
    case getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double)
    case getPlacesOnMapByCategories(latitude: Double, longitude: Double, radius: Double, categories: [String])
    case getPlacesOnMapByKeyword(latitude: Double, longitude: Double, radius: Double, keyword: String)
    case getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlaceDetails(placeID: String)
    case getPlaceReviews(placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case createPlaceReview(placeID: String, reviewBody: Data)
}

extension PlaceHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getAllPlacesOnMap, .getPlacesOnMapByCategories, .getPlacesOnMapByKeyword, .getAllPlacesOnList, .getPlacesOnListByLocation, .getPlacesOnListByCategories, .getPlacesOnListByKeyword, .getPlaceDetails, .getPlaceReviews:
            return .get
        case .createPlaceReview:
            return .post
        }
    }
    
    var headers: [String : String]? { return nil }
    
    var body: Data? {
        switch self {
        case .getAllPlacesOnMap, .getPlacesOnMapByCategories, .getPlacesOnMapByKeyword, .getAllPlacesOnList, .getPlacesOnListByLocation, .getPlacesOnListByCategories, .getPlacesOnListByKeyword, .getPlaceDetails, .getPlaceReviews:
            return nil
        case .createPlaceReview(_, let reviewBody):
            return reviewBody
        }
    }
    
    var host: String { return AppEnvironment.serverAddress }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getAllPlacesOnMap:
            return ["v1", "places"]
        case .getPlacesOnMapByCategories:
            return ["v1", "places"]
        case .getPlacesOnMapByKeyword:
            return ["v1", "places"]
        case .getAllPlacesOnList:
            return ["v1", "places"]
        case .getPlacesOnListByLocation:
            return ["v1", "places"]
        case .getPlacesOnListByCategories:
            return ["v1", "places"]
        case .getPlacesOnListByKeyword:
            return ["v1", "places"]
        case .getPlaceDetails(let placeID):
            return ["v1", "places", "\(placeID)"]
        case .getPlaceReviews(let placeID, _, _, _, _):
            return ["v1", "places", "\(placeID)", "reviews"]
        case .createPlaceReview(let placeID, _):
            return ["v1", "places", "\(placeID)", "reviews"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPlaceDetails, .createPlaceReview:
            return nil
        case .getAllPlacesOnMap(let latitude, let longitude, let radius):
            let queryItems = [
                URLQueryItem(name: "mode", value: "MAP"),
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)")
            ]
            return queryItems
        case .getPlacesOnMapByCategories(let latitude, let longitude, let radius, let categories):
            var queryItems = [
                URLQueryItem(name: "mode", value: "MAP"),
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)")
            ]
            for category in categories {
                queryItems.append(URLQueryItem(name: "categories", value: category))
            }
            return queryItems
        case .getPlacesOnMapByKeyword(let latitude, let longitude, let radius, let keyword):
            let queryItems = [
                URLQueryItem(name: "mode", value: "MAP"),
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "keyword", value: keyword)
            ]
            return queryItems
        case .getAllPlacesOnList(let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .getPlacesOnListByLocation(let latitude, let longitude, let radius, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .getPlacesOnListByCategories(let categories, let lastID, let size, let sortBy, let sortDirection):
            var queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            for category in categories {
                queryItems.append(URLQueryItem(name: "categories", value: category))
            }
            return queryItems
        case .getPlacesOnListByKeyword(let keyword, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "keyword", value: keyword),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .getPlaceReviews(_, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        }
    }
}
