import Foundation

protocol PlaceServiceProtocol {
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailResponseDTO
}
