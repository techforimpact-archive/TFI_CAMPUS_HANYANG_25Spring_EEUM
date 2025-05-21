import Foundation

struct PlaceDetailDTO: Decodable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let province: String
    let city: String
    let district: String
    let fullAddress: String
    let categories: [String]
    let imageUrls: [String]
    let description: String
    let phone: String
    let email: String
    let website: String
    let temperature: Double
    let reviewCount: Int
    let status: String
    let verified: Bool
}
