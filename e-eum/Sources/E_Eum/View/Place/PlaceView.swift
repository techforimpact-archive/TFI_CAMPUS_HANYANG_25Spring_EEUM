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
                    .padding(.bottom, 50)
            case .list:
                PlaceListView()
                    .padding(.bottom, 50)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Picker("", selection: $placeViewType) {
                        ForEach(PlaceViewType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150, height: 34)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    
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
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .frame(height: 50)
                .background(Color.white.opacity(0.8))
            }
        }
    }
}
