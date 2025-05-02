import Foundation

class PlaceService: PlaceServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlaceDetails(placeID: placeID)
        let data = try await networkUtility.request(router: router)
        let placeDetailsResponse = try jsonDecoder.decode(PlaceDetailResponseDTO.self, from: data)
        return placeDetailsResponse
    }
    
    func getPlaceReviews(placeID: String, lastId: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlaceReviews(placeID: placeID, lastId: lastId, size: size, sortBy: sortBy, sortDirection: sortDirection)
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
