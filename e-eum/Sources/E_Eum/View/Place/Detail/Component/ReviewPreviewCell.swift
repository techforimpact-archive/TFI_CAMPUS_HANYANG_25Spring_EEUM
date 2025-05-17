import SwiftUI

struct ReviewPreviewCell: View {
    let placeID: String
    let reviews: [ReviewUIO]
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
                    ForEach(reviews) { review in
                        reviewItem(review: review)
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
    }
}

private extension ReviewPreviewCell {
    func reviewItem(review: ReviewUIO) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(review.userNickname)
                    .font(.title3)
                    .bold()
                
                Text(review.content)
                
                Text("\(review.rating)")
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .foregroundStyle(Color.gray.opacity(0.5))
        )
    }
}
