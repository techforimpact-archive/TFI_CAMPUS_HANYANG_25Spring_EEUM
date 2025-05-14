import SwiftUI

struct ReviewListCell: View {
    let review: ReviewUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if review.recommended {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundStyle(Color.pink)
                } else {
                    Image(systemName: "hand.thumbsup")
                        .foregroundStyle(Color.gray)
                }
                
                Text(review.userNickname)
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Text("\(review.rating)")
            }
            
            Text(review.content)
                .multilineTextAlignment(.leading)
            
            Divider()
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
}
