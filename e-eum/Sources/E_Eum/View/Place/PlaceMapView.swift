import SwiftUI
import SkipKit
import SkipDevice

struct PlaceMapView: View {
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    @State private var places: [PlaceResponseDTO] = []
    
    var body: some View {
        VStack {
            if let latitude = latitude, let longitude = longitude {
                #if os(iOS)
                MapiOSView(latitude: latitude, longitude: longitude, places: places)
                #elseif os(Android)
                MapAndroidView(latitude: latitude, longitude: longitude, places: places)
                #endif
            }
        }
        .onAppear {
            requestLocationAndStartMonitoring()
        }
    }
}

extension PlaceMapView {
    func requestLocationAndStartMonitoring() {
        Task {
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
                    
                    Task {
                        do {
                            for try await event in provider.monitor() {
                                self.latitude = event.latitude
                                self.longitude = event.longitude
                            }
                        } catch {
                            logger.error("error updating location: \(error)")
                        }
                    }
                }
            } catch {
                logger.error("error getting initial location: \(error)")
            }
        }
    }
}
