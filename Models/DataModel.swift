import Foundation
import MapKit

struct DataModel {
    static let spots = [
        
        ParkingItem(name: "Central Forum Parking", address: "Mannerheimintie 20, 00100 Helsinki, Finland", photoName: "2", place: "A6", carLimit: 15, location: CLLocationCoordinate2D(latitude: 60.1688, longitude: 24.9382), fee: 3, hour: "0.0"),
        
        ParkingItem(name: "Kamppi Center Plaza", address: "Mannerheiminaukio 1, 00100 Helsinki, Finland", photoName: "3", place: "B4", carLimit: 20, location: CLLocationCoordinate2D(latitude: 60.1696, longitude: 24.9329), fee: 4, hour: "0.0"),
        
        ParkingItem(name: "Chapel Hill Parking", address: "Fredrikinkatu 55, 00100 Helsinki, Finland", photoName: "4", place: "C2", carLimit: 25, location: CLLocationCoordinate2D(latitude: 60.1642, longitude: 24.9329), fee: 6, hour: "0.0"),
        
        ParkingItem(name: "Metro Central Parking", address: "Salomonkatu 1, 00100 Helsinki, Finland", photoName: "5", place: "A12", carLimit: 12, location: CLLocationCoordinate2D(latitude: 60.1685, longitude: 24.9314), fee: 2, hour: "0.0"),
        
        ParkingItem(name: "Bus Terminal Plaza", address: "Kamppi, 00100 Helsinki, Finland", photoName: "6", place: "B9", carLimit: 90, location: CLLocationCoordinate2D(latitude: 60.1693, longitude: 24.9312), fee: 5, hour: "0.0"),
        
        ParkingItem(name: "Glims Parking Area", address: "Glimsintie 1, 02740 Espoo, Finland", photoName: "3", place: "E5", carLimit: 30, location: CLLocationCoordinate2D(latitude: 60.2074, longitude: 24.6525), fee: 4, hour: "0.0"),
        
        ParkingItem(name: "Espoo Cultural Center", address: "Kulttuuriaukio 2, 02100 Espoo, Finland", photoName: "4", place: "E7", carLimit: 25, location: CLLocationCoordinate2D(latitude: 60.1853, longitude: 24.6559), fee: 5, hour: "0.0"),
        
        ParkingItem(name: "Nuuksio National Park Visitor Center", address: "Naruportintie 68, 02860 Espoo, Finland", photoName: "3", place: "E9", carLimit: 15, location: CLLocationCoordinate2D(latitude: 60.3387, longitude: 24.5218), fee: 6, hour: "0.0")
    ]
    
    
}

