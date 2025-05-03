import Foundation

class PlaceService: PlaceServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> PlaceMapResponseDTO {
        let router = PlaceHTTPRequestRouter.getAllPlacesOnMap(latitude: latitude, longitude: longitude, radius: radius)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        return placeMapResponse
    }
    
    func getPlacesOnMapByCategories(latitude: Double, longitude: Double, radius: Double, categories: [String]) async throws -> PlaceMapResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByCategories(latitude: latitude, longitude: longitude, radius: radius, categories: categories)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        return placeMapResponse
    }
    
    func getPlacesOnMapByKeyword(latitude: Double, longitude: Double, radius: Double, keyword: String) async throws -> PlaceMapResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByKeyword(latitude: latitude, longitude: longitude, radius: radius, keyword: keyword)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        return placeMapResponse
    }
    
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO {
        let router = PlaceHTTPRequestRouter.getAllPlacesOnList(lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        return placeListResponse
    }
    
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByLocation(latitude: latitude, longitude: longitude, radius: radius, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        return placeListResponse
    }
    
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByCategories(categories: categories, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        return placeListResponse
    }
    
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByKeyword(keyword: keyword, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        return placeListResponse
    }
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlaceDetails(placeID: placeID)
        let data = try await networkUtility.request(router: router)
        let placeDetailsResponse = try jsonDecoder.decode(PlaceDetailResponseDTO.self, from: data)
        return placeDetailsResponse
    }
    
    func getPlaceReviews(placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlaceReviews(placeID: placeID, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let reviewListResponse = try jsonDecoder.decode(ReviewListResponseDTO.self, from: data)
        return reviewListResponse
    }
    
    func createPlaceReview(placeID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewResponseDTO {
        let reviewBodyData = try jsonEncoder.encode(reviewBody)
        let router = PlaceHTTPRequestRouter.createPlaceReview(placeID: placeID, reviewBody: reviewBodyData)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        return reviewResponse
    }
}
