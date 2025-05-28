import Foundation

struct SigninResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SigninResultDTOContainer?
}

struct SigninResultDTOContainer: Decodable {
    let userId: String
    let nickname: String
    let email: String
    let accessToken: String
    let refreshToken: String
}
