import SwiftUI

struct PlaceListView: View {
    @State private var places: [PlaceUIO] = PlaceUIO.samples
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("장소 목록")
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(Color.pink)
                    .padding()
                
                ScrollView {
                    ForEach(places) { place in
                        NavigationLink {
                            PlaceDetailView()
                        } label: {
                            PlaceListCell(place: place)
                        }
                    }
                }
            }
        }
    }
}
