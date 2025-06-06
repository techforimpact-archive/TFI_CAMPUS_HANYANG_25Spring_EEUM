import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeID: String
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    @State private var reviews: [ReviewUIO] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let place = place {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        PlaceDetailReviewImagesCell(imageUrls: place.imageUrls)
                        
                        PlaceDetailTitleCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailInfoCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailTemperatureCell(temperature: place.temperature)
                        
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
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if let place = place {
                    if place.favorite {
                        Button {
                            cancelFavoritePlace()
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.red)
                        }
                    } else {
                        Button {
                            addFavoritePlace()
                        } label: {
                            Image(systemName: "heart")
                                .foregroundStyle(Color.red)
                        }
                    }
                }
            }
        })
        .onAppear {
            loadPlaceInfoAndReviews()
        }
        #if os(iOS)
        .sensoryFeedback(.impact(weight: .medium), trigger: place?.favorite)
        #endif
    }
}

private extension PlaceDetailView {
    func loadPlaceInfoAndReviews() {
        Task {
            do {
                place = try await placeService.getPlaceDetails(placeID: placeID)
                reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: "", size: 5, sortBy: "rating", sortDirection: "DESC").reviews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addFavoritePlace() {
        Task {
            do {
                place?.favorite = try await placeService.addFavoritePlace(placeID: placeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelFavoritePlace() {
        Task {
            do {
                place?.favorite = try await !placeService.cancelFavoritePlace(placeID: placeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
