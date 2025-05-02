import Foundation

struct ReviewListResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [ReviewListDTO]?
}

