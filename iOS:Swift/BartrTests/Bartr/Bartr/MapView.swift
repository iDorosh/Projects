//
//  MapView.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/26/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import MapKit

class MapView: UIViewController, MKMapViewDelegate {
//Variables
    //Latitude and Longitude passed from the details screen for the listing location
    var lat : Double = Double()
    var lon : Double = Double()
    
    //Circle overlay for the postition
    var circle:MKCircle!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    //Full screen map view
    @IBOutlet weak var mapView: MKMapView!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewWillAppear(_ animated: Bool) { loadUI() }
    
    override func viewDidLoad() {
        //Setting map delegate to create a cirlce overlay
        mapView.delegate = self
        super.viewDidLoad()
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Loading the UI
    func loadUI(){
        //Create a overlay and offset its position
        loadOverlayForRegionWithLatitude(lat + Double.random(0.01, 0.001), andLongitude: lon + Double.random(0.001, 0.01))
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Adding overlay to mapview
    func loadOverlayForRegionWithLatitude(_ latitude: Double, andLongitude longitude: Double) {
        //Setting coordinates to the ones passed from the details view
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //Creating a circle for the overlay
        circle = MKCircle(center: coordinates, radius: 2000)
        //Zooming in on the coordinates
        self.mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)), animated: true)
        //Adding the overlay
        self.mapView.add(circle)
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Creating circle size color and alpha
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = hexStringToUIColor("#f27163").withAlphaComponent(0.4)
        circleRenderer.strokeColor = hexStringToUIColor("#f27163")
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
