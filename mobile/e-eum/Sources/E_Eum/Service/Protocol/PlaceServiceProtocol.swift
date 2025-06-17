import Foundation
import UIKit

protocol PlaceServiceProtocol {
    func getAllPlacesOnMap(latitude: Double, longitude: Double, radius: Double) async throws -> [PlaceUIO]
    func getPlacesOnMapByCategories(categories: [String]) async throws -> [PlaceUIO]
    func getPlacesOnMapByKeyword(keyword: String) async throws -> [PlaceUIO]
    func getAllPlacesOnList(lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByLocation(latitude: Double, longitude: Double, radius: Double, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByCategories(categories: [String], lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlacesOnListByKeyword(keyword: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> PlaceListUIO
    func getPlaceDetails(placeID: String) async throws -> PlaceDetailUIO
    func getPlaceReviews(placeID: String, lastID: String, size: Int, sortBy: String, sortDirection: String) async throws -> ReviewListUIO
    func createPlaceReview(placeID: String, content: String, ratings: Dictionary<String, Int>, recommended: Bool, images: [UIImage]) async throws -> ReviewUIO
    func addFavoritePlace(placeID: String) async throws -> Bool
    func cancelFavoritePlace(placeID: String) async throws -> Bool
    func myFavoritePlaces(cursor: String, size: Int, sortBy: String, sortDirection: String) async throws -> FavoritePlaceListUIO
    func reportPlace(placeID: String, contentType: ContentType, reportType: ReportType) async throws -> Bool
}
