import Foundation

protocol PlaceServiceProtocol {
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO
    func getPlaceReviews(placeID: String, lastId: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListResponseDTO
    func createPlaceReview(placeID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewResponseDTO
}
