import Foundation

struct PlaceStatusResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: StatusDTOContainer?
}
