import SwiftUI

struct UserFavoritesAndReviewsView: View {
    @State private var selectedSection: ViewSection = .favoritePlaces
    
    var body: some View {
        VStack {
            header
            
            switch selectedSection {
            case .favoritePlaces:
                MyFavoritePlacesView()
            case .myReviews:
                MyReviewsView()
            }
        }
        .navigationTitle("나의 저장 목록 및 리뷰")
        .navigationBarTitleDisplayMode(.inline)
        #if os(iOS)
        .sensoryFeedback(.selection, trigger: selectedSection)
        #endif
    }
}

private enum ViewSection {
    case favoritePlaces
    case myReviews
}

private extension UserFavoritesAndReviewsView {
    var header: some View {
        HStack(spacing: 0) {
            Button {
                selectedSection = .favoritePlaces
            } label: {
                VStack {
                    Text("저장 목록")
                        .font(.title3)
                        .foregroundStyle(selectedSection == .favoritePlaces ? Color.pink : Color.gray)
                        .bold()
                    
                    Divider()
                        .frame(height: 2)
                        .background(selectedSection == .favoritePlaces ? Color.pink : Color.gray)
                }
            }
            
            Button {
                selectedSection = .myReviews
            } label: {
                VStack {
                    Text("리뷰")
                        .font(.title3)
                        .foregroundStyle(selectedSection == .myReviews ? Color.pink : Color.gray)
                        .bold()
                    
                    Divider()
                        .frame(height: 2)
                        .background(selectedSection == .myReviews ? Color.pink : Color.gray)
                }
            }
        }
        .frame(height: 50)
    }
}
