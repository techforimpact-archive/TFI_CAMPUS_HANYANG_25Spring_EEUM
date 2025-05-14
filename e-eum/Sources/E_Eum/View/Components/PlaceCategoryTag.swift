import SwiftUI

struct PlaceCategoryTag: View {
    let category: String
    
    var body: some View {
        Text(checkCategoryTitle(category: category))
            .padding(4)
            .foregroundStyle(Color.white)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(checkCategoryTagColor(category: category))
            }
    }
}

extension PlaceCategoryTag {
    func checkCategoryTitle(category: String) -> String {
        let categoryType = PlaceCategory(rawValue: category) ?? .etc
        switch categoryType {
        case .counseling:
            return "상담"
        case .hospital:
            return "의료"
        case .shelter:
            return "쉼터"
        case .legal:
            return "법률"
        case .cafe:
            return "카페"
        case .bookstore:
            return "서점"
        case .exhibition:
            return "전시"
        case .etc:
            return "기타"
        }
    }
    
    func checkCategoryTagColor(category: String) -> Color {
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
