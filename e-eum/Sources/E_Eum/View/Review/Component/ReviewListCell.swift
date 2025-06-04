import SwiftUI

struct ReviewListCell: View {
    let review: ReviewUIO
    
    var body: some View {
        HStack(alignment: .top) {
            Image("user_image", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text(review.userNickname)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Text(review.createdAt.prefix(10))
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    if let content = review.content {
                        Text(content)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.black)
                    }
                    
                    Spacer()
                    
                    if let imageUrl = review.imageUrls.first {
                        AsyncImage(url: URL(string: imageUrl)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(Color.pink)
                        }
                    }
                }
            }
            .padding()
            .foregroundStyle(Color.black)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(Color.pink)
            }
        }
    }
}
