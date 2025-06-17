import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않는 URL 입니다."
        case .decodingFailed:
            "디코딩에 실패하였습니다."
        }
    }
}
