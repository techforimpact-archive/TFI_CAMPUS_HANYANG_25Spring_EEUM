import SwiftUI

struct PlaceListView: View {
    @State private var placeService = PlaceService()
    
    var body: some View {
        Text("Place List View")
            .onAppear {
                Task {
                    do {
                        let place: PlaceDetailResponseDTO = try await placeService.getPlaceDetails(placeID: "6808f62a8b1ef1775814ebdb")
                        if let result = place.result {
                            print(result)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }
}
