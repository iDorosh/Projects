//
//  PostDetails.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/17/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import MapKit
import Social
import Firebase
import SCLAlertView
import FirebaseDatabase



class PostDetails: UIViewController, CustomIOS8AlertViewDelegate, MKMapViewDelegate{
    

    @IBAction func backToPostDetails(_ segue: UIStoryboardSegue){}
    
//Variables
    //Custom Alert View
    var customRatingView : CustomIOS8AlertView! = nil
    var alertController = UIAlertController()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Data
    var allOffers = [Offers]()
    var selectedOffers = [Offers]()
    var selectedPost = [Post]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var selectedTitle: String?
    var selectedProfileImg: String?
    var selectedImage: String?
    var selectedPrice: String?
    var selectedUser: String?
    var selectedLocation: String?
    var selectedDetails: String?
    var selectedType: String?
    var selectedTime: String?
    var selectedExperation : String?
    
    var expireString : String = String()
    var offertextFieldText = String()
    var currentUserNameString = String()
    var key : String = String()
    var userKey : String = String()
    var postKey : String = String()
    var acceptedUID : String = String()
    var acceptedOfferKey : String = String()
    var previousVC : String = String()
    var recieverUID : String = ""
    var senderUID : String = ""
     var titleEdit : String = String()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Integers
    var selectedViews : Int?
    var newOffers = 0
    var leftOffer : Int = 0
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Floats
    var currentRating : Float = Float()
    var rating : Float = Float()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Doubles
    var longitude : Double = Double()
    var latitude : Double = Double()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
    //Boolean
    var postComplete : Bool = false
    var didLeaveFeedback : Bool = false
    var hasOffers : Bool = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
    //UIImage
    var decodedimage2 = UIImage()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Outlets
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var amazonView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var stars: FloatRatingView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var extendOrRenew: UIButton!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var offerAcceptedView: UILabel!

    
    @IBOutlet weak var offerString: UITextView!
    @IBOutlet weak var makeOfferButton: UIButton!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var fbbutton: UIButton!
    @IBOutlet weak var instagrambutton: UIButton!
    @IBOutlet weak var sharePost: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var message: UIButton!
    @IBOutlet weak var sold: UIButton!
    @IBOutlet weak var experationLabel: UILabel!
    @IBOutlet var firstView: UIView!
    
    
    //Labels and images for the selected post
    @IBOutlet weak var postUserProfileImg: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postUser: UILabel!
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var postDetails: UITextView!
    @IBOutlet weak var postType: UILabel!
    @IBOutlet weak var showProfileButton: UIButton!
    @IBOutlet weak var offerButton: UIButton!
   
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func backbuttonClicked(_ sender: UIButton) { unwind() }
    @IBAction func sendOffer(_ sender: UIButton) {}
    @IBAction func renewOrExtendAction(_ sender: UIButton) {renewListing()}
    @IBAction func makeOfferAction(_ sender: UIButton) {
        if self.leftOffer == 3 {
            self.outOfOffers("Offers", subTitle: "You are out of offers for this listing")
        } else {
            enterOffer()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {}
    @IBAction func hideOfferView(_ sender: UIButton) {}
    
    //Share on Twitter
    @IBAction func makeTweet(_ sender: UIButton) {
        postToTwitter()
    }
    
    //Share on Facebook
    @IBAction func makePost(_ sender: UIButton) {
        postToFacebook()
    }
    
    //Send User a message
    @IBAction func messageAction(_ sender: UIButton) {
        checkforBlock()
    }
    
    //Delete post
    @IBAction func deletePost(_ sender: UIButton) {
        deleteListing()
    }
    
    //Edit listing
    @IBAction func editPost(_ sender: UIButton) {
        performSegue(withIdentifier: "EditCurrentListing", sender: self)
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        if key == FIRAuth.auth()?.currentUser?.uid{
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.selectedIndex = 4
        
        } else {
            if previousVC != "UsersFeed" {
            performSegue(withIdentifier: "showUsersProfileSegue", sender: self)
            }
        }
    }
    
    //Mark as sold/traded or given away
    @IBAction func viewOffersAction(_ sender: UIButton) {
        if postComplete {
            leaveFeedback("Feedback", subTitle: "Only leave feedback once the transaction is complete. Are you sure that you want to continue?")
        } else if hasOffers {
            performSegue(withIdentifier: "LeaveFeedbackSegue", sender: self)
        } else {
            noOffers()
        }
        
    }
    
    //WebView Actions
    //Previous Page
    @IBAction func back(_ sender: UIButton) {
        webView.goBack()
    }
    
    //Next Page
    @IBAction func forward(_ sender: UIButton) {
        webView.goForward()
    }
    
    //Refresh Page
    @IBAction func refresh(_ sender: UIButton) {
        webView.reload()
    }
    
    //Open larger mapView
    @IBAction func openMap(_ sender: UIButton) {
        performSegue(withIdentifier: "EnlargeMapSegue", sender: self)
        
    }
    
    @IBAction func dismissFeedback(_ sender: UIButton) {
        customRatingView.close()
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        mapView.delegate = self
        updatePosts()
        super.viewDidLoad()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Functions
    
    //Chage listing height based on description content
    func updateViews(){
        
        //Adjusting text view height
        let fixedWidth = postDetails.frame.size.width
        postDetails.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = postDetails.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = postDetails.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height+10)
        postDetails.frame = newFrame;
        
        //Adjusting description view height to fit the description text view
        let fixedWidth2 = descriptionView.frame.size.width
        descriptionView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.greatestFiniteMagnitude))
        let newSize2 = descriptionView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame2 = descriptionView.frame
        newFrame2.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize.height + 30)
        descriptionView.frame = newFrame2;
        
