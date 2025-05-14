import SwiftUI

struct ReviewListView: View {
    let placeID: String
    
    @State private var placeService = PlaceService()
    @State private var reviews: [ReviewUIO]?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let reviews = reviews {
                ScrollView {
                    ForEach(reviews) { review in
                        ReviewListCell(review: review)
                            .padding(.top, 8)
                    }
                }
            }
            
            Spacer()
            
            BasicButton(title: "한줄평 작성하기") {
                
            }
            .padding(16)
        }
        .navigationTitle(Text("이용자 한줄평"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
//                reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: placeID, size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC").reviews
                reviews = ReviewUIO.samples
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
