import SwiftUI
import SkipKit
import SkipDevice

struct PlaceMapView: View {
    @State private var placeService = PlaceService()
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    @State private var places: [PlaceUIO] = []
    
    var body: some View {
        VStack {
            if let latitude = latitude, let longitude = longitude {
                #if os(iOS)
                MapiOSView(latitude: latitude, longitude: longitude, places: $places)
                #elseif os(Android)
                MapAndroidView(latitude: latitude, longitude: longitude, places: $places)
                #endif
            }
        }
        .task {
            await requestLocationAndStartMonitoring()
        }
    }
}

extension PlaceMapView {
    func requestLocationAndStartMonitoring() async {
        let permissionResult = await PermissionManager.requestLocationPermission(precise: true, always: false)
        
        if permissionResult.isAuthorized == false {
            logger.warning("permission refused for ACCESS_FINE_LOCATION")
            return
        }
        
        let provider = LocationProvider()
        
        do {
            if let firstLocation = try await provider.monitor().first(where: { _ in true }) {
                self.latitude = firstLocation.latitude
                self.longitude = firstLocation.longitude
                if let latitude = latitude, let longitude = longitude {
                    places = try await placeService.getAllPlacesOnMap(latitude: latitude, longitude: longitude, radius: 100000)
                }
                
                do {
                    for try await event in provider.monitor() {
                        self.latitude = event.latitude
                        self.longitude = event.longitude
                    }
                } catch {
                    logger.error("error updating location: \(error)")
                }
            }
        } catch {
            logger.error("error getting initial location: \(error)")
        }
    }
}
