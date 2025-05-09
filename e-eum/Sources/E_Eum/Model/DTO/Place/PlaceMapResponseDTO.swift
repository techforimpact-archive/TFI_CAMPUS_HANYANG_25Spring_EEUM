import Foundation

struct PlaceMapResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PlaceDTOContainer?
}

struct PlaceDTOContainer: Decodable {
    let places: [PlaceDTO]
}
