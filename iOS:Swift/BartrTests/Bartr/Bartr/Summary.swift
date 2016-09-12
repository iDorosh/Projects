//
//  Summary.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/14/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import SCLAlertView
import Social

class Summary: UIViewController {
    
//Variables
    //Strings
    var previousVC : String = String()
    var postType : String = String()
    var pickedTitle : String = String()
    var pickedLocation : String = String()
    var pickedTypes : String = String()
    var pickedDescription : String = String()
    var pickedPrice : String = String()
    var currentProfileImg : String = String()
    var base64String : String = String()
    var editKey : String = String()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImages
    var pickedImage: UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Integers
    var month : Int = Int()
    var day : Int = Int()
    var year : Int = Int()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Doubles
    var longitude : Double = Double()
    var latitude : Double = Double()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var currentUser: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var previewUser: UILabel!
    @IBOutlet weak var previewLocation: UILabel!
    @IBOutlet weak var previewDescription: UITextView!
    @IBOutlet weak var previewType: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var previewPrice: UILabel!
    @IBOutlet weak var postLabel: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var mapViewBG: UIView!

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    //Cancel Listing
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        discardNew("Discard Listing", subTitle: "Listing will be discared")
    }
    
    //Create listing
    @IBAction func postListing(_ sender: UIButton) {
        addPostClicked()
    }
    
    //Discard listing
    @IBAction func discardListing(_ sender: UIButton) {
        discardNew("Discard Listing", subTitle: "Listing will be discared")
    }
    
    //Go back to details view
    @IBAction func backBttnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Load UI
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize.height = 900
        getCurrentUser()
        loadLabels()
        loadLocation()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Setup UI
        //Get Current User
        func getCurrentUser(){
            self.currentUser.text = currentUsernameString
            currentUserUID = (FIRAuth.auth()?.currentUser!.uid)!
        }
        
        //Set Images and Labels
        func loadLabels(){
            previewImage.image = pickedImage
            previewTitle.text = pickedTitle
            previewLocation.text = pickedLocation
            previewDescription.text = pickedDescription
            previewDescription.font = UIFont(name: "Avenir", size: 15)
            previewType.text = "\(pickedTypes)"
            
            if previousVC == "EditView"{
                postLabel.setTitle("Update Listing", for: UIControlState())
            }
            
            //Adjusting text view height
            let fixedWidth = previewDescription.frame.size.width
            previewDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = previewDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = previewDescription.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height+10)
            previewDescription.frame = newFrame;
            
            //Adjusting description view height to fit the description text view
            let fixedWidth2 = detailsView.frame.size.width
            detailsView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.greatestFiniteMagnitude))
            let newSize2 = detailsView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame2 = detailsView.frame
            newFrame2.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize.height + 40)
            detailsView.frame = newFrame2;
            
            //Adjusting location view to compinsate for the extra or less room
            mapViewBG.frame.origin = CGPoint(x: mapViewBG.frame.origin.x, y: newSize.height + 390)
        
            ScrollView.contentSize.height = newSize.height + 750
            
            let _currencyFormatter : NumberFormatter = NumberFormatter()
            _currencyFormatter.numberStyle = NumberFormatter.Style.currency
            _currencyFormatter.currencyCode = "USD"
            
            if pickedPrice != "Negotiable" {
                pickedPrice = _currencyFormatter.string(from: Int(pickedPrice)!)!;
                var str = pickedPrice
                
                if let dotRange = str.range(of: ".") {
                    str.removeSubrange(str.indices.suffix(from: dotRange.startIndex))
                }
                pickedPrice = str
            }
            
            previewPrice.text = pickedPrice
            

        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Get Location
        //Get listing location on map preview
        func loadLocation(){
         
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
            annotation.title = "Test"
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(Double(latitude), Double(longitude)), span)
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(annotation)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Create Listing
        //Add post button clicked
        func addPostClicked() {
            //If coming from detail view then the listing will be updated
            if previousVC == "EditView"{
                encodePhoto(pickedImage)
                let postText = pickedDescription
                let postTitle = pickedTitle
                let postType = pickedTypes
                getCurrentDate()
                
                //Getting current user data
                DataService.dataService.CURRENT_USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                    self.currentProfileImg = snapshot.value!.object(forKey: "profileImage") as! String
                    self.getCurrentUser()
                
                //Creating object for push
                let selectedPostRef = DataService.dataService.POST_REF.child(self.editKey)
                selectedPostRef.updateChildValues([
                    "postText": postText,
                    "postTitle": postTitle,
                    "postType": postType,
                    "author": self.currentUser.text!,
                    "postImage": self.base64String,
                    "postLocation": self.pickedLocation,
                    "userProfileImg": self.currentProfileImg,
                    "postPrice": self.pickedPrice,
                    "lon" : String(self.longitude) as String,
                    "lat" : String(self.latitude) as String
                    ])
                    self.performSegue(withIdentifier: "GoBackToProfileSegue", sender: self)
                })
            } else {
                encodePhoto(pickedImage)
                uploadToFirebase()
            }
            
        }
    
        //Encode listing image to send as a string to Firebase
        func encodePhoto(_ image: UIImage){
            var data: Data = Data()
            data = UIImageJPEGRepresentation(image,0.0)!
            base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        }
        
        //Gets current data for time stamp
        func getCurrentDate(){
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .day, .year], from: date)
            month = components.month!
            day = components.day!
            year = components.year!
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Upload to firebase
        //Upload the listing to firebase with current users profile image and username
        func uploadToFirebase(){
            //Sets variable to be uploaded to firebase
            let postText = pickedDescription
            let postTitle = pickedTitle
            let postType = pickedTypes
            let date = dateFormatter().string(from: Date())
            let currentDate = Date()
            let experationDate = dateFormatter().string(from: currentDate.addingTimeInterval(60*60*24*11))
            getCurrentDate()
            
            //Gets current username and profile image
            DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                self.currentProfileImg = snapshot.value!.object(forKey: "profileImage") as! String
                self.getCurrentUser()
                
                //Creating a object to push to firebase
                if postText != "" {
                    // Build the new post.
                    let newpost: Dictionary<String, AnyObject> = [
                        "postText": postText,
                        "postTitle": postTitle,
                        "views": 0,
                        "postType": postType,
                        "author": self.currentUser.text!,
                        "postImage": self.base64String,
                        "postLocation": self.pickedLocation,
                        "userProfileImg": self.currentProfileImg,
                        "postDate": date,
                        "postPrice": self.pickedPrice,
                        "postFeedbackLeft" : false,
                        "postUID" : currentUserUID,
                        "postComplete" : false,
                        "postExpireDate" : experationDate,
                        "postExpired" : false,
                        "lon" : String(self.longitude) as String,
                        "lat" : String(self.latitude) as String
                    ]
            
                    //Setting alert and unhiding the tab bar
                    DataService.dataService.createNewPost(newpost)
                    self.success()
                    self.tabBarController?.tabBar.isHidden = false
                }
            })
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
    
        //Social media alert
        func success(){
            let alertView = SCLAlertView
            alertView.addButton("Twitter") {self.postToTwitter()}
            alertView.addButton("Facebook", target: self, selector: #selector (postToFacebook))
            alertView.addButton("Done") { self.performSegue(withIdentifier: "MainFeedUnwind", sender: self) }
            alertView.showCloseButton = false
            alertView.showSuccess("Listed", subTitle: "Would you like to share your new post on social media?")
        }
    
        //No Account for either twitter or facebook
        func noAccount(){
            let alertView = SCLAlertView
            alertView.addButton("Sign In"){
                self.removeListing()
                self.openSettings()
            }
            alertView.addButton("Cancel"){
                self.removeListing()
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
    
        //Discard Listing
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
    
    //Remove Listing
        func removeListing(){
            performSegue(withIdentifier: "MainFeedUnwind", sender: self)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Social Media
        //Post to twitter
        func postToTwitter(){
            //Check if the user is logged into twitter
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let tweetController = SLComposeViewController(forServiceType : SLServiceTypeTwitter)
                
                //Create initail text
                tweetController?.setInitialText("I just made a listing! Look for \(previewTitle.text) in the Bartr app")
                tweetController?.add(previewImage.image)
                
                //Unwinds to main feed when complete
                tweetController?.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.cancelled:
                        self.performSegue(withIdentifier: "MainFeedUnwind", sender: self)
                        break
                        
                    case SLComposeViewControllerResult.done:
                        self.performSegue(withIdentifier: "MainFeedUnwind", sender: self)
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
                postController?.setInitialText("I just made a listing! Look for \(previewTitle.text) in the Bartr app")
                postController?.add(previewImage.image)
                
                //Completion handler to go back to main feed
                postController?.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.cancelled:
                        self.performSegue(withIdentifier: "MainFeedUnwind", sender: self)
                        break
                        
                    case SLComposeViewControllerResult.done:
                        self.performSegue(withIdentifier: "MainFeedUnwind", sender: self)
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
