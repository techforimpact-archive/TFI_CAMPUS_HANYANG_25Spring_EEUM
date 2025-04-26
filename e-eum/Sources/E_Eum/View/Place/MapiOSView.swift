#if os(iOS)
import SwiftUI
import MapKit

struct MapiOSView: View {
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
        } else {
            Text("Map requires iOS 17")
                .font(.title)
        }
    }
}
#endif
