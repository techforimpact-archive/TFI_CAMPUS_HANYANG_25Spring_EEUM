import Foundation

struct MyReviewListResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MyReviewListDTOContainer?
}

struct MyReviewListDTOContainer: Decodable {
    let contents: [MyReviewDTO]
    let hasNext: Bool
    let nextCursor: String?
}
