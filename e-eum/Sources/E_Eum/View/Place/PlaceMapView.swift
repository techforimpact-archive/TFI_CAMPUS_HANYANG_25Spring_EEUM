import SwiftUI

struct PlaceMapView: View {
    let latitude: Double = 37.557303
    let longitude: Double = 127.046525
    
    var body: some View {
        #if os(iOS)
        MapiOSView(latitude: latitude, longitude: longitude)
        #elseif os(Android)
        MapAndroidView(latitude: latitude, longitude: longitude)
        #endif
    }
}
