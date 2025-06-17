import Foundation

struct ReviewBodyDTO: Encodable {
    let content: String
    let ratings: Dictionary<String, Int>
    let recommended: Bool
}
