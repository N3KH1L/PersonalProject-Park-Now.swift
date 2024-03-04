import SwiftUI
import MapKit

class ParkingFinder: ObservableObject {
    @Published var spots = DataModel.spots
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    @Published var selectedPlace: ParkingItem?
    @Published var showDetail = false
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: DataModel.spots[0].location.latitude, longitude: DataModel.spots[0].location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
    @Published var camera = MKMapCamera(lookingAtCenter: DataModel.spots[0].location, fromEyeCoordinate: DataModel.spots[0].location, eyeAltitude: 300)

    // Update the camera when the selected place changes
    func updateCamera() {
        guard let selectedPlace = selectedPlace else { return }
        camera = MKMapCamera(lookingAtCenter: selectedPlace.location, fromEyeCoordinate: selectedPlace.location, eyeAltitude: 300)
    }
}

