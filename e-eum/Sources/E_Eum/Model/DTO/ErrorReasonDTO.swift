import Foundation

struct ErrorReasonDTO: Decodable {
    let httpStatus: String
    let isSuccess: Bool
    let code: String
    let message: String
}
