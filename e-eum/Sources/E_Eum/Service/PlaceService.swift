import Foundation
import UIKit

class PlaceService: PlaceServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    private func getAccessToken() -> String {
        if let accessToken = KeychainUtility.shared.getAuthToken(tokenType: .accessToken) {
            print("accessToken 불러오기 성공")
            return accessToken
        }
        print("accessToken 불러오기 실패")
        return ""
    }
    
    private func getRefreshToken() -> String {
        if let refreshToken = KeychainUtility.shared.getAuthToken(tokenType: .refreshToken) {
            print("refreshToken 불러오기 성공")
            return refreshToken
        }
        print("refreshToken 불러오기 실패")
        return ""
    }
    
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> [PlaceUIO] {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getAllPlacesOnMap(token: accessToken, latitude: latitude, longitude: longitude, radius: radius)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.contents {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getPlacesOnMapByCategories(categories: [String]) async throws -> [PlaceUIO] {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByCategories(token: accessToken, categories: categories)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.contents {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getPlacesOnMapByKeyword(keyword: String) async throws -> [PlaceUIO] {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByKeyword(token: accessToken, keyword: keyword)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.contents {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getAllPlacesOnList(token: accessToken, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.contents, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlacesOnListByLocation(token: accessToken, latitude: latitude, longitude: longitude, radius: radius, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.contents, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlacesOnListByCategories(token: accessToken, categories: categories, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.contents, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlacesOnListByKeyword(token: accessToken, keyword: keyword, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.contents, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlaceDetails(token: accessToken, placeID: placeID)
        let data = try await networkUtility.request(router: router)
        let placeDetailsResponse = try jsonDecoder.decode(PlaceDetailResponseDTO.self, from: data)
        var placeDetails: PlaceDetailUIO
        guard let placeDetail = placeDetailsResponse.result else {
            throw PlaceServiceError.noData
        }
        placeDetails = PlaceDetailUIO(placeDetailDTO: placeDetail)
        return placeDetails
    }
    
    func getPlaceReviews(placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.getPlaceReviews(token: accessToken, placeID: placeID, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let reviewListResponse = try jsonDecoder.decode(ReviewListResponseDTO.self, from: data)
        var reviewsList: ReviewListUIO
        guard let reviewListDTO = reviewListResponse.result else {
            throw PlaceServiceError.noData
        }
        reviewsList = ReviewListUIO(reviews: reviewListDTO.contents, hasNext: reviewListDTO.hasNext, nextCursor: reviewListDTO.nextCursor)
        return reviewsList
    }
    
    func createPlaceReview(placeID: String, content: String, ratings: Dictionary<String, Int>, recommended: Bool, images: [UIImage]) async throws -> ReviewUIO {
        let accessToken = getAccessToken()
        var builder = MultipartForm()
        if let contentData = content.data(using: .utf8) {
            builder.append(name: "content", content: .text(data: contentData))
        }
        let ratingsData = try jsonEncoder.encode(ratings)
        builder.append(name: "ratings", content: .json(data: ratingsData))
        if let recommendedData = String(recommended).data(using: .utf8) {
            builder.append(name: "recommended", content: .text(data: recommendedData))
        }
        for image in images {
            if let jpegData = image.jpegData(compressionQuality: 0.6) {
                builder.append(
                    name: "images",
                    fileName: "\(placeID)_\(UUID().uuidString).jpeg",
                    content: .jpeg(data: jpegData)
                )
            }
        }
        guard let (boundary, data) = builder.build() else {
            throw PlaceServiceError.multipartFormBuilderError
        }
        let router = PlaceHTTPRequestRouter.createPlaceReview(token: accessToken, placeID: placeID, data: data)
        let responseData = try await networkUtility.requestWithMultipartForm(router: router, boundary: boundary)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: responseData)
        var review: ReviewUIO
        guard let reviewDTO = reviewResponse.result else {
            throw PlaceServiceError.noData
        }
        review = ReviewUIO(reviewDTO: reviewDTO)
        return review
    }
    
    func addFavoritePlace(placeID: String) async throws -> Bool {
        let accessToken = getAccessToken()
        let placeIDData = try jsonEncoder.encode(placeID)
        let router = PlaceHTTPRequestRouter.addFavoritePlace(token: accessToken, data: placeIDData)
        let data = try await networkUtility.request(router: router)
        let response = try jsonDecoder.decode(PlaceStatusResponseDTO.self, from: data)
        if response.isSuccess {
            guard let status = response.result?.status else {
                throw PlaceServiceError.noData
            }
            return status
        }
        return false
    }
    
    func cancelFavoritePlace(placeID: String) async throws -> Bool {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.cancelFavoritePlace(token: accessToken, placeID: placeID)
        let data = try await networkUtility.request(router: router)
        let response = try jsonDecoder.decode(PlaceStatusResponseDTO.self, from: data)
        if response.isSuccess {
            guard let status = response.result?.status else {
                throw PlaceServiceError.noData
            }
            return status
        }
        return false
    }
    
    func myFavoritePlaces(cursor: String, size: Int, sortBy: String, sortDirection: String) async throws -> FavoritePlaceListUIO {
        let accessToken = getAccessToken()
        let router = PlaceHTTPRequestRouter.myFavoritePlaces(token: accessToken, cursor: cursor, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(FavoritePlaceListResponseDTO.self, from: data)
        var placesList: FavoritePlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = FavoritePlaceListUIO(places: placeListDTO.contents, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
}

enum PlaceServiceError: Error {
    case tokenError
    case noData
    case multipartFormBuilderError
}
