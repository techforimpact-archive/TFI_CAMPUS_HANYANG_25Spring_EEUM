#if os(iOS)
import SwiftUI
import MapKit

struct MapiOSView: View {
    @State private var placeService = PlaceService()
    
    let latitude: Double
    let longitude: Double
    @Binding var places: [PlaceUIO]
    @Binding var showPreview: Bool
    @Binding var selectedPlaceID: String
    
    @Namespace var mapScope
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            ZStack(alignment: .bottomTrailing) {
                Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))), scope: mapScope) {
                    UserAnnotation()
                    
                    ForEach(places) { place in
                        Annotation(place.name, coordinate: CLLocationCoordinate2D(
                            latitude: place.latitude,
                            longitude: place.longitude
                        )) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(checkCategoryTagColor(category: place.categories[0]))
                                .font(.title)
                                .onTapGesture {
                                    selectedPlaceID = place.id
                                    showPreview = true
                                }
                        }
                    }
                }
                .mapControlVisibility(.hidden)
                .mapStyle(.standard(pointsOfInterest: .excludingAll))
                
                VStack {
                    MapCompass(scope: mapScope)
                        .padding(.horizontal)
                    
                    MapUserLocationButton(scope: mapScope)
                        .frame(width: 40, height: 40)
                        .labelStyle(.iconOnly)
                        .symbolVariant(.fill)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .mapScope(mapScope)
        } else {
            Text("지도는 iOS 17 이상에서만 지원됩니다.")
                .font(.title)
        }
    }
}

private extension MapiOSView {
    func checkCategoryTagColor(category: String) -> Color {
        let categoryType = PlaceCategory(rawValue: category) ?? .etc
        switch categoryType {
        case .counseling:
            return .red
        case .hospital:
            return .orange
        case .shelter:
            return .yellow
        case .legal:
            return .green
        case .cafe:
            return .blue
        case .bookstore:
            return .indigo
        case .religion:
            return .purple
        case .etc:
            return .gray
        }
    }
}
#endif
