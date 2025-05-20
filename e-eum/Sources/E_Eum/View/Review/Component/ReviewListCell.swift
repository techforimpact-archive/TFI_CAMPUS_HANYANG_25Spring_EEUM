import SwiftUI

struct ReviewListCell: View {
    let review: ReviewUIO
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
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
                    
                    Text("\(review.rating)")
                }
                
                if let content = review.content {
                    Text(content)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            if let imageUrl = review.imageUrls.first {
                AsyncImage(url: URL(string: imageUrl)!) { image in
                    image
                        .image?.resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}
