import Foundation

protocol PlaceServiceProtocol {
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> PlaceMapResponseDTO
    func getPlacesOnMapByCategories(latitude: Double, longitude: Double, radius: Double, categories: [String]) async throws -> PlaceMapResponseDTO
    func getPlacesOnMapByKeyword(latitude: Double, longitude: Double, radius: Double, keyword: String) async throws -> PlaceMapResponseDTO
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListResponseDTO
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO
    func getPlaceReviews(placeID: String, lastId: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListResponseDTO
    func createPlaceReview(placeID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewResponseDTO
}
