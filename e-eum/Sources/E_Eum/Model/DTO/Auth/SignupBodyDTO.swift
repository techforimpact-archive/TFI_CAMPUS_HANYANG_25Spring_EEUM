import Foundation

struct SignupBodyDTO: Encodable {
    let nickname: String
    let email: String
    let password: String
}
