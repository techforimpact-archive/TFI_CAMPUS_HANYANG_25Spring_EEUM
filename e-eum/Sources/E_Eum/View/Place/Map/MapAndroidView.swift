#if os(Android)
import SwiftUI
import com.google.maps.android.compose.__
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.BitmapDescriptorFactory

struct MapAndroidView: View {
    @State private var placeService = PlaceService()
    
    let latitude: Double
    let longitude: Double
    @Binding var places: [PlaceUIO]
    @Binding var showPreview: Bool
    @Binding var selectedPlaceID: String
    
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
                        icon = BitmapDescriptorFactory.defaultMarker(checkCategoryTagColor(category: place.categories[0])),
                        onClick = { marker in
                            withAnimation {
                                selectedPlaceID = place.id
                                showPreview = true
                            }
                            true
                        }
                    )
                }
            }
        }
    }
}

private extension MapAndroidView {
    func checkCategoryTagColor(category: String) -> Float {
        let categoryType = PlaceCategory(rawValue: category) ?? .etc
        switch categoryType {
        case .counseling:
            return BitmapDescriptorFactory.HUE_RED
        case .hospital:
            return BitmapDescriptorFactory.HUE_ORANGE
        case .shelter:
            return BitmapDescriptorFactory.HUE_YELLOW
        case .legal:
            return BitmapDescriptorFactory.HUE_GREEN
        case .cafe:
            return BitmapDescriptorFactory.HUE_BLUE
        case .bookstore:
            return BitmapDescriptorFactory.HUE_VIOLET
        case .exhibition:
            return BitmapDescriptorFactory.HUE_MAGENTA
        case .etc:
            return BitmapDescriptorFactory.HUE_CYAN
        }
    }
}
#endif
