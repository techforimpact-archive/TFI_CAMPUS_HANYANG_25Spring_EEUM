import SwiftUI

struct PlaceCategoryTag: View {
    let category: String
    
    var body: some View {
        Text(category)
            .padding(4)
            .foregroundStyle(Color.white)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(checkCategory(category: category))
            }
    }
}

extension PlaceCategoryTag {
    func checkCategory(category: String) -> Color {
        let categoryType = PlaceCategory(rawValue: category) ?? .etc
        switch categoryType {
        case .counseling:
            return .red
        case .hospital:
            return .orange
        case .shelter:
            return .yellow
        case .legal:
            return .green
        case .cafe:
            return .blue
        case .bookstore:
            return .indigo
        case .exhibition:
            return .purple
        case .etc:
            return .gray
        }
    }
}

enum PlaceCategory: String {
    case counseling = "COUNSELING"
    case hospital = "HOSPITAL"
    case shelter = "SHELTER"
    case legal = "LEGAL"
    case cafe = "CAFE"
    case bookstore = "BOOKSTORE"
    case exhibition = "EXHIBITION"
    case etc = "ETC"
}
