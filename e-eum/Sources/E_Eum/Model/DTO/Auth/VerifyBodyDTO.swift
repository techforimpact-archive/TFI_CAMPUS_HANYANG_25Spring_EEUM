import Foundation

struct VerifyBodyDTO: Encodable {
    let email: String
    let verificationCode: String
}
