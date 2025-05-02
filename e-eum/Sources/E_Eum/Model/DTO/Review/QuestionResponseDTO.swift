import Foundation

struct QuestionResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [QuestionDTO]?
}
