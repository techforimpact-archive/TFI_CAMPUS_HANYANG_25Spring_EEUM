import SwiftUI

struct PlaceListView: View {
    @State private var placeService = PlaceService()
    @State private var places: [PlaceUIO] = []
    @State private var showDetail: Bool = false
    @State private var selectedPlaceID: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                header
                
                ScrollView {
                    ForEach(places) { place in
                        NavigationLink {
                            PlaceDetailView(placeID: place.id, isNavigation: true)
                        } label: {
                            PlaceListCell(place: place)
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
        }
    }
}

private extension PlaceListView {
    var header: some View {
        HStack {
            RainbowColorTitle(text: "장소 목록", font: .title)
            
            Spacer()
            
            Button {
                
            } label: {
                Circle()
                    .frame(width: 34, height: 34)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.white)
                    }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}
