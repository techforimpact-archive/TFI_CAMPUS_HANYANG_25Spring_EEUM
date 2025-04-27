import Foundation

class PlaceService: PlaceServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO {
        let router = PlaceHTTPRequestRouter.getPlaceDetails(placeID: placeID)
        let data = try await networkUtility.request(router: router)
        let placeDetailsResponse = try jsonDecoder.decode(PlaceDetailResponseDTO.self, from: data)
        return placeDetailsResponse
    }
}
