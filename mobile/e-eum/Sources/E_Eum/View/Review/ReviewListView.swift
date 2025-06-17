import SwiftUI

struct ReviewListView: View {
    let placeID: String
    
    @State private var placeService = PlaceService()
    @State private var reviews: [ReviewUIO] = []
    @State private var hasNext: Bool = false
    @State private var nextCursor: String? = nil
    @State private var navigationToReviewCreate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(reviews) { review in
                        ReviewListCell(review: review)
                            .onAppear {
                                loadMoreReviews(reviewID: review.id)
                            }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BasicButton(title: "한줄평 작성하기", disabled: .constant(false)) {
                navigationToReviewCreate = true
            }
            .padding(16)
            .navigationDestination(isPresented: $navigationToReviewCreate) {
                ReviewCreateView(placeId: placeID)
            }
        }
        .navigationTitle(Text("이용자 한줄평"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadInitialReviews()
        }
    }
}

private extension ReviewListView {
    func loadInitialReviews() {
        Task {
            do {
                let reviewList = try await placeService.getPlaceReviews(placeID: placeID, lastID: "", size: 10, sortBy: "rating", sortDirection: "DESC")
                self.reviews = reviewList.reviews
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
    
    func loadMoreReviews(reviewID: String) {
        Task {
            do {
                if let lastID = reviews.last?.id {
                    if reviewID == lastID {
                        let additionalReviewList = try await placeService.getPlaceReviews(placeID: placeID, lastID: reviewID, size: 10, sortBy: "rating", sortDirection: "DESC")
                        self.reviews.append(contentsOf: additionalReviewList.reviews)
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
