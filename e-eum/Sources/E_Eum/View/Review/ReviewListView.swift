import SwiftUI

struct ReviewListView: View {
    let placeID: String
    
    @State private var placeService = PlaceService()
    @State private var reviews: [ReviewUIO] = []
    @State private var navigationToReviewCreate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ForEach(reviews) { review in
                    ReviewListCell(review: review)
                        .padding(.top, 8)
                }
            }
            
            Spacer()
            
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
        .task {
            do {
                reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: nil, size: nil, sortBy: nil, sortDirection: nil).reviews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
