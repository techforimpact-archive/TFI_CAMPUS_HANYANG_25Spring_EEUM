import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var placeID: String
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    @State private var reviews: [ReviewUIO]?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16) {
                SheetHeader()
                
                if let place = place {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            Image("sample")
                                .resizable()
                                .scaledToFit()
                            
                            PlaceDetailTitleCell(place: place)
                            
                            Divider()
                            
                            PlaceDetailInfoCell(place: place)
                            
                            Divider()
                            
                            PlaceDetailTemperatureCell(place: place)
                            
                            Divider()
                            
                            PlaceDetailDescriptionCell(place: place)
                            
                            Divider()
                            
                            if let reviews = reviews {
                                ReviewPreviewCell(placeID: placeID, reviews: reviews)
                            } else {
                                BasicButton(title: "한줄평 작성하기") {
                                    
                                }
                                .padding(.bottom, 8)
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .task {
                do {
                    place = try await placeService.getPlaceDetails(placeID: placeID)
//                    reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: placeID, size: 3, sortBy: "reviewStats.temperature", sortDirection: "DESC").reviews
                    reviews = ReviewUIO.samples
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
