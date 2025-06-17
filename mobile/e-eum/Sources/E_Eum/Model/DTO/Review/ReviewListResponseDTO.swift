import Foundation

struct ReviewListResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ReviewListDTOContainer?
}

struct ReviewListDTOContainer: Decodable {
    let contents: [ReviewDTO]
    let hasNext: Bool
    let nextCursor: String?
}
