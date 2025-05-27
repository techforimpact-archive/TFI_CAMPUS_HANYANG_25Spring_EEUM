import Foundation

struct ConfirmBodyDTO: Encodable {
    let email: String
    let resetToken: String
    let newPassword: String
}
