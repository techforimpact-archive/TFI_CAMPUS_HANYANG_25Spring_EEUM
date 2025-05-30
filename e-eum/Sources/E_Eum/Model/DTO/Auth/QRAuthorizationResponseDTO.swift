import Foundation

struct QRAuthorizationResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: AccessTokenDTOContainer?
}

struct AccessTokenDTOContainer: Decodable {
    let accessToken: String
}
