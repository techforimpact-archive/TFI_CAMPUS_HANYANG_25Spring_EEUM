import Foundation

enum PlaceHTTPRequestRouter {
    case getAllPlacesOnMap(token: String, latitude: Double, longitude: Double, radius: Double)
    case getPlacesOnMapByCategories(token: String, categories: [String])
    case getPlacesOnMapByKeyword(token: String, keyword: String)
    case getAllPlacesOnList(token: String, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByLocation(token: String, latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByCategories(token: String, categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlacesOnListByKeyword(token: String, keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case getPlaceDetails(token: String, placeID: String)
    case getPlaceReviews(token: String, placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String)
    case createPlaceReview(token: String, placeID: String, data: Data)
    case addFavoritePlace(token: String, data: Data)
    case cancelFavoritePlace(token: String, placeID: String)
    case myFavoritePlaces(token: String, cursor: String, size: Int, sortBy: String, sortDirection: String)
}

extension PlaceHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getAllPlacesOnMap, .getPlacesOnMapByCategories, .getPlacesOnMapByKeyword, .getAllPlacesOnList, .getPlacesOnListByLocation, .getPlacesOnListByCategories, .getPlacesOnListByKeyword, .getPlaceDetails, .getPlaceReviews, .myFavoritePlaces:
            return .get
        case .createPlaceReview, .addFavoritePlace:
            return .post
        case .cancelFavoritePlace:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAllPlacesOnMap(let token, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlacesOnMapByCategories(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlacesOnMapByKeyword(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .getAllPlacesOnList(let token, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlacesOnListByLocation(let token, _, _, _, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlacesOnListByCategories(let token, _, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlacesOnListByKeyword(let token, _, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlaceDetails(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .getPlaceReviews(let token, _, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .createPlaceReview(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "multipart/form-data"
            ]
        case .addFavoritePlace(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .cancelFavoritePlace(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .myFavoritePlaces(let token, _, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .getAllPlacesOnMap, .getPlacesOnMapByCategories, .getPlacesOnMapByKeyword, .getAllPlacesOnList, .getPlacesOnListByLocation, .getPlacesOnListByCategories, .getPlacesOnListByKeyword, .getPlaceDetails, .getPlaceReviews, .cancelFavoritePlace, .myFavoritePlaces:
            return nil
        case .createPlaceReview(_, _, let data):
            return data
        case .addFavoritePlace(_, let data):
            return data
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
        case .getPlaceDetails(_, let placeID):
            return ["v1", "places", "\(placeID)"]
        case .getPlaceReviews(_, let placeID, _, _, _, _):
            return ["v1", "places", "\(placeID)", "reviews"]
        case .createPlaceReview(_, let placeID, _):
            return ["v1", "places", "\(placeID)", "reviews"]
        case .addFavoritePlace:
            return ["v1", "places", "favorites"]
        case .cancelFavoritePlace(_, let placeID):
            return ["v1", "places", "favorites", "\(placeID)"]
        case .myFavoritePlaces:
            return ["v1", "user", "favorites"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPlaceDetails, .createPlaceReview, .addFavoritePlace, .cancelFavoritePlace:
            return nil
        case .getAllPlacesOnMap(_, let latitude, let longitude, let radius):
            let queryItems = [
                URLQueryItem(name: "mode", value: "MAP"),
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)")
            ]
            return queryItems
        case .getPlacesOnMapByCategories(_, let categories):
            var queryItems = [
                URLQueryItem(name: "mode", value: "MAP")
            ]
            for category in categories {
                queryItems.append(URLQueryItem(name: "categories", value: category))
            }
            return queryItems
        case .getPlacesOnMapByKeyword(_, let keyword):
            let queryItems = [
                URLQueryItem(name: "mode", value: "MAP"),
                URLQueryItem(name: "name", value: keyword)
            ]
            return queryItems
        case .getAllPlacesOnList(_, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .getPlacesOnListByLocation(_, let latitude, let longitude, let radius, let lastID, let size, let sortBy, let sortDirection):
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
        case .getPlacesOnListByCategories(_, let categories, let lastID, let size, let sortBy, let sortDirection):
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
        case .getPlacesOnListByKeyword(_, let keyword, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "mode", value: "LIST"),
                URLQueryItem(name: "name", value: keyword),
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .getPlaceReviews(_, _, let lastID, let size, let sortBy, let sortDirection):
            let queryItems = [
                URLQueryItem(name: "lastId", value: lastID),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "sortBy", value: sortBy),
                URLQueryItem(name: "sortDirection", value: sortDirection)
            ]
            return queryItems
        case .myFavoritePlaces(_, let cursor, let size, let sortBy, let sortDirection):
            var queryItems: [URLQueryItem] = []
            if cursor.isEmpty {
                queryItems = [
                    URLQueryItem(name: "size", value: "\(size)"),
                    URLQueryItem(name: "sortBy", value: sortBy),
                    URLQueryItem(name: "sortDirection", value: sortDirection)
                ]
            } else {
                queryItems = [
                    URLQueryItem(name: "cursor", value: cursor),
                    URLQueryItem(name: "size", value: "\(size)"),
                    URLQueryItem(name: "sortBy", value: sortBy),
                    URLQueryItem(name: "sortDirection", value: sortDirection)
                ]
            }
            return queryItems
        }
    }
}
