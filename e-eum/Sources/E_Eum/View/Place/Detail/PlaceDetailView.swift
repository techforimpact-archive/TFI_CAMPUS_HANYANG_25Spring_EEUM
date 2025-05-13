import SwiftUI

struct PlaceDetailView: View {
    @Binding var placeID: String
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            SheetHeader()
            
            if let place = place {
                ScrollView {
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
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
