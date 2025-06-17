import Foundation

struct PlaceListResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PlaceListDTOContainer?
}

struct PlaceListDTOContainer: Decodable {
    let contents: [PlaceDTO]
    let hasNext: Bool
    let nextCursor: String?
}
