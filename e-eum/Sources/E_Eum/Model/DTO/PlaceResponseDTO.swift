import Foundation

struct PlaceResponseDTO: Decodable, Identifiable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let province: String
    let city: String
    let district: String
    let categories: [String]
    let temperature: Double
    let status: String
    let verified: Bool
}
