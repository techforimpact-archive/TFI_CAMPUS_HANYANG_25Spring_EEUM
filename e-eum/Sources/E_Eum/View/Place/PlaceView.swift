import SwiftUI

enum PlaceViewType: String, CaseIterable {
    case map = "지도"
    case list = "목록"
}

struct PlaceView: View {
    @AppStorage("place") var placeViewType: PlaceViewType = PlaceViewType.map
    
    var body: some View {
        ZStack {
            switch placeViewType {
            case .map:
                PlaceMapView()
            case .list:
                PlaceListView()
            }
            
            VStack {
                Spacer()
                
                Picker("", selection: $placeViewType) {
                    ForEach(PlaceViewType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
                .padding()
            }
        }
    }
}
