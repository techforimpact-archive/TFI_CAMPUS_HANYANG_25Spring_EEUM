import SwiftUI

struct PlaceListView: View {
    @State private var placeService = PlaceService()
    @State private var places: [PlaceUIO] = []
    @State private var showDetail: Bool = false
    @State private var selectedPlaceID: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                RainbowColorTitle(text: "장소 목록", font: .title)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                
                ScrollView {
                    ForEach(places) { place in
                        PlaceListCell(place: place)
                            .onTapGesture {
                                selectedPlaceID = place.id
                                showDetail = true
                            }
                    }
                }
            }
            .task {
                do {
                    places = try await placeService.getAllPlacesOnList(lastID: "", size: 10, sortBy: "reviewStats.temperature", sortDirection: "DESC").places
                } catch {
                    print(error.localizedDescription)
                }
            }
            .sheet(isPresented: $showDetail) {
                PlaceDetailView(placeID: $selectedPlaceID)
            }
        }
    }
}
