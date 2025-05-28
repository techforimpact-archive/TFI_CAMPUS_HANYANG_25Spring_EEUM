import Foundation

struct AuthStatusResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: StatusDTOContainer?
}

struct StatusDTOContainer: Decodable {
    let status: Bool
}
