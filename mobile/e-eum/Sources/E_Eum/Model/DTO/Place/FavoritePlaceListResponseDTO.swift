import Foundation

struct FavoritePlaceListResponseDTO: Decodable {
    let httpStatus: String?
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FavoritePlaceListDTOContainer?
}

struct FavoritePlaceListDTOContainer: Decodable {
    let contents: [FavoritePlaceDTO]
    let hasNext: Bool
    let nextCursor: String?
}
