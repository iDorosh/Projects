//
//  UsersProfile.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/22/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase

class UsersProfile: UIViewController, UITableViewDataSource {
    
     @IBAction func backToUsersProfile(_ segue: UIStoryboardSegue){}
 
    
//Variables
    //Data 
    var post : Post!
    var allPosts = [Post]()
    var userPosts = [Post]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var ratingString : String = String()
    var previousScreen : String = String()
    var uid : String = String()
    var usersName : String = String()
    var profileUIImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Integers
    var selectedPost : Int = Int()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
 
//Outlets
    @IBOutlet weak var floatRating: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func openUserRating(_ sender: UIButton) {
        performSegue(withIdentifier: "otherUserFeedbackSegue", sender: self)
    }
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//UI
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePosts()
        self.spin.startAnimating()
        self.spin.isHidden = false
        updateFeedback()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameLabel.text = usersName
        ratingLabel.text = ratingString
        profileImage.image = profileUIImage
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Table View
        //Setup Table View
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userPosts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let post = userPosts[(indexPath as NSIndexPath).row]
            let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")! as! CustomTableCell
            cell.configureCell(post)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            selectedPost = (indexPath as NSIndexPath).row
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "detailSegue2", sender: self)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Update Firebase Data and Table View
        //Get user listings
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
                    if i.postUID == self.uid && !i.postComplete && !i.postFL{
                        self.userPosts.append(i)
                    }
                }
                
                self.spin.stopAnimating()
                self.spin.isHidden = true
                self.tableView.reloadData()
                self.posts.text = "\(self.userPosts.count) Posts"
                self.userInfoView.isHidden = false
                self.tableView.isHidden = false
            })
        }
        
        //Get users feedback
        func updateFeedback(){
            DataService.dataService.USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshots {
                        
                        if (snap.key == self.uid){
                            self.floatRating.rating = Float(snap.value!.object(forKey: "rating") as! String)!
                            self.ratingLabel.text = "\(round((Float(snap.value!.object(forKey: "rating") as! String)!)*10)/10) Star Rating"
                        }
                    }
                }
                
            })

        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Send data to the Detail View
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if (segue.identifier == "detailSegue2"){
                let details : PostDetails = segue.destination as! PostDetails
                details.key = userPosts[selectedPost].postKey
                details.previousVC = "UsersFeed"
            }
            
            if segue.identifier == "otherUserFeedbackSegue"{
                let userFeedback : RecentFeedback = segue.destination as! RecentFeedback
                userFeedback.previousSegue = "UsersProfile"
                userFeedback.username = usersName
                userFeedback.otherUser = true
                userFeedback.uid = uid
                userFeedback.profileImage = profileImage.image!
            }
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

}
