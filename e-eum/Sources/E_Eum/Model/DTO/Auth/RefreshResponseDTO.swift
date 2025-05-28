import Foundation

struct RefreshResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenDTOContainer?
}

struct TokenDTOContainer: Decodable {
    let accessToken: String
    let refreshToken: String
}
