import Foundation

struct SendEmailResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmailDTOContainer?
}

struct EmailDTOContainer: Decodable {
    let email: String
    let expirationMinutes: Int
}
