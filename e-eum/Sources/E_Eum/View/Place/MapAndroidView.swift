#if os(Android)
import SwiftUI
import com.google.maps.android.compose.__
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng

struct MapAndroidView: View {
    let latitude: Double
    let longitude: Double
    let places: [PlaceResponseDTO]
    
    var body: some View {
        ComposeView { ctx in
            GoogleMap(
                cameraPositionState: rememberCameraPositionState {
                    position = CameraPosition.fromLatLngZoom(LatLng(latitude, longitude), Float(10.0))
                },
                properties = MapProperties(isMyLocationEnabled = true)
            ) {
                for place in places {
                    Marker(
                        state: rememberMarkerState(position = LatLng(place.latitude, place.longitude)),
                        title = place.name,
                        snippet = place.description
                    )
                }
            }
        }
    }
}
#endif
