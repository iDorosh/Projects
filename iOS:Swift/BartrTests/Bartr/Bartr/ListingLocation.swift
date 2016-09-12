//
//  ListingLocation.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/6/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import SCLAlertView
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class ListingLocation: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UISearchControllerDelegate {
   
    @IBAction func backToLocation(_ segue: UIStoryboardSegue){}
    
//Variables 
    //View Controllers 
    var resultSearchController:UISearchController? = nil
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Data
    var type : [String] = []
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var typesString : String = String()
    var pickedPrice : String = String()
    var previousScreen : String = String()
    var editTitle : String = String()
    var editPrice : String = String()
    var editLocation : String = String()
    var editPhoto : UIImage = UIImage()
    var editType : String = String()
    var editProfileImg : String = String()
    var editUser : String = String()
    var editDetails : String = String()
    var editKey : String = String()
    var pickedTitle : String = String()
    var pickedLocation : String = String()
    var city : String = String()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImage
    var pickedImage: UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Doubles
    var lat : Double = Double()
    var lon : Double = Double()
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Booleans
    var didSelect : Bool = false
    var locationFound : Bool = false
    var zoom : Bool = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Locations
    let locationManager = CLLocationManager()
    var selectedLocation : CLLocationCoordinate2D!
    var currentLocation : CLLocation?
    var selectedPin:MKPlacemark? = nil
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
 
//Outlets
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var modalNavigation: UINavigationBar!
    @IBOutlet weak var listingNavigation: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func detailViewNext(_ sender: UIButton) {
        goToNextView()
    }
    
    @IBAction func discard(_ sender: UIBarButtonItem) {
        discardNew("Discard Listing", subTitle: "Listing will be discarded")
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
//UI
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()}
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Functions
    //Set Up View
        //Load location or go to current location
        func setUpViewDidLoad(){
            navigationController?.isNavigationBarHidden = true
            if previousScreen != "EditView"{
                loadLocation()
            } else {
                zoom = true
                loadLocation()
                dropAnnotation()
                mapView.showsUserLocation = true
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Location
        //Set up loaction manager to get the current posistion
        func setLocationManager(){
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
        
        //Load loadtion Set up search bar in navigation and get current position
        func loadLocation(){
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            
            navigationTitle.titleView = resultSearchController?.searchBar
            
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = false
            definesPresentationContext = false
            
            locationSearchTable.mapView = mapView
            
            locationSearchTable.handleMapSearchDelegate = self
            
            self.locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
        }
    
    
        //Zoom in on current position
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            lat = locValue.latitude
            lon = locValue.longitude
            if (!zoom){
                zoom = true
                movePosition()
            }
            locationManager.stopUpdatingHeading()
            locationManager.stopUpdatingLocation()
        }
    
        //Drop a pin
        func getDirections(){
            if let selectedPin = selectedPin {
                let mapItem = MKMapItem(placemark: selectedPin)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            }
        }
    
        //Move to loctation
        func movePosition(){
            let latitude:CLLocationDegrees = lat
            let longitude:CLLocationDegrees = lon
            let latDelta:CLLocationDegrees = 0.05
            let lonDelta:CLLocationDegrees = 0.05
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            if previousScreen != "EditView"{
                self.latitude = latitude
                self.longitude = longitude
                mapView.showsUserLocation = true
            }
            mapView.setRegion(region, animated: false)
        }
    
        //Drop a pin on selected location
        func dropAnnotation(){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = city
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(annotation)
        }

    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Go to next view

        func goToNextView(){
            if longitude != 0.0 && latitude != 0.0{
                if previousScreen != "EditView"{
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: {
                        placemarks, error in
                        
                        if error == nil && placemarks!.count > 0 {
                            self.city = (placemarks?.first?.locality)!
                        }
                        self.performSegue(withIdentifier: "NextInfoSegue", sender: self)
                    })
                } else {
                    self.performSegue(withIdentifier: "NextInfoSegue", sender: self)
                }
                
            } else {
                noLocation()
            }
        }

        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            UIApplication.shared.isStatusBarHidden = false
            
            if (segue.identifier == "NextInfoSegue"){
                if(previousScreen == "EditView"){
                    let details : Details = segue.destination as! Details
                    details.editType = editType
                    details.previousScreen = "EditView"
                    details.pickedImage = pickedImage
                    details.pickedTitle = pickedTitle
                    details.pickedLocation = city
                    details.editProfileImg = editProfileImg
                    details.editPhoto = editPhoto
                    details.editUser = editUser
                    details.editDetails = editDetails
                    details.editKey = editKey
                    details.pickedPrice = pickedPrice
                    details.longitude = longitude
                    details.latitude = latitude
                } else {
                    let details : Details = segue.destination as! Details
                    details.pickedImage = pickedImage
                    details.pickedTitle = pickedTitle
                    details.pickedPrice = pickedPrice
                    details.pickedLocation = city
                    details.longitude = longitude
                    details.latitude = latitude
                    }
                }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Remove listing
        func removeListing(){
            if previousScreen == "EditView"{
                performSegue(withIdentifier: "MainSegue", sender: self)
            } else {
                performSegue(withIdentifier: "MainSegue", sender: self)
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Alert Views
        //Discard listing
        func discardNew(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.showCloseButton = false
            alertView.addButton("Discard") {
                self.removeListing()
            }
            alertView.addButton("Don't Discard") {
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showWarning(title, subTitle: subTitle)
        }
        
        //No location selected
        func noLocation(){
            let alertView = SCLAlertView
            alertView.addButton("Ok"){ alertView.dismiss(animated: true, completion: nil) }
            alertView.showCloseButton = false
            alertView.showWarning("No Location", subTitle: "Please select a location from the search, or turn on location services")
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}


//Extentions

//Set a pin to the location that the user selected in the search bar
extension ListingLocation: HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark){
        didSelect = true
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
            self.city = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        longitude = placemark.coordinate.longitude
        latitude = placemark.coordinate.latitude
    }
}

//Create annotation with city and state
extension ListingLocation : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
        button.addTarget(self, action: #selector(ListingLocation.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}


