import Foundation

class PlaceService: PlaceServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> [PlaceUIO] {
        let router = PlaceHTTPRequestRouter.getAllPlacesOnMap(latitude: latitude, longitude: longitude, radius: radius)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.places {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getPlacesOnMapByCategories(latitude: Double, longitude: Double, radius: Double, categories: [String]) async throws -> [PlaceUIO] {
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByCategories(latitude: latitude, longitude: longitude, radius: radius, categories: categories)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.places {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getPlacesOnMapByKeyword(latitude: Double, longitude: Double, radius: Double, keyword: String) async throws -> [PlaceUIO] {
        let router = PlaceHTTPRequestRouter.getPlacesOnMapByKeyword(latitude: latitude, longitude: longitude, radius: radius, keyword: keyword)
        let data = try await networkUtility.request(router: router)
        let placeMapResponse = try jsonDecoder.decode(PlaceMapResponseDTO.self, from: data)
        var places: [PlaceUIO] = []
        if let placeDTOs = placeMapResponse.result?.places {
            for place in placeDTOs {
                places.append(PlaceUIO(placeDTO: place))
            }
        }
        return places
    }
    
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let router = PlaceHTTPRequestRouter.getAllPlacesOnList(lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.places, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByLocation(latitude: latitude, longitude: longitude, radius: radius, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.places, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByCategories(categories: categories, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.places, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO {
        let router = PlaceHTTPRequestRouter.getPlacesOnListByKeyword(keyword: keyword, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let placeListResponse = try jsonDecoder.decode(PlaceListResponseDTO.self, from: data)
        var placesList: PlaceListUIO
        guard let placeListDTO = placeListResponse.result else {
            throw PlaceServiceError.noData
        }
        placesList = PlaceListUIO(places: placeListDTO.places, hasNext: placeListDTO.hasNext, nextCursor: placeListDTO.nextCursor)
        return placesList
    }
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailUIO {
        let router = PlaceHTTPRequestRouter.getPlaceDetails(placeID: placeID)
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
        let router = PlaceHTTPRequestRouter.getPlaceReviews(placeID: placeID, lastID: lastID, size: size, sortBy: sortBy, sortDirection: sortDirection)
        let data = try await networkUtility.request(router: router)
        let reviewListResponse = try jsonDecoder.decode(ReviewListResponseDTO.self, from: data)
        var reviewsList: ReviewListUIO
        guard let reviewListDTO = reviewListResponse.result else {
            throw PlaceServiceError.noData
        }
        reviewsList = ReviewListUIO(reviews: reviewListDTO.reviews, hasNext: reviewListDTO.hasNext, nextCursor: reviewListDTO.nextCursor)
        return reviewsList
    }
    
    func createPlaceReview(placeID: String, reviewBody: ReviewBodyDTO) async throws -> ReviewUIO {
        let reviewBodyData = try jsonEncoder.encode(reviewBody)
        let router = PlaceHTTPRequestRouter.createPlaceReview(placeID: placeID, reviewBody: reviewBodyData)
        let data = try await networkUtility.request(router: router)
        let reviewResponse = try jsonDecoder.decode(ReviewResponseDTO.self, from: data)
        var review: ReviewUIO
        guard let reviewDTO = reviewResponse.result else {
            throw PlaceServiceError.noData
        }
        review = ReviewUIO(reviewDTO: reviewDTO)
        return review
    }
}

enum PlaceServiceError: Error {
    case noData
}
