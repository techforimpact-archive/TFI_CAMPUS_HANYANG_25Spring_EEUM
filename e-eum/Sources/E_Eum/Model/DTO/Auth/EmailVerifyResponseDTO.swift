import Foundation

struct EmailVerifyResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmailVerifyDTOContainer?
}

struct EmailVerifyDTOContainer: Decodable {
    let email: String
    let verified: Bool
}
