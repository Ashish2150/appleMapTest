//
//  ViewController.swift
//  appleMapTest
//
//  Created by Ashish Kumar Mourya on 11/02/18.
//  Copyright © 2018 Ashish Kumar Mourya. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        /// For Annotation
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Source Location"
        
        if let location = sourcePlacemark.location{
            sourceAnnotation.coordinate = location.coordinate
            
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Destination Location"
        
        if let location = destinationPlacemark.location{
            destinationAnnotation.coordinate = location.coordinate
            
        }
        
        
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        
        /// Calculate Direction
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (response, error) in
            guard let response = response else{
                if let error = error {
                    print(error)
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.lineWidth = 4.0
        return render
    }


}

