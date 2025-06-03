import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeID: String
    let isNavigation: Bool
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    @State private var reviews: [ReviewUIO] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if !isNavigation {
                SheetHeader()
            }
            
            if let place = place {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        PlaceDetailReviewImagesCell(imageUrls: place.imageUrls)
                        
                        PlaceDetailTitleCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailInfoCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailTemperatureCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailDescriptionCell(place: place)
                        
                        Divider()
                        
                        ReviewPreviewCell(placeID: placeID, reviews: $reviews)
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
                reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: "", size: 5, sortBy: "rating", sortDirection: "DESC").reviews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
