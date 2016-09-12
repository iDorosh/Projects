//
//  Profile.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SCLAlertView


class Profile: UIViewController, UITableViewDataSource, CustomIOS8AlertViewDelegate{
    
    var segment = 0
    
     var customRatingView : CustomIOS8AlertView! = nil

    @IBOutlet weak var signin: UIView!
    @IBAction func signinButton(_ sender: UIButton) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
    //Back to Profile View Controller
    @IBAction func backToProfile(_ segue: UIStoryboardSegue){}
    
    
//Varibales
    //Data
    var post : Post!
    var allPosts = [Post]()
    var userPosts = [Post]()
    var offers = [Offers]()
    var viewOffer : Offers!
    var selectedOffer : Offers!
    var recieverOffers = [Offers]()
    var sendOffers = [Offers]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var currentUser : String = String()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Int
    var selectedPost : Int = Int()
    var badgeCount : Int = 0
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Boolean
    var loaded : Bool = false
    
    //Refresh control to manually update the Main Feed TableView
    var refreshControl: UIRefreshControl!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
//Outlers
    @IBOutlet weak var noOffersYet: UILabel!
    @IBOutlet weak var ratings: UIView!
    @IBOutlet weak var setFeedback: FloatRatingView!
    @IBOutlet var typeofView: UISegmentedControl!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var selectRating: FloatRatingView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func closeRating(_ sender: UIButton) {}
    
