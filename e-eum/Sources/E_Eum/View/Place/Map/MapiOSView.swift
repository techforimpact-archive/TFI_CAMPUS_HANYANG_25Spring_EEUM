#if os(iOS)
import SwiftUI
import MapKit

struct MapiOSView: View {
    let latitude: Double
    let longitude: Double
    let places: [PlaceUIO]
    
    @State private var showDetail: Bool = false
    
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
                PlaceDetailView()
            }
        } else {
            Text("지도는 iOS 17 이상에서만 지원됩니다.")
                .font(.title)
        }
    }
}
#endif
