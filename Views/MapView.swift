// MapView.swift

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var spots: [ParkingItem]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        applyCustomMapStyle(to: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = region
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(spots.map { spot in
            let annotation = MKPointAnnotation()
            annotation.coordinate = spot.location
            return annotation
        })
    }

    func applyCustomMapStyle(to mapView: MKMapView) {
        if let path = Bundle.main.path(forResource: "CustomMapStyle", ofType: "json"),
           let styleURL = URL(string: "file://\(path)"),
           let style = try? String(contentsOfFile: path) {
            let overlay = MKTileOverlay(urlTemplate: styleURL.absoluteString)
            overlay.canReplaceMapContent = true
            mapView.addOverlay(overlay, level: .aboveLabels)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // Implement delegate methods if needed

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

