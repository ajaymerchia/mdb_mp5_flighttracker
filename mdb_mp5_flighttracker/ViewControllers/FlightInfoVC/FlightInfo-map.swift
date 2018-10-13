//
//  FlightInfo-map.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/11/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension FlightInfoViewController: MKMapViewDelegate {
    func initMap() {
        mapView = MKMapView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width, height: view.frame.height-UIApplication.shared.statusBarFrame.maxY))
        mapView.mapType = .satellite
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let destination = MKPointAnnotation()
        
        destination.coordinate = (FLIGHT.arrivingAirport?.location?.coordinate)!
        destination.title = FLIGHT.arrivingAirport?.fullname
        
        
        mapView.addAnnotation(destination)
        
        
        let source = MKPointAnnotation()
        source.coordinate = (FLIGHT.departingAirport?.location?.coordinate)!
        source.title = FLIGHT.departingAirport?.fullname
        
        
        view.addSubview(mapView)
        
        mapView.showAnnotations([source, destination], animated: true)
        
        var coordinates = [source.coordinate, destination.coordinate]
        
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        mapView.addOverlay(geodesicPolyline)
        
        
        let paddingOfMap = 1.5
        debugPrint(UIApplication.shared.statusBarFrame.maxY)
        var latDelta = abs(destination.coordinate.latitude - source.coordinate.latitude) * paddingOfMap
        let lonDelta = abs(destination.coordinate.longitude - source.coordinate.longitude) * paddingOfMap
        
        let percentToUse = (mapView.frame.height - heightOfPane)/mapView.frame.height
        latDelta = Double(CGFloat(latDelta)/(percentToUse))
        
        if latDelta > 180 {
            latDelta = 180
        }
        
        let centerY = max(destination.coordinate.latitude,source.coordinate.latitude) - latDelta/2.8
        let centerX = (destination.coordinate.longitude + source.coordinate.longitude)/2
        
        let spanny = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let centerman = CLLocationCoordinate2D(latitude: centerY, longitude: centerX)
        
        mapView.setRegion(MKCoordinateRegion(center: centerman, span: spanny), animated: true)
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = Constants.DEEP_BLUE
        polylineRenderer.alpha = 0.9
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
}
