//
//  Search.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import M13Checkbox
import MapKit

class Search: UIViewController, UITableViewDataSource, UITextFieldDelegate, CustomIOS8AlertViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBAction func backToSearch(_ segue: UIStoryboardSegue){}
    
    override func viewDidAppear(_ animated: Bool) {updatePosts()}
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    //Filter View
    var customFilterView : CustomIOS8AlertView! = nil
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Data
    //Posts will hold all posts pulled from firebase
    var posts = [Post]()
    var post : Post!
    //All post will filter the ones in a 200 mile radius
    var allPosts = [Post]()
    
    //Filtered posts and search results will further filter the posts based on the users entry
    var filteredPosts = [Post]()
    var searchingResults = [Post]()
    
    //Array of filter types
    var type : [String] = []
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Variables
    //Strings
        //Will determing what type the user is filtering by, sold, looking, trade or free
        var filterType : String = String()
        var selectedAnnotationTitle : String = String()
        
    //Boolean
        var foundLocation : Bool = false
        var searchActive : Bool = false
        var filtered : Bool = false
        var searching = false
        var reloadPosts = false
        var locationFound : Bool = false
        
    //Integers
        var selectedPost: Int = Int()
        var distanceMiles : Int = 500
        var action : Int = 0
        
    //Checkboxes
        var forSaleState : M13Checkbox.CheckState?
        var lookingState : M13Checkbox.CheckState?
        var freeState : M13Checkbox.CheckState?
        var tradeState : M13Checkbox.CheckState?
        
    //Current Location
        var locationManager = CLLocationManager()
        var currentLocation : CLLocation!
        
    //Pull to refresh search
        var refreshControl: UIRefreshControl!

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var mapSearchArealLavel: UIButton!
    @IBOutlet weak var mapFilterBttn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var changeViewlabel: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterBttn: UIButton!
    @IBOutlet weak var searchAreaLabel: UIButton!
    
    @IBOutlet weak var tabletView: UITableView!
    @IBOutlet var cancelSearch: UIButton!
    @IBOutlet weak var viewType: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var distance: UISegmentedControl!
    
    //Checkboxes
    @IBOutlet weak var forSale: M13Checkbox!
    @IBOutlet weak var looking: M13Checkbox!
    @IBOutlet weak var trade: M13Checkbox!
    @IBOutlet weak var free: M13Checkbox!
    
    //Filter view
    @IBOutlet var filters: UIView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    //Switching between map and list view
    @IBAction func changeView(_ sender: UIButton) {
        switchViews()
    }
   
    //Cancels the search
    @IBAction func cancelClicked(_ sender: UIButton) { cancelSearching() }
    //Sets the array with the selected listings
    @IBAction func listingType(_ sender: UISegmentedControl) { setlistingType(sender.selectedSegmentIndex) }
    
    //Open filter allert
    @IBAction func showFilter(_ sender: UIButton) {
        self.view.endEditing(true)
        ShowFilters()
    }
    
    //Reset all filters
    @IBAction func resetFilters(_ sender: UIButton) {
        filtered = false
        resetFilter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Create View
        //Set up buttons location managers and refresh controller
        func setUpView(){
            filterBttn.isHidden = true
            mapFilterBttn.isHidden = true
            loadUI()
            getCheckStates()
            setLocationManager()
            setUpRefreshControl()
            mapView.delegate = self
        }

        //Set up UI and gets data
        func loadUI(){
            //Set statusbar and navigation bar
            UIApplication.shared.statusBarStyle = .default
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            //Start loading animation
            spin.startAnimating()
            spin.isHidden = false
            
            //Update firebase data and Table View
            updatePosts()
            searchBar.delegate = self
            cancelSearch.isUserInteractionEnabled = false
            cancelSearch.setTitleColor(UIColor.lightGray, for: UIControlState())
            searchBar.addTarget(self, action: #selector(self.searchDidChange(_:)), for: UIControlEvents.editingChanged)
        }
        
        //Refresh search
        func setUpRefreshControl(){
            //Creates a refresh controller and adds it to the table view
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(Search.updatePosts), for: UIControlEvents.valueChanged)
            tabletView.addSubview(refreshControl)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Set Up Table View
        //Get number of rows in the table
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return getIndexCount()
        }
    
        //Get post and return a cell with the data
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            post = getPost((indexPath as NSIndexPath).row)
            let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "MyCell")! as! CustomTableCell
            cell.configureCell(post)
            return cell
        }
    
        //Did select listing will open up listing details
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            selectedPost = (indexPath as NSIndexPath).row
            dismissKeyboard()
            performSegue(withIdentifier: "detailSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Keyboard
        //Dismiss keyboard from view
        func dismissKeyboard(){
            self.view.endEditing(true)
        }
        
        //Will update table view when the search is being entered in
        func searchDidChange(_ textView: UITextView) {
            if mapView.isHidden == true {
                searchingResults = []
                searchFirebase()
                filterBttn.isHidden = false
                searchAreaLabel.setTitle("Search Results", for: UIControlState())
                mapSearchArealLavel.setTitle("Search Results", for: UIControlState())
                mapFilterBttn.isHidden = false

            }
        }
        
        //Did end editing will complete the search
        func textFieldDidEndEditing(_ textField: UITextField) {
            if mapView.isHidden == false {
                searchFirebase()
            }
        }

        //Will set search to active and will clear the map
        func textFieldDidBeginEditing(_ textField: UITextField) {
            searchActive = true
            action = 1
            tabletView.reloadData()
            cancelSearch.isUserInteractionEnabled = true
            cancelSearch.setTitleColor(hexStringToUIColor("#2b3146"), for: UIControlState())
            if textField.text == "" {
                mapView.removeAnnotations(mapView.annotations)
            }
        }
    
        //Will allow user to filter results
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            filterBttn.isHidden = false
            searchAreaLabel.setTitle("Search Results", for: UIControlState())
            mapSearchArealLavel.setTitle("Search Results", for: UIControlState())
            mapFilterBttn.isHidden = false
            dismissKeyboard()
            return true
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Update Firebase data and Table View
        /*
        Gets all listings from firebase
        Filters out the listing to a 200 mile radius
        Adds the anotatios to the mapview
        */
        func updatePosts(){
            if !searchActive {
                DataService.dataService.POST_REF.observeSingleEvent(of: .value, with: { snapshot in
                    //Clears posts and all posts
                    self.posts = []
                    self.allPosts = []
                
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            //Will check if the post is not complete or accepted and will add it to all posts
                            if !(snap.value!.object(forKey: "postComplete") as! Bool) && !(snap.value!.object(forKey: "postFeedbackLeft") as! Bool) {
                                if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        let post = Post(key: key, dictionary: postDictionary)
                                        self.allPosts.insert(post, at: self.allPosts.endIndex
                                    )
                                }
                            }
                        }
                    }
                    //Will filter items to a 200 mile radius, stop animation adn reload table view and map
                    self.updatePostsComplete()
                })
            } else {
                //ends refresh controller if empty
                refreshControl.endRefreshing()
            }
        }
    
        func updatePostsComplete(){
            //Will filter out locations based on a 200 mile radius
            for i in self.allPosts {
                if self.loadLocation(i.lon, lat : i.lat){
                    self.posts.insert(i, at: 0)
                }
            }
            
            //End animations
            self.refreshControl.endRefreshing()
            self.spin.stopAnimating()
            self.spin.isHidden = true
            
            //Set proper object for table view
            self.action = 0
            
            //Reload tableview and drop pins
            self.tabletView.reloadData()
            self.setMapLocation()
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Query firebase
        /*
         Queries firebase based on post title
         */
        func searchFirebase(){
            //Sets search results to empty
            
            DataService.dataService.POST_REF.queryOrdered(byChild: "postTitle").observeSingleEvent(of: .value, with: {
                snapshot in
                self.searchingResults = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    //Will get post title and compares it to search bar
                    for snap in snapshots {
                        let postTitle: String = (snap.value?.object(forKey: "postTitle"))! as! String
                        let searchText: String = self.searchBar.text!
                        
                        //If the listing offer is not accepeted or feedback has not been left will append and will filter based on radius
                        if postTitle.lowercased().contains(searchText.lowercased()) && !(snap.value!.object(forKey: "postComplete") as! Bool) && !(snap.value!.object(forKey: "postFeedbackLeft") as! Bool){
                            if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let post = Post(key: key, dictionary: postDictionary)
                                if self.loadLocation(post.lon, lat: post.lat) {
                                    self.searchingResults.insert(post, at: 0)
                                }
                            }
                        }
                    }
                    
                }
                //Sets proper object for table view
                self.action = 1
                
                //Reload table view and end refresh animation
                self.tabletView.reloadData()
                self.refreshControl.endRefreshing()
                //Drop pins
                self.setMapLocation()
            })
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Map View
        //Checks if the given location is within the selected radius
        func loadLocation(_ lon: String, lat : String) -> Bool{
            let checkLocation = CLLocation(latitude: Double(lat)!, longitude: Double(lon)!)
            if currentLocation != nil {
                if currentLocation.distance(from: checkLocation)/1609 < Double(distanceMiles) {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        
        }
        
        //Will allow users to select an anotation to take them to the selected listing details
        func mapView(_ _mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Will return nil for the annotation if it is the current loaction
            if annotation is MKUserLocation {
                return nil
            }
            
            //Reuse id for the Pin annotation in the map view
            let reuseId = "pin"
            
            //Creates a pin with an annotation that includes a button for the user to click on
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = UIColor.red
                pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight) as UIButton
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
        }
        
        //Will run when the user clicks a pin annotation
        func mapView(_ MapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //Will open the detail view
            if control == annotationView.rightCalloutAccessoryView {
                selectedAnnotationTitle = ((annotationView.annotation?.title)!)!
                performSegue(withIdentifier: "detailSegue", sender: self)
            }
        }
        
        //Set up location manager
        func setLocationManager(){
            //Ask for permission
            self.locationManager.requestWhenInUseAuthorization()
            //Set up location manager if permission granted
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            
        }
        
        //Get current user location
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            //Sets current location to coordinates provided by the location manager
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            
            //Centers the current location on the map
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.30, longitudeDelta: 0.30))
            self.mapView.setRegion(region, animated: true)
            
            //Shows users location
            self.mapView.showsUserLocation = true
            
            //Stops updating location
            locationManager.stopUpdatingHeading()
            locationManager.stopUpdatingLocation()
        }
        
        //Will drop pins for all results in the appropriate objects
        func setMapLocation(){
            //Remove current annotations from map
            mapView.removeAnnotations(mapView.annotations)
            if searchActive {
                if filtered {
                    //Map pins for filtered posts
                    for i in filteredPosts {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: (Double(i.lat)! + Double.random(0.001, 0.01)), longitude: (Double(i.lon)!) + Double.random(0.001, 0.01))
                        annotation.title = i.postTitle
                        mapView.addAnnotation(annotation)
                    }
                } else {
                    //Map pins for search results
                    for i in searchingResults {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: (Double(i.lat)! + Double.random(0.001, 0.01)), longitude: (Double(i.lon)!) + Double.random(0.001, 0.01))
                        annotation.title = i.postTitle
                        mapView.addAnnotation(annotation)
                    }
                }
            } else {
                //Map pins for all results
                for i in posts {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: (Double(i.lat)! + Double.random(0.001, 0.01)), longitude: (Double(i.lon)!) + Double.random(0.001, 0.01))
                    annotation.title = i.postTitle
                    mapView.addAnnotation(annotation)
                }
            }
        }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Filtering
        //Custom Filter View to display filter options during search
        func ShowFilters(){
            filters.isHidden = false
            customFilterView = CustomIOS8AlertView()
            customFilterView.delegate = self
            customFilterView.containerView = filters
            customFilterView.buttonColor = hexStringToUIColor("#2b3146")
            customFilterView.buttonColorHighlighted = hexStringToUIColor("#a6a6a6")
            customFilterView.tintColor = hexStringToUIColor("#f27163")
            customFilterView.buttonTitles = ["Done"]
            customFilterView.show()
        }
        
        //Done call back for the filter view
        func customIOS8AlertViewButtonTouchUpInside(_ alertView: CustomIOS8AlertView, buttonIndex: Int) {
            checkForFilters()
            filters.isHidden = true
            customFilterView.close()
        }
    
        //Gets current checked boxes
        func getCheckStates(){
            forSaleState = forSale.checkState
            tradeState = trade.checkState
            lookingState = looking.checkState
            freeState = free.checkState
        }
    
        //Sets variable to checked or unchecked states when custom filter view apears
        func setCheckStates(){
            forSale.checkState = forSaleState!
            trade.checkState = tradeState!
            looking.checkState = lookingState!
            free.checkState = freeState!
        }
    
        //Will check to see which types have been selected and if distance has been selected
        func checkForFilters(){
            type.removeAll()
            reloadPosts = false
            
            if forSale.checkState == .Checked {
                type.append("Sale")
                reloadPosts = true
            }
            if trade.checkState == .Checked {
                type.append("Trade")
                reloadPosts = true
            }
            if looking.checkState == .Checked {
                type.append("Looking")
                reloadPosts = true
            }
            if free.checkState == .Checked {
                type.append("Free")
                reloadPosts = true
            }
            
            //Will load only distance results if type wasnt selected
            if distance.selectedSegmentIndex != 3 && !reloadPosts{
                loadDistanceResults()
            } else {
                //Will reload the post to apply filters
                if reloadPosts  {
                    filterPosts()
                    action = 1
                } else {
                    //Will clear fitler
                    type = []
                    action = 1
                    filtered = false
                    setMapLocation()
                    tabletView.reloadData()
                }
            }
            getCheckStates()
        }
    
        //Will load results based on the distance parameter
        func loadDistanceResults(){
            filteredPosts = []
            filtered = true
            distanceMiles = Int(distance.titleForSegment(at: distance.selectedSegmentIndex)!)!
            
            //Check if distance is within the radius
            for i in searchingResults {
                if loadLocation(i.lon, lat: i.lat){
                    filteredPosts.insert(i, at: 0)
                }
                            
            }
            //Sets map pins and reloads tableview
            action = 2
            setMapLocation()
            tabletView.reloadData()
        }
    
        //Will filter the listings and will reload the data
        func filterPosts(){
            filteredPosts = []
            filtered = true
            mapView.removeAnnotations(mapView.annotations)
            //Checks if distance has been selected
            if distance.selectedSegmentIndex == 1 {
                for i in searchingResults {
                    if !type.isEmpty {
                        //Appends listing containing the selected type
                        for types in type {
                            if i.postType.contains(types) {
                               filteredPosts.insert(i, at: 0)
                            }
                        }
                    }
                }
            } else {
                //Will also filter by distance if that has been selected
                distanceMiles = Int(distance.titleForSegment(at: distance.selectedSegmentIndex)!)!
                for i in searchingResults {
                    if !type.isEmpty {
                        for types in type {
                            if i.postType.contains(types) {
                                if loadLocation(i.lon, lat: i.lat){
                                    filteredPosts.insert(i, at: 0)
                                }
                                
                            }
                        }
                    }
                }

            }
            setMapLocation()
            action = 2
            tabletView.reloadData()
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Send data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue"){
            let details : PostDetails = segue.destination as! PostDetails
            //Sending the proper post key to the next screen
            if (mapView.isHidden){
                switch action {
                case 0:
                    details.key = posts[selectedPost].postKey
                case 1:
                    details.key = searchingResults[selectedPost].postKey
                case 2:
                    details.key = filteredPosts[selectedPost].postKey
                default:
                    details.key = posts[selectedPost].postKey
                }
            } else {
                for i in posts {
                    if i.postTitle == selectedAnnotationTitle {
                        details.key = i.postKey
                    }
                }
            }
            //Sets previous screen to search to allow proper exit segue
            details.previousVC = "Search"
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
    //Helper Functions
    
        //Clear filters
        func resetFilter(){
            //Resting distance
            distance.selectedSegmentIndex = 3
            distanceMiles = 200
            
            //Uncheck check boxes
            forSale.checkState = .Unchecked
            trade.checkState = .Unchecked
            free.checkState = .Unchecked
            looking.checkState = .Unchecked
            
            //updating location
            setLocationManager()
            
            //Refresh search results
            searchActive = true
            reloadPosts = false
            if searchActive {
                searchFirebase()
            }
            //Save checkbox states
            getCheckStates()
            setCheckStates()
        }
    
        //Switches between list and map view
        func switchViews(){
            self.view.endEditing(true)
            if mapView.isHidden {
                mapView.isHidden = false
                filterView.isHidden = false
                changeViewlabel.setTitle("List", for: UIControlState())
            } else {
                mapView.isHidden = true
                filterView.isHidden = true
                changeViewlabel.setTitle("Map", for: UIControlState())
            }
        }
    
        //Cancels the search
        func cancelSearching(){
            self.view.endEditing(true)
            //Selects proper object for tableview
            action = 0
            
            //Turns of cancel button
            cancelSearch.isUserInteractionEnabled = false
            cancelSearch.setTitleColor(UIColor.lightGray, for: UIControlState())
            
            //Hides filter buttons
            filterBttn.isHidden = true
            mapFilterBttn.isHidden = true
            
            //Sets label text
            searchAreaLabel.setTitle("In Your Area", for: UIControlState())
            mapSearchArealLavel.setTitle("In Your Area", for: UIControlState())
            
            //Resets searchbar and filter
            searchBar.text = ""
            resetFilter()
            
            //Not searching or filtering
            searchActive = false
            filtered = false
            
            //Clears search and filters objects
            searchingResults = []
            filteredPosts = []
            //Updates list
            updatePosts()
        }
    
        //Sets the listing type
        func setlistingType(_ selectedIndex : Int){
            switch selectedIndex {
            case 0:
                filterType = "Sale"
            case 1:
                filterType = "Trade"
            case 2:
                filterType = "Looking"
            case 3:
                filterType = "Free"
            default:
                break
            }
        }
    
        //Gets index count based on selected filters and returns them to tableview
        func getIndexCount() -> Int{
            switch action {
            case 0:
                if posts.count > 0 {
                    tabletView.isHidden = false
                } else {
                    tabletView.isHidden  = true
                }
                return posts.count
            case 1:
                return searchingResults.count
            case 2:
                return filteredPosts.count
            default:
                return posts.count
            }
        }
    
        //Gets post for row and creates a cell for it
        func getPost(_ indexPath : Int) -> Post{
            switch action {
            case 0:
                return posts[indexPath]
            case 1:
                return searchingResults[indexPath]
            case 2:
                return filteredPosts[indexPath]
            default:
                return posts[indexPath]
            }
        }
}

//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Extentions
    //Double extention to randomly offset pin location
    public extension Double {
        /// SwiftRandom extension
        public static func random(_ lower: Double = 0, _ upper: Double = 100) -> Double {
            return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
        }
    }

    //Zooms map to include pins on map
    extension MKMapView {
        func fitMapViewToAnnotaionList() -> Void {
            let mapEdgePadding = UIEdgeInsets(top: 100, left: 60, bottom: 100, right: 60)
            var zoomRect:MKMapRect = MKMapRectNull
            
            for index in 0..<self.annotations.count {
                let annotation = self.annotations[index]
                let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
                let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
                
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = rect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, rect)
                }
            }
            self.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        }
    }
