import Foundation

struct PasswordResetBodyDTO: Encodable {
    let email: String
    let resetToken: String
    let newPassword: String
}