        //Adjusting location, social and amazon view to compinsate for the extra or less room
        locationView.frame.origin = CGPoint(x: locationView.frame.origin.x, y: newSize.height + 398)
        socialView.frame.origin = CGPoint(x: socialView.frame.origin.x, y: newSize.height + 609)
        amazonView.frame.origin = CGPoint(x: amazonView.frame.origin.x, y: newSize.height + 720)
        
        if amazonView.isHidden == false{
        detailScrollView.contentSize.height = amazonView.frame.origin.y + 1140
        } else {
            detailScrollView.contentSize.height = newSize.height + 1010
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Setup UI
        //Setting variables from the selected post
        func setVariables(){
            let post = selectedPost[0]
            postKey = post.postKey
            userKey = post.postUID
            selectedTitle = post.postTitle
            selectedProfileImg = post.postUserImage
            selectedImage = post.postImage
            selectedUser = post.username
            selectedLocation = post.postLocation
            selectedDetails = post.postText
            selectedType = post.postType
            selectedViews = post.postviews
            selectedPrice = post.postPrice
            selectedTime = post.postDate
            selectedExperation = post.expireDate
            longitude = Double(post.lon)!
            latitude = Double(post.lat)!
            
            addTapRecognizer()
            loadUI()
        }
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Set up the ui with a map view and webview if needed
        func loadUI(){
            //Set labels and decode images
            loadLabels()
            decodeImages()
            
            //Only if the user is signed in
            if (!signUpSkipped){
                DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                    self.currentUserNameString = snapshot.value!.object(forKey: "username") as! String
                    self.currentRating = Float(snapshot.value!.object(forKey: "rating") as! String)!
                    self.hideItems()
                    self.updateViews()
                    
                    //If the listing is not the current users load webview and mapview else get offers for the listing
                    if self.userKey != FIRAuth.auth()?.currentUser?.uid{
                        self.setMapLocation()
                        self.loadWebView()
                        self.observeOthers()
                    } else {
                        self.getNewOffers()
                    }
                })
            } else {
                //Will load ui for users who arent signed in
                self.setMapLocation()
                self.loadWebView()
                self.hideItems()
            }
            
            
            postDetails.isScrollEnabled = false
            //Will only add a view if the user is signed in
            if !signUpSkipped{
                addView()
            }
            
