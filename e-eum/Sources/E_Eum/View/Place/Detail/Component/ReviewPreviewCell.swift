import SwiftUI

struct ReviewPreviewCell: View {
    let placeID: String
    let reviews: [ReviewUIO]
    
    @State private var reviewPreviews: [ReviewUIO] = []
    @State private var navigationToReviewList: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("이용자 한줄평")
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(reviewPreviews) { preview in
                        reviewItem(review: preview)
                    }
                    
                    if reviews.count > reviewPreviews.count {
                        moreReviewsButton
                    }
                }
            }
            .padding(.vertical, 8)
            
            BasicButton(title: "한줄평 모두 보기", disabled: .constant(false)) {
                navigationToReviewList = true
            }
            .padding(.bottom, 8)
            .navigationDestination(isPresented: $navigationToReviewList) {
                ReviewListView(placeID: placeID)
            }
        }
        .onAppear {
            reviewPreviews = reviews.suffix(3)
        }
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
