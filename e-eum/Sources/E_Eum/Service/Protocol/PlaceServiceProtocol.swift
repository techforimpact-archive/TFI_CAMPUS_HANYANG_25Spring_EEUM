import Foundation

protocol PlaceServiceProtocol {
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> [PlaceUIO]
    func getPlacesOnMapByCategories(latitude: Double, longitude: Double, radius: Double, categories: [String]) async throws -> [PlaceUIO]
    func getPlacesOnMapByKeyword(latitude: Double, longitude: Double, radius: Double, keyword: String) async throws -> [PlaceUIO]
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailUIO
    func getPlaceReviews(placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListUIO
    func createPlaceReview(placeID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewUIO
}
