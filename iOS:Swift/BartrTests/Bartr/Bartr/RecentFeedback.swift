//
//  RecentFeedback.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/23/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase

class RecentFeedback: UIViewController {
    
    
//Variables
    //Data
    var feedBack = [FeedbackObject]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var previousSegue : String = String()
    var username : String = String()
    var uid : String = String()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImages
    var profileImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Boolean
    var otherUser : Bool = false
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var noFeedbackLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var feedbackCount: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserProfilePicture: UIImageView!
    @IBOutlet weak var tabletView: UITableView!
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func backButton(_ sender: UIButton) {
        if previousSegue == "Profile"{
            performSegue(withIdentifier: "BackToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "backToUsersProfile", sender: self)
        }
    }
    
    //Back to Chat Action
    @IBAction func backToFeedback(_ segue: UIStoryboardSegue){}
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    
    override func viewWillAppear(_ animated: Bool) { self.tabBarController?.tabBar.isHidden = false }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
        currentUserLabel.text = username
        UserProfilePicture.image = profileImage
        updateFeedback()
        getFeedback()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Table View
        //Set Up Table View
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if feedBack.count == 0 {
                tableView.isHidden = true
                noFeedbackLabel.isHidden = false
            } else {
                tableView.isHidden = false
                noFeedbackLabel.isHidden = true
            }
            return feedBack.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
            let currentFeedback = feedBack[(indexPath as NSIndexPath).row]
            let cell : UsersRecentFeedBackCell = tableView.dequeueReusableCell(withIdentifier: "RecentFeedbackCell")! as! UsersRecentFeedBackCell
            
            cell.tableConfig(currentFeedback)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Get user rating
        func updateFeedback(){
            DataService.dataService.USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshots {
                        if (snap.key == self.uid){
                            self.floatRatingView.rating = Float(snap.value!.object(forKey: "rating") as! String)!
                            self.ratingLabel.text = "\(round((Float(snap.value!.object(forKey: "rating") as! String)!)*10)/10) Star Rating"
                        }
                    }
                }
            })
        }
        
        //Get user feedback
        func getFeedback(){
            if otherUser {
                DataService.dataService.BASE_REF.child("users").child(uid).child("feedback").observeSingleEvent(of: .value, with: { snapshot in
                    self.feedBack = []
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        //Get feedback for user with uid
                        for snap in snapshots {
                            
                            //Append to feedback
                            if let feedbackDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let post = FeedbackObject(key: key, dictionary: feedbackDictionary)
                                self.feedBack.insert(post, at: 0)
                                
                            }
                        }
                        
                    }
                    
                    //Set rating label
                    if self.feedBack.count > 1 {
                        self.feedbackCount.text = "\(self.feedBack.count) ratings"
                    } else if self.feedBack.count == 0{
                        self.feedbackCount.text = "No ratings"
                    }else {
                        self.feedbackCount.text = "\(self.feedBack.count) rating"
                    }
                    
                    self.tableView.reloadData()
                })
                
            } else {
                
                DataService.dataService.CURRENT_USER_REF.child("feedback").observeSingleEvent(of: .value, with: { snapshot in
                    self.feedBack = []
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        //Get feedback for current user
                        for snap in snapshots {
                            
                            if let feedbackDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let post = FeedbackObject(key: key, dictionary: feedbackDictionary)
                                self.feedBack.insert(post, at: 0)
                                
                            }
                        }
                        
                    }
                    
                    //Set rating label
                    if self.feedBack.count > 1 {
                        self.feedbackCount.text = "\(self.feedBack.count) ratings"
                    } else {
                        self.feedbackCount.text = "\(self.feedBack.count) rating"
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

}
