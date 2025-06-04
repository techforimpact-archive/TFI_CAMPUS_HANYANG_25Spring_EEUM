import SwiftUI

struct MyReviewsView: View {
    @State private var reviewService = ReviewService()
    @State private var myReviews: [MyReviewUIO] = []
    @State private var hasNext: Bool = false
    @State private var nextCursor: String? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(myReviews) { review in
                    NavigationLink {
                        PlaceDetailView(placeID: review.placeId)
                    } label: {
                        myReviewCell(review: review)
                            .padding(8)
                            .onAppear {
                                loadMoreMyReviews(reviewID: review.id)
                            }
                    }
                }
            }
        }
        .onAppear {
            loadInitialMyReviews()
        }
    }
}

private extension MyReviewsView {
    func myReviewCell(review: MyReviewUIO) -> some View {
        HStack(alignment: .top) {
            Image("user_image", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(review.placeName)
                        .font(.title3)
                        .bold()
                    
                    Text("작성일 : " + review.createdAt.prefix(10))
                        .font(.caption)
                    
                    Text(review.content)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
            .foregroundStyle(Color.black)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(Color.pink)
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension MyReviewsView {
    func loadInitialMyReviews() {
        Task {
            do {
                let reviewList = try await reviewService.myReviews(cursor: "", size: 10, sortBy: "createdAt", sortDirection: "DESC")
                self.myReviews = reviewList.reviews
                self.hasNext = reviewList.hasNext
                if let nextCursor = reviewList.nextCursor {
                    self.nextCursor = nextCursor
                } else {
                    self.nextCursor = nil
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMoreMyReviews(reviewID: String) {
        Task {
            do {
                if let lastID = myReviews.last?.id {
                    if reviewID == lastID {
                        let additionalReviewList = try await reviewService.myReviews(cursor: reviewID, size: 10, sortBy: "createdAt", sortDirection: "DESC")
                        self.myReviews.append(contentsOf: additionalReviewList.reviews)
                        self.hasNext = additionalReviewList.hasNext
                        if let nextCursor = additionalReviewList.nextCursor {
                            self.nextCursor = nextCursor
                        } else {
                            self.nextCursor = nil
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
