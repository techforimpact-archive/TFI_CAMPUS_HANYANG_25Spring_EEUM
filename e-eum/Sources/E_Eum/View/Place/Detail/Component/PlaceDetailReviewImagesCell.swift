import SwiftUI

struct PlaceDetailReviewImagesCell: View {
    let imageUrls: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(imageUrls, id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } placeholder: {
                        ProgressView()
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}