            //Get current user rating
            updateFeedback()
        }
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Will hide UI elements depending on what the previous screen was
        func hideItems(){
            if !signUpSkipped {
                if (previousVC == "Profile"){
                    delete.isHidden = false
                    message.isHidden = true
                    sold.isHidden = false
                    amazonView.isHidden = true
                    socialView.isHidden = false
                    locationView.isHidden = false
                    editButton.isHidden = false
                    mapView.isHidden = true
                    offerButton.isHidden = true
                    
                    
                    checkExperation()

                    
                    
                    detailScrollView.contentSize.height = 1110
                } else if previousVC == "UsersFeed"{
                    offerButton.isHidden = false
                    delete.isHidden = true
                    message.isHidden = false
                    sold.isHidden = true
                    amazonView.isHidden = false
                    socialView.isHidden = false
                    locationView.isHidden = false
                    editButton.isHidden = true
                     extendOrRenew.isHidden = true
                    detailScrollView.contentSize.height = 1950
                } else {
                    offerButton.isHidden = false
                    delete.isHidden = true
                    message.isHidden = false
                    sold.isHidden = true
                    amazonView.isHidden = false
                    socialView.isHidden = false
                    locationView.isHidden = false
                    editButton.isHidden = true
                     extendOrRenew.isHidden = true
                    detailScrollView.contentSize.height = 1950
                }
                
           
                if (selectedPost[0].postUID == FIRAuth.auth()?.currentUser!.uid){
                    delete.isHidden = false
                    message.isHidden = true
                    sold.isHidden = false
                    socialView.isHidden = true
                    editButton.isHidden = false
                    locationView.isHidden = true
                    amazonView.isHidden = true
                    offerButton.isHidden = true
                    checkExperation()
                    detailScrollView.contentSize.height = 1110
                }
                
                if selectedPost[0].postComplete == true {
                    delete.isHidden = true
                    editButton.isHidden = true
                    offerAcceptedView.isHidden = false
                }
                
                
                if selectedPost[0].postFL {
                    offerAcceptedView.text = "Bartr Complete"
                }
            } else {
                offerButton.isHidden = true
                delete.isHidden = true
                message.isHidden = true
                sold.isHidden = true
                amazonView.isHidden = false
                socialView.isHidden = false
                locationView.isHidden = false
                editButton.isHidden = true
                extendOrRenew.isHidden = true
                detailScrollView.contentSize.height = 1950
            }
        }
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Loads all information into the labels
        func loadLabels(){
            let dateString : String = selectedTime!
            
            let date = dateFormatter().date(from: dateString)
            let seconds = Date().timeIntervalSince(date!)
            var viewsOrView : String = "View"
            var totalViews : String = ""
            
            if selectedPost[0].postComplete {
                if selectedPost[0].postFL {
                    experationLabel.text = "Bartr Complete"
                } else {
                    experationLabel.text = "Offer Accepted"
                }
            } else {
                experationLabel.text = getExperationDate(selectedExperation!)
            }
            
            totalViews = "\(selectedViews!)"
            
            if (selectedViews > 1){
                viewsOrView = "Views"
                viewsLabel.text = "\(totalViews) \(viewsOrView)"
            } else if selectedViews == 0 {
                viewsOrView = "No Views"
                viewsLabel.text = viewsOrView
            } else {
                viewsOrView = "View"
                viewsLabel.text = "\(totalViews) \(viewsOrView)"
            }
            
            
            timeStamp.text = elapsedTime(seconds)
            postTitle.text = selectedTitle
            postPrice.text = "$199"
            postUser.text = selectedUser
            postLocation.text = selectedLocation
            postType.text = "\(selectedType!)"
            postPrice.text = selectedPrice
            postDetails.text = selectedDetails
            postDetails.font = UIFont(name: "Avenir", size: 15)
        }
    
    
        //Will open a larger view for the image
        func addTapRecognizer(){
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
            postImage.isUserInteractionEnabled = true
            postImage.addGestureRecognizer(tap)
        }
        
        //Perform segue for selected Image
        func imageClicked(){
            performSegue(withIdentifier: "ShowLargeImage", sender: self)
        }
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //WebView
            //Will load the url in the webview based on the title
            func loadWebView(){
                titleEdit = selectedTitle!.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.literal, range: nil)
                let url = URL (string: "https://www.amazon.com/gp/aw/s/ref=is_s_ss_i_4_18?k=\(titleEdit)");
                let requestObj = URLRequest(url: url!);
                webView.loadRequest(requestObj);
                
            }
        
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Get Images
            //Decodes images stored on Firbase
            func decodeImages(){
                let decodedData = Data(base64Encoded: selectedImage! , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                let decodedimage = UIImage(data: decodedData!)
            
                let decodedData2 = Data(base64Encoded: selectedProfileImg! , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                decodedimage2 = UIImage(data: decodedData2!)!
               
                postImage.image = decodedimage! as UIImage
                postUserProfileImg.image = decodedimage2 as UIImage
            }
        
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Map
            //Sets map to the location listed under the post.
            func setMapLocation(){
                    mapView.removeAnnotations(mapView.annotations)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude + Double.random(0.01, 0.001),  longitude: longitude + Double.random(0.001, 0.01))
                    annotation.title = selectedLocation
                
                    loadOverlayForRegionWithLatitude(latitude + Double.random(0.01, 0.001), andLongitude: longitude + Double.random(0.001, 0.01))
            }
        
            //Create a circle overlay for the map
            var circle:MKCircle!
        
            //set overlay size and location
            func loadOverlayForRegionWithLatitude(_ latitude: Double, andLongitude longitude: Double) {
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                circle = MKCircle(center: coordinates, radius: 2000)
                self.mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)), animated: true)
                self.mapView.add(circle)
            }
        
            //Radius color and size
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let circleRenderer = MKCircleRenderer(overlay: overlay)
                circleRenderer.fillColor = hexStringToUIColor("#f27163").withAlphaComponent(0.4)
                circleRenderer.strokeColor = hexStringToUIColor("#f27163")
                circleRenderer.lineWidth = 1
                return circleRenderer
            }
        
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Renew listing
            //Checks if renewal is needed
            func checkExperation(){
                
                extendOrRenew.isHidden = true
                let eDateString : String = selectedExperation!
                let eDate = dateFormatter().date(from: eDateString)
                
                let days = eDate!.daysFrom(Date())
                let eseconds = eDate!.secondsFrom(Date())
                
                if days == 0 || days == 1 || days == 2 {
                    extendOrRenew.setTitle("Extend Listing", for: UIControlState())
                    extendOrRenew.isHidden = false
                }
                
                if eseconds < 0 {
                    extendOrRenew.setTitle("Renew Listing", for: UIControlState())
                    extendOrRenew.isHidden = false
                }
            }
    
            //Will renew listing adding an extra 10 days to the listing
            func renewListing(){
                let currentDate = Date()
                let experationDate = dateFormatter().string(from: currentDate.addingTimeInterval(60*60*24*11))
                let selectedPostRef = DataService.dataService.POST_REF.child(postKey)
                selectedPostRef.updateChildValues([
                    "postExpireDate": experationDate,
                    ])
                extended()
            }
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Firebase
            func updatePosts(){
                self.view.endEditing(true)
                DataService.dataService.POST_REF.child(key).observeSingleEvent(of: .value, with: { snapshot in
                    self.selectedPost = []
                    
                    if snapshot.children.allObjects is [FIRDataSnapshot] {
                        if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                            let key = snapshot.key
                            let post = Post(key: key, dictionary: postDictionary)
                            self.selectedPost.insert(post, at: 0)
                            self.setVariables()
                        } else {
                            
                        }
                    }
                    if self.key != FIRAuth.auth()?.currentUser?.uid  {
                        self.mainView.isHidden = false
                    }
                    
                })
            }
    
            //Observe other offers
            func observeOthers(){
                self.view.endEditing(true)
                DataService.dataService.USER_REF.child(userKey).child("offers").observe(.value, with: { snapshot in
                    self.leftOffer = 0
                    //Get all current offers from the user
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots{
                            if let offersDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let offer = Offers(key: key, dictionary: offersDictionary)
                                if offer.offerUID == FIRAuth.auth()!.currentUser!.uid {
                                    self.leftOffer += 1
                                }
                            }
                        }
                    } else {
                        self.leftOffer = 0
                    }
                    self.mainView.isHidden = false
                })
            }

            //Observe for new offers
            func getNewOffers(){
                    hasOffers = false
                    DataService.dataService.CURRENT_USER_REF.child("offers").observe(.value, with: { snapshot in
                        //Set objects to empty
                        self.allOffers = []
                        self.selectedOffers = []
                        self.newOffers = 0
                       
                        //Get all current offers from the user
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for snap in snapshots{
                                if let offersDictionary = snap.value as? Dictionary<String, AnyObject> {
                                    let key = snap.key
                                    let offer = Offers(key: key, dictionary: offersDictionary)
                                    self.allOffers.insert(offer, at: 0)
                                }
                            }
                            
                            //Check if the offer listing key matches post key
                            for offers in self.allOffers{
                                if (offers.listingKey == self.postKey){
                                    self.hasOffers = true
                                    if offers.offerAccepted == "true" && offers.feedbackLeft == "false"{
                                        self.postComplete = true
                                        self.acceptedUID = offers.offerUID
                                        self.acceptedOfferKey = offers.offerKey
                                    }
                                    if offers.feedbackLeft == "true" {
                                        self.didLeaveFeedback = true
                                        self.acceptedUID = offers.offerUID
                                        
                                    }
                                }
                                
                                //Set offers count
                                if (offers.listingKey == self.postKey) && (offers.offerChecked == "false") {
                                    self.newOffers = self.newOffers + 1
                                    
                                    
                                }
                            }
                            //Set button text to new offers
                            self.sold.setTitle("\(String(self.newOffers)) New Offers", for: UIControlState())
                            
                            
                        }
                        
                        //If there are no offers
                        if (!self.hasOffers) {
                            self.sold.setTitle("No Offers", for: UIControlState())
                         
                        }
                        
                        //If new offers is empty
                        if (self.newOffers == 0) {
                            self.sold.setTitle("No New Offers", for: UIControlState())
                            
                        }
                        
                        //If the offer has beed accepted
                        if self.postComplete {
                            self.delete.isHidden = true
                            self.editButton.isHidden = true
                            self.sold.setTitle("Leave Feedback", for: UIControlState())
                            self.offerAcceptedView.text = "Offer Accepted"
                        }
                        
                        //If Feedback has been left
                        if self.didLeaveFeedback {
                            self.sold.isHidden = true
                            self.offerAcceptedView.text = "Bartr Complete"
                            self.delete.isHidden = false
                            self.offerAcceptedView.isHidden = false
                        }
                        
                        //If bartr is complete hide labels and buttons allow user to delete listing
                        if self.offerAcceptedView.text == "Bartr Complete" &&  !self.offerAcceptedView.isHidden {
                            self.sold.isHidden = true
                            self.offerAcceptedView.text = "Bartr Complete"
                            self.delete.isHidden = false
                            self.offerAcceptedView.isHidden = false
                        }
                    })
            }
            
            //Adding a view to the current listing if the click was from main feed or search
            func addView(){
                
                //Check to see if user is view there own listing
                if previousVC != "Profile" {
                    DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                        FIRAuth.auth()?.currentUser?.uid
                        if self.selectedPost[0].postUID != FIRAuth.auth()?.currentUser!.uid{
                            let updatedViews : Int = self.selectedViews! + 1
                            
                            let selectedPostRef = DataService.dataService.POST_REF.child(self.postKey)
                            let nickname = ["views": updatedViews]
                            //Updates the view count by 1
                            selectedPostRef.updateChildValues(nickname)
                        }
                    })
                }
            }
    
            //Update rating view with feedback
            func updateFeedback(){
                DataService.dataService.USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            let test = snap.key
                            if (test == self.userKey){
                                self.ratingView.rating = Float(snap.value!.object(forKey: "rating") as! String)!
                            }
                        }
                    }
                })
            }
    
            //Send new offer to the user
            func sendOfferText(_ offerTextString : String!){
                let itemRef = DataService.dataService.USER_REF.child(userKey).child("offers").childByAutoId() // 1
                sendOfferRef = itemRef
                
                //Offer object will be used to accept, leave feedback, decline and delete
                let offerItem = [ // 2
                    "senderUsername": currentUserNameString,
                    "recieverUsername" : selectedUser,
                    "recieverImage" : selectedProfileImg,
                    "listingTitle": selectedTitle,
                    "offerText" : offerTextString,
                    "offerChecked" : "false",
                    "offerAccepted" : "false",
                    "offerDeclined" : "false",
                    "currentProfileImage" : currentUserImageString,
                    "senderUID" : (FIRAuth.auth()?.currentUser?.uid)!,
                    "senderRating" : String(currentRating) as String,
                    "offerDate" : dateFormatter().string(from: Date()),
                    "offerStatus" : "Delivered",
                    "listingKey" : postKey,
                    "recieverUID" : userKey,
                    "feedbackLeft" : "false",
                    "archieved" : "false"
                ]
                
                DataService.dataService.createNewOffer(offerItem)
                
                let itemRef2 = DataService.dataService.USER_REF.child((FIRAuth.auth()?.currentUser?.uid)!).child("offers").child(itemRef.key) // 1
                sendOfferRef = itemRef2
                DataService.dataService.createNewOffer(offerItem)
                self.view.endEditing(true)
                success()
            }
    
            //Check if current user is block
            func checkforBlock() {
                DataService.dataService.USER_REF.child(userKey).child("blockedUsers").observeSingleEvent(of: .value, with: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        if snapshots.count > 0 {
                            for snap in snapshots{
                                if (snap.value as? Dictionary<String, AnyObject>) != nil {
                                    let key = snap.key
                                    if key == FIRAuth.auth()?.currentUser!.uid {
                                        self.blocked()
                                    } else {
                                        //Restarts chat if needed
                                        self.performSegue(withIdentifier: "NewMessage", sender: self)
                                        
                                    }
                                }
                            }
                        }else {
                            //Restarts chat if needed
                            self.performSegue(withIdentifier: "NewMessage", sender: self)
                        }
                    }
                })
                
            }

    
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Alerts
    
            //Blocked alert
            func blocked(){
                let alertView = SCLAlertView
                alertView.addButton("OK"){}
                alertView.showCloseButton = false
                alertView.showWarning("Blocked", subTitle: "You have been blocked from this thread")
            }
    
            //Offer has been sent
            func success(){
                let alertView = SCLAlertView
                alertView.showSuccess("Offer Sent", subTitle: "Your offer has been sent to \(selectedUser!)")
            }
            
            //No offers when offers button is clicked with no offers
            func noOffers(){
                let alertView = SCLAlertView
                alertView.showWarning("Offers", subTitle: "There are no offers for this listing")
            }
    
            //Delete offers listing
            func deleteListing(){
                let alertView = SCLAlertView
                alertView.showCloseButton = false
                alertView.addButton("Delete Listing") { self.deletePostCallBack() }
                alertView.addButton("Cancel") {alertView.dismiss(animated: true, completion: nil)}
                alertView.showWarning("Delete", subTitle: "Are you sure that you want to delete this listing?")
            }
    
            //Offer has been extended
            func extended(){
                let alertView = SCLAlertView
                alertView.showSuccess("Listing Extended", subTitle: "You listing will be available for the next 10 days")
            }
            
            //Rate user later
            func rateLater(){
                let selectedPostRef = DataService.dataService.POST_REF.child(self.key)
                selectedPostRef.updateChildValues([
                    "postComplete": true,
                    ])
                unwind()
            }
            
            //Removes post using post key
            func deletePostCallBack(){
                let selectedPostRef = DataService.dataService.POST_REF.child(postKey)
                selectedPostRef.removeValue()
                unwind()
            }
    
            // Create a new offer alert
            func enterOffer(){
                self.alertController.dismiss(animated: true, completion: nil)
                let alert = SCLAlertView
                let txt = alert.addTextField("Make Offer")
                txt.autocapitalizationType = UITextAutocapitalizationType.sentences
                alert.addButton("Send Offer") {
                    self.sendOfferText(txt.text!)
                }
                alert.addButton("Cancel") {alert.dismiss(animated: true, completion: nil)}
                alert.showCloseButton = false
                var offersleftText : String = String()
                if ((3-leftOffer) > 1) {
                    offersleftText = "offers"
                } else {
                    offersleftText = "offer"
                }
                alert.showEdit("Make Offer", subTitle: "\(3-leftOffer) \(offersleftText) left\nSend \(selectedUser!) an offer for this listing")
            }
            
            func feedbackSent(_ title : String, subTitle : String){
                let alertView = SCLAlertView
                alertView.showSuccess(title, subTitle: subTitle)
            }
    
            func outOfOffers(_ title : String, subTitle : String){
                let alertView = SCLAlertView
                alertView.showCloseButton = false
                alertView.addButton("Ok") {
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showWarning(title, subTitle: subTitle)
            }
    
            //No Account for either twitter or facebook
            func noAccount(){
                let alertView = SCLAlertView
                alertView.addButton("Sign In"){
                    alertView.dismiss(animated: true, completion: nil)
                    self.openSettings()
                }
                alertView.addButton("Cancel"){
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("No Account", subTitle: "Please sign into your account")
            }
    
            //Open Setting to sign in
            func openSettings(){
                let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsURL{
                    UIApplication.shared.openURL(url)
                }
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Leave Feedback
        func leaveFeedback(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.addButton("Leave Feedback"){
                self.leaveFeedback()
            }
            alertView.addButton("Later"){
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showCloseButton = false
            alertView.showWarning(title, subTitle: subTitle)
        }
        
        var userRated : Bool = false
        func leaveFeedback(){
            customRatingView = CustomIOS8AlertView()
            customRatingView.delegate = self
            customRatingView.containerView = feedbackView
            customRatingView.buttonColor = hexStringToUIColor("#2b3146")
            customRatingView.buttonColorHighlighted = hexStringToUIColor("#a6a6a6")
            customRatingView.buttonTitles = ["Send Feedback"]
            customRatingView.tintColor = hexStringToUIColor("#f27163")
            customRatingView.containerView.frame = CGRect(x: customRatingView.containerView.frame.minX , y: customRatingView.containerView.frame.minY, width: customRatingView.containerView.frame.width , height: customRatingView.containerView.frame.height - 120)
            customRatingView.show()
        }
    
        func customIOS8AlertViewButtonTouchUpInside(_ alertView: CustomIOS8AlertView, buttonIndex: Int) {
            feedbackLeft()
            sendFeedback(stars.rating, currentUsername: currentUserNameString, title: postTitle.text!, img: currentUserImageString, id: acceptedUID, postUID: postKey, update : true )
            customRatingView.close()
            userRated = true
            updatePost()
            delete.isHidden = false
            sold.isHidden = true
            self.offerAcceptedView.text = "Bartr Complete"
            self.offerAcceptedView.isHidden = false
        }

    
        func feedbackLeft(){
            let selectedPostRef2 = DataService.dataService.CURRENT_USER_REF.child("offers").child(acceptedOfferKey)
            selectedPostRef2.updateChildValues([
                "offerStatus" : "Feedback Left",
                "feedbackLeft" : "true"
                ])
        }
    
        func updatePost(){
            let selectedPostRef3 = DataService.dataService.POST_REF.child(postKey)
            selectedPostRef3.updateChildValues([
                "postFeedbackLeft" : true,
                ])
        }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Segue
        //Will show a larger view of the clicked image
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "ShowLargeImage"){
                let largeImageView : ViewImageVC = segue.destination as! ViewImageVC
                largeImageView.showImage = postImage.image!
            }
            
            if (segue.identifier == "EditCurrentListing"){
                
                let camera : Camera = segue.destination as! Camera
                camera.editKey = postKey
                camera.previousScreen = "EditView"
                camera.orignalView = previousVC
            }
            
            if (segue.identifier == "EnlargeMapSegue"){
                
                let map : MapView = segue.destination as! MapView
                map.lat = latitude
                map.lon = longitude
                
            }
            
            if segue.identifier == "showUsersProfileSegue"{
                let usersProfile : UsersProfile = segue.destination as! UsersProfile
                usersProfile.usersName = selectedUser!
                usersProfile.profileUIImage = decodedimage2
                usersProfile.uid = userKey
            }
            
            
            if segue.identifier == "LeaveFeedbackSegue"{
                let feedback : Feedback = segue.destination as! Feedback
                feedback.postKey = postKey
            }
            
            if segue.identifier == "NewMessage"{
                let chatVc : ChatViewController = segue.destination as! ChatViewController
                chatVc.senderId = FIRAuth.auth()?.currentUser?.uid
                chatVc.recieverUsername = postUser.text!
                chatVc.senderDisplayName = currentUsernameString
                chatVc.recieverUID = userKey
                chatVc.selectedTitle = selectedTitle!
                chatVc.selectedImage = encodePhoto(postUserProfileImg.image!)
                chatVc.selectedUser = selectedUser!
                chatVc.currentUser = currentUserNameString
                chatVc.senderUID = (FIRAuth.auth()?.currentUser?.uid)!
                chatVc.title = selectedUser!
            }
            
            if segue.identifier == "LeaveFeedbackSegue"{
                let offersVC : Feedback = segue.destination as! Feedback
                offersVC.selectedTitle = selectedTitle!
                offersVC.uid = (FIRAuth.auth()?.currentUser?.uid)!
            }
        }
        
        func unwind(){
            if previousVC == "Profile"{
                performSegue(withIdentifier: "FinishedSegue", sender: self)
            } else if previousVC == "UsersFeed"{
                self.navigationController?.popViewController(animated: true)
            } else if previousVC == "Search"{
                performSegue(withIdentifier: "BackToSearchSegue", sender: self)
            } else {
                performSegue(withIdentifier: "MainFeedUnwind", sender: self)
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
        //Social Media
        //Post to twitter
        func postToTwitter(){
            //Check if the user is logged into twitter
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let tweetController = SLComposeViewController(forServiceType : SLServiceTypeTwitter)
                
                //Create initail text
                tweetController?.setInitialText("Great listing from \(selectedUser!). Look for \(selectedTitle!) in the Bartr app")
                tweetController?.add(postImage.image)
                
                //Unwinds to main feed when complete
                tweetController?.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.cancelled:
                        
                        break
                        
                    case SLComposeViewControllerResult.done:
                        
                        break
                    }
                }
                //Presents tweet view controller
                self.present(tweetController!, animated: true, completion: nil)
            } else {
                //No account opens settings
                noAccount()
            }
        }
        
        //Post to facebook
        func postToFacebook(){
            //Check if the user is signed in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let postController = SLComposeViewController(forServiceType : SLServiceTypeFacebook)
                
                //Set initail text
                postController?.setInitialText("Great listing from \(selectedUser!). Look for \(selectedTitle!) in the Bartr app")
                postController?.add(postImage.image)
                
                //Completion handler to go back to main feed
                postController?.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.cancelled:
                        break
                        
                    case SLComposeViewControllerResult.done:
                        break
                    }
                }
                //Present facebook controller
                self.present(postController!, animated: true, completion: nil)
            } else {
                //no account found go to settings alert
                noAccount()
            }
        }

    

    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
 
}
