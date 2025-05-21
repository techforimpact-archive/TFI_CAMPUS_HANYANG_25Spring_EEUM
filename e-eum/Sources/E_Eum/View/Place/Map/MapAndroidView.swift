#if os(Android)
import SwiftUI
import com.google.maps.android.compose.__
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng

struct MapAndroidView: View {
    @State private var placeService = PlaceService()
    @State private var showDetail: Bool = false
    @State private var selectedPlaceID: String = ""
    
    let latitude: Double
    let longitude: Double
    @Binding var places: [PlaceUIO]
    
    var body: some View {
        ComposeView { ctx in
            GoogleMap(
                cameraPositionState: rememberCameraPositionState {
                    position = CameraPosition.fromLatLngZoom(LatLng(latitude, longitude), Float(13.0))
                },
                properties = MapProperties(isMyLocationEnabled = true)
            ) {
                for place in places {
                    Marker(
                        state: rememberMarkerState(position = LatLng(place.latitude, place.longitude)),
                        title = place.name,
                        onClick = { marker in
                            withAnimation {
                                selectedPlaceID = place.id
                                showDetail = true
                            }
                            true
                        }
                    )
                }
            }
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            PlaceDetailView(placeID: selectedPlaceID, isNavigation: false)
        })
    }
}
#endif
