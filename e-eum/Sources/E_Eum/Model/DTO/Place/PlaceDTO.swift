import Foundation

struct PlaceDTO: Decodable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let province: String
    let city: String
    let district: String
    let fullAddress: String
    let categories: [String]
    let temperature: Double
    let status: String
    let verified: Bool
}