    @IBAction func typeofViewActions(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segment = 0
        case 1:
            segment = 1
        case 2:
            segment = 2
        default:
            break
        }
        tableView.reloadData()
    }
    
    
    @IBAction func showRatings(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowRecentUserFeedback", sender: self)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Start animation and hide navigation bar
        self.spin.startAnimating()
        self.spin.isHidden = false
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        //Check if sign in was skipped
        self.tabBarController?.tabBar.isHidden = false
        if signUpSkipped {
            signin.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        } else {
            signin.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        //Fill in user info
        getCurrentUserData()
        observeOffers()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Tableview
        //Set up Table View
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if segment == 0 {
                if userPosts.count == 0 {
                    noOffersYet.text = "No Posts Yet"
                    noOffersYet.isHidden = false
                } else {
                    noOffersYet.isHidden = true
                }
                return userPosts.count
            } else if segment == 1{
                if recieverOffers.count == 0 {
                    noOffersYet.text = "No Recieved Offers Yet"
                    noOffersYet.isHidden = false
                } else {
                    noOffersYet.isHidden = true
                }
                return recieverOffers.count
            } else {
                if sendOffers.count == 0 {
                    noOffersYet.text = "No Sent Offers Yet"
                    noOffersYet.isHidden = false
                } else {
                    noOffersYet.isHidden = true
                }
                return sendOffers.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let screen = appDelegate.screenHeight
            var profileCellRowHeight = CGFloat()
            if screen == 667 {
                profileCellRowHeight = 320.0
            } else {
                profileCellRowHeight = 352.0
            }
            
            if segment == 0 {
            let post = userPosts[(indexPath as NSIndexPath).row]
            let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")! as! CustomTableCell
            cell.configureCell(post)
            self.tableView.rowHeight = profileCellRowHeight
            self.tableView.isHidden = false
            spin.isHidden = true
            return cell
            } else if segment == 1{
                let offer = recieverOffers[(indexPath as NSIndexPath).row]
                let cell : FeedbackTableCell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell")! as! FeedbackTableCell
                cell.tableConfig(offer)
                self.tableView.rowHeight = 96
                self.tableView.isHidden = false
                spin.isHidden = true
                return cell
            } else {
                let offer = sendOffers[(indexPath as NSIndexPath).row]
                let cell : FeedbackTableCell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell")! as! FeedbackTableCell
                cell.tableConfig(offer)
                self.tableView.rowHeight = 96
                self.tableView.isHidden = false
                spin.isHidden = true
                return cell
            }
            
        }
        

        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            if segment == 0 {
                selectedPost = (indexPath as NSIndexPath).row
                performSegue(withIdentifier: "detailSegue2", sender: self)
            } else if segment == 1 {
                viewOffer = recieverOffers[(indexPath as NSIndexPath).row]
                if viewOffer.offerStatus != "Accepted" {
                    if (viewOffer.offerDeclined == "true") {
                        offerDeclined("Offer Canceled", subtitle: "The user has canceled their offer. Would you like to delete this offer now?")
                    } else {
                        performSegue(withIdentifier: "ViewOfferSegue", sender: self)
                    }
                } else {
                    leaveFeedback()
                }
            } else {
                viewOffer = sendOffers[(indexPath as NSIndexPath).row]
                    if viewOffer.offerStatus != "Accepted" {
                        if (viewOffer.offerDeclined == "true") {
                            offerDeclined("Offer Declined", subtitle: "The user has declined your offer. Would you like to delete this offer now?")
                        } else {
                            performSegue(withIdentifier: "ViewOfferSegue", sender: self)
                        }
                    } else {
                        leaveFeedback()
                    }
                }
                tableView.deselectRow(at: indexPath, animated: true)
        }

        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if segment == 0 {
                return false
            } else if segment == 1 {
                if recieverOffers[(indexPath as NSIndexPath).row].offerStatus == "Accepted" {
                    return false
                } else {
                return true
                }
            } else {
                if sendOffers[(indexPath as NSIndexPath).row].offerStatus == "Accepted" {
                    return false
                } else {
                    return true
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
                selectedOffer = offers[(indexPath as NSIndexPath).row]
                offers.remove(at: (indexPath as NSIndexPath).row)
                deleteOffer(selectedOffer)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        func deleteOffer(_ offer : Offers){
            if segment == 1 {
                //Update offer status for other user and delete offer
                if offer.offerStatus != "Feeback Left" {
                    if (offer.offerDeclined == "false") {
                        if (offer.feedbackLeft == "false"){
                            let updateRef = DataService.dataService.USER_REF.child("\(selectedOffer.offerUID)").child("offers").child("\(selectedOffer.offerKey)")
                            updateRef.updateChildValues([
                                "offerStatus" : "Declined",
                                "offerDeclined" : "true"
                            ])
                        }
                    }
                }
                
                if offer.offerStatus != "Feedback Left" {
                    let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(selectedOffer.offerKey)")

                    deleteRef.removeValue()
                } else {
                    let updateRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(selectedOffer.offerKey)")
                    updateRef.updateChildValues([
                            "archieved" : "true"
                        ])
                }
                
            } else if segment == 2 {
                if (offer.offerDeclined == "false") {
                    if offer.offerAccepted == "false" {
                        let updateRef = DataService.dataService.USER_REF.child("\(selectedOffer.recieverUID)").child("offers").child("\(selectedOffer.offerKey)")
                        
                        updateRef.updateChildValues([
                            "offerStatus" : "Canceled",
                            "offerDeclined" : "true"
                            ])
                    }
                }
                
                let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(selectedOffer.offerKey)")
                
                deleteRef.removeValue()
            }
            
            tableView.reloadData()
        }
        
        func offerDeclined(_ title : String, subtitle : String){
            let alertView = SCLAlertView
            alertView.showCloseButton = false
            alertView.addButton("Delete Offer") {
                let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(self.viewOffer.offerKey)")
                deleteRef.removeValue()
                self.tableView.reloadData()}
            alertView.addButton("Cancel"){ alertView.dismiss(animated: true, completion: nil) }
            alertView.showWarning(title, subTitle: subtitle)
        }
        
        //Adds pull to refresh to the main table view
        func setUpRefreshControl(){
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(manualUpdate), for: UIControlEvents.valueChanged)
            tableView.addSubview(refreshControl)
            
        }
    
        //Update Firebase Data and Table View
        func updatePosts(){
            DataService.dataService.POST_REF.observe(.value, with: { snapshot in
                self.allPosts = []
                self.userPosts = []
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let post = Post(key: key, dictionary: postDictionary)
                            self.allPosts.insert(post, at: 0)
                        }
                    }
                }
            
                //Get current users posts
                
                    for i in self.allPosts
                    {
                        if i.postUID == FIRAuth.auth()?.currentUser?.uid{
                            self.userPosts.append(i)
                        }
                    }
                    self.refreshControl.endRefreshing()
                    self.spin.stopAnimating()
                    self.spin.isHidden = true
                    self.tableView.reloadData()
                    self.posts.text = "\(self.userPosts.count) Posts"
                    self.observeOffers()
                
            })
        }
        
        func manualUpdate(){
            DataService.dataService.POST_REF.observeSingleEvent(of: .value, with: { snapshot in
                self.allPosts = []
                self.userPosts = []
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let post = Post(key: key, dictionary: postDictionary)
                            self.allPosts.insert(post, at: 0)
                        }
                    }
                }
                
                //Get current users posts
                for i in self.allPosts
                {
                    if i.username == self.currentUser{
                        self.userPosts.append(i)
                    }
                }
                self.refreshControl.endRefreshing()
                self.spin.stopAnimating()
                self.spin.isHidden = true
                self.tableView.reloadData()
                    if self.userPosts.count >= 1 {
                        self.posts.text = "\(self.userPosts.count) posts"
                    } else {
                        self.posts.text = "No posts"
                    }
                })

        }
        
        
        func renewListing(){
            
        }
        
        //Load current user information
        func getCurrentUserData(){
            self.offers = []
            
            DataService.dataService.CURRENT_USER_REF.observe(.value, with: { snapshot in
                self.currentUser = snapshot.value!.object(forKey: "username") as! String
                let currentProfileImg = snapshot.value!.object(forKey: "profileImage") as! String
                let userRating : Float = Float(snapshot.value!.object(forKey: "rating") as! String)!
              
                self.ratingLabel.text = "\(round((Float(snapshot.value!.object(forKey: "rating") as! String)!)*10)/10) Star Rating"

                self.floatRatingView.rating = userRating
                self.userName.text = self.currentUser
                
                
                let decodedData = Data(base64Encoded: currentProfileImg, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                
                let decodedimage = UIImage(data: decodedData!)
                
                self.profileImage.image = decodedimage! as UIImage
                
                
                self.updatePosts()
                
            })
        }
        
        func observeOffers() {
            DataService.dataService.CURRENT_USER_REF.child("offers").observe(.value, with: { snapshot in
                // 3
                self.offers = []
                self.sendOffers = []
                self.recieverOffers = []
                
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots{
                        
                        if let offersDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let offer = Offers(key: key, dictionary: offersDictionary)
                            self.offers.insert(offer, at: 0)
                        }
                    }
                }
                
                self.badgeCount = 0

                for i in self.offers {
                    if i.offerUID == FIRAuth.auth()?.currentUser?.uid{
                        self.sendOffers.append(i)
                    } else {
                        if i.offerStatus == "Delivered"{
                            self.badgeCount += 1
                        } else {
                            if self.badgeCount != 0 {
                                self.badgeCount - 1
                            }
                        }
                        if i.archieved == "false" {
                            self.recieverOffers.append(i)
                        }
                        
                    }
                }
                
                if self.badgeCount != 0 {
                self.tabBarController?.tabBar.items?[4].badgeValue = String(self.badgeCount)
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
                self.tableView.reloadData()
                self.tableView.isHidden = false
            })
        }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Segues
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "detailSegue2"){
                let details : PostDetails = segue.destination as! PostDetails
                details.key = userPosts[selectedPost].postKey
               
                details.previousVC = "Profile"
            }
            
           
            
            if (segue.identifier == "ViewOfferSegue"){
                let offer : ViewOffers = segue.destination as! ViewOffers
                offer.offer = viewOffer
                offer.uid = viewOffer.offerUID
                offer.postKey = viewOffer.listingKey
                offer.previousProfile = true
                if viewOffer.feedbackLeft == "true" {
                    offer.sentOffer = true
                    offer.offerComplete = true
                }
                if segment == 2 {
                    offer.sentOffer = true
                }
            }

            
            if segue.identifier == "ShowRecentUserFeedback"{
                let userFeedback : RecentFeedback = segue.destination as! RecentFeedback
                userFeedback.previousSegue = "Profile"
                userFeedback.username = currentUser
                userFeedback.profileImage = profileImage.image!
                userFeedback.otherUser = false
            }
            
        }
        
        
        func leaveFeedback(){
            let alertView = SCLAlertView
            alertView.addButton("Leave Feedback", target: self, selector: #selector(showFeedbackView))
            alertView.addButton("Later") { alertView.dismiss(animated: true, completion: nil)}
            alertView.showCloseButton = false
            alertView.showWarning("Feedback", subTitle: "Only leave feedback once the transaction is complete. Are you sure that you want to continue?")
        }
        
        var userRated : Bool = false
        
        func showFeedbackView(){
            feedbackView.isHidden = false
            if !loaded {
                customRatingView = CustomIOS8AlertView()
                customRatingView.delegate = self
                customRatingView.containerView = feedbackView
                customRatingView.buttonColor = hexStringToUIColor("#2b3146")
                customRatingView.buttonColorHighlighted = hexStringToUIColor("#a6a6a6")
                customRatingView.buttonTitles = ["Send Feedback"]
                customRatingView.tintColor = hexStringToUIColor("#f27163")
                customRatingView.containerView.frame = CGRect(x: customRatingView.containerView.frame.minX , y: customRatingView.containerView.frame.minY, width: customRatingView.containerView.frame.width , height: customRatingView.containerView.frame.height - 120)
                customRatingView.show()
                loaded = true
            } else {
                selectRating.rating = 5.0
                customRatingView.show()
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Update feedback
    func customIOS8AlertViewButtonTouchUpInside(_ alertView: CustomIOS8AlertView, buttonIndex: Int) {
        var feedbackUID : String = String()
        var updatePost : Bool = false
        if segment == 1 {
            feedbackUID = viewOffer.offerUID
            updatePost = true
            
        } else {
            updatePost = false
            feedbackUID = viewOffer.recieverUID
        }
        sendFeedback(selectRating.rating, currentUsername: currentUser, title: viewOffer.offerTitle, img: encodePhoto(profileImage.image!), id: feedbackUID, postUID: viewOffer.listingKey, update : updatePost)
        
        feedbackLeft()
        feedbackView.isHidden = true
        customRatingView.close()
        userRated = true
    }
    
    func feedbackLeft(){
        let selectedPostRef2 = DataService.dataService.CURRENT_USER_REF.child("offers").child(viewOffer.offerKey)
        selectedPostRef2.updateChildValues([
            "offerStatus" : "Feedback Left",
            "feedbackLeft" : "true"
            ])

    }

}
