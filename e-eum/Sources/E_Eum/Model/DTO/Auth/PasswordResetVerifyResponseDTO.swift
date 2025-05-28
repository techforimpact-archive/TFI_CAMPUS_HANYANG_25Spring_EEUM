import Foundation

struct PasswordResetVerifyResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PasswordResetVerifyDTOContainer?
}

struct PasswordResetVerifyDTOContainer: Decodable {
    let email: String
    let verified: Bool
    let resetToken: String
}
