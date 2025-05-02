import Foundation

struct ReviewBodyDTO: Encodable {
    let content: String
    let rating: Dictionary<String, Int>
    let recommended: Bool
}
