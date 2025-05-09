#if os(iOS)
import SwiftUI
import MapKit

struct MapiOSView: View {
    @State private var placeService = PlaceService()
    @State private var showDetail: Bool = false
    @State private var selectedPlaceID: String = ""
    
    let latitude: Double
    let longitude: Double
    @Binding var places: [PlaceUIO]
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))) {
                UserAnnotation()
                
                ForEach(places) { place in
                    Annotation(place.name, coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title)
                            .onTapGesture {
                                selectedPlaceID = place.id
                                showDetail = true
                            }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
            }
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .sheet(isPresented: $showDetail) {
                PlaceDetailView(placeID: $selectedPlaceID)
            }
        } else {
            Text("지도는 iOS 17 이상에서만 지원됩니다.")
                .font(.title)
        }
    }
}
#endif
