import SwiftUI

struct MyReviewsView: View {
    @State private var reviewService = ReviewService()
    @State private var myReviews: [MyReviewUIO] = []
    @State private var hasNext: Bool = false
    @State private var nextCursor: String? = nil
    @State private var selectedReviewID: String = ""
    @State private var showDeleteAlert: Bool = false
    @State private var showDeleteSuccessAlert: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
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
        .alert("리뷰 삭제", isPresented: $showDeleteAlert) {
            Button(role: .destructive) {
                deleteReview(reviewID: selectedReviewID)
            } label: {
                Text("삭제")
            }
        } message: {
            Text("리뷰를 삭제하시겠습니까?")
        }
        .alert("리뷰가 삭제되었습니다.", isPresented: $showDeleteSuccessAlert) {
            Button {
                loadInitialMyReviews()
            } label: {
                Text("확인")
            }
        }
    }
}

private extension MyReviewsView {
    func myReviewCell(review: MyReviewUIO) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .center, spacing: 8) {
                Image("user_image", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Button {
                    selectedReviewID = review.id
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.gray)
                }
            }
            
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
    
    func deleteReview(reviewID: String) {
        Task {
            do {
                showDeleteSuccessAlert = try await reviewService.deleteReview(reviewID: reviewID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
