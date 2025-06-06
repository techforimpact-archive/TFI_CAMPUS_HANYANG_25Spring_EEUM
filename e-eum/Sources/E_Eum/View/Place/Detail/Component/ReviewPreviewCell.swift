import SwiftUI

struct ReviewPreviewCell: View {
    let placeID: String
    @Binding var reviews: [ReviewUIO]
    
    @State private var navigationToReviewList: Bool = false
    @State private var navigationToReviewCreate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("이용자 한줄평")
                    .bold()
                
                Spacer()
                
                if !reviews.isEmpty {
                    Button {
                        navigationToReviewList = true
                    } label: {
                        Text("모두 보기")
                            .bold()
                            .foregroundStyle(Color.pink)
                    }
                    .navigationDestination(isPresented: $navigationToReviewList) {
                        ReviewListView(placeID: placeID)
                    }
                }
            }
            .padding(.bottom, 8)
            
            if !reviews.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(reviews.prefix(3)) { review in
                            reviewItem(review: review)
                        }
                        
                        if reviews.count > 3 {
                            moreReviewsButton
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            BasicButton(title: "한줄평 작성하기", disabled: .constant(false)) {
                navigationToReviewCreate = true
            }
            .padding(.bottom, 8)
            .navigationDestination(isPresented: $navigationToReviewCreate) {
                ReviewCreateView(placeId: placeID)
            }
        }
        #if os(iOS)
        .sensoryFeedback(.selection, trigger: navigationToReviewList)
        .sensoryFeedback(.selection, trigger: navigationToReviewCreate)
        #endif
    }
}

private extension ReviewPreviewCell {
    func reviewItem(review: ReviewUIO) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(review.userNickname)
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Text("\(review.rating)")
            }
            
            if let content = review.content {
                Text(content)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(width: 160, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .foregroundStyle(Color.pink)
        )
    }
    
    var moreReviewsButton: some View {
        Button {
            navigationToReviewList = true
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .frame(width: 160, height: 100)
                .foregroundStyle(Color.gray)
                .overlay {
                    Text("한줄평 더보기")
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                }
        }
    }
}
