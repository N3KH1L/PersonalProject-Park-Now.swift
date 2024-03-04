import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userTrackingMode: MapUserTrackingMode = .follow

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            userLocation = location
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            userTrackingMode = .follow
        case .denied, .restricted:
            userTrackingMode = .none
        default:
            break
        }
    }
}

