//
//  Feedback.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/23/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase

class Feedback: UIViewController {
    
//Variables
    //Data
    var allOffers = [Offers]()
    var selectedOffers = [Offers]()
    var viewOffer : Offers!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var postKey : String = String()
    var previousSegue : String = String()
    var selectedTitle : String = String()
    var selectedImage : String = String()
    var uid : String = String()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
//Outlets
    @IBOutlet weak var tabletView: UITableView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
 
//Actions
    //Back to Chat Action
    @IBAction func backToFeedback(_ segue: UIStoryboardSegue){}
    
    @IBAction func backButton(_ sender: UIButton) {
        if previousSegue == "Profile"{
            performSegue(withIdentifier: "BackToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "backToEditProfileSegue", sender: self)
        }
    }
    
    //Send Feedback
    @IBAction func sendFeedBack(_ sender: UIButton) {
        let selectedPostRef = DataService.dataService.POST_REF.child(postKey)
        selectedPostRef.removeValue()
        performSegue(withIdentifier: "BackToProfile", sender: self)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//UI
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeOffers()
    }
 
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Functions
    //Table View
        //Set Up Table View
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return selectedOffers.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
                let offer = selectedOffers[(indexPath as NSIndexPath).row]
                let cell : FeedbackTableCell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell")! as! FeedbackTableCell
                
                cell.tableConfig(offer)
                return cell
            }
            
            func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
                viewOffer = selectedOffers[(indexPath as NSIndexPath).row]
                performSegue(withIdentifier: "ViewOfferSegue", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
    
        //Get current Offers
        func observeOffers() {
            DataService.dataService.CURRENT_USER_REF.child("offers").observe(.value, with: { snapshot in
                // 3
                self.allOffers = []
                self.selectedOffers = []
                
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots{
                        
                        if let offersDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let offer = Offers(key: key, dictionary: offersDictionary)
                            self.allOffers.insert(offer, at: 0)
                        }
                    }
                
                for offers in self.allOffers{
                    if offers.offerTitle == self.selectedTitle{
                        self.selectedOffers.append(offers)
                    }
                }
                }
                self.tabletView.reloadData()
            })
        }
    

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Send data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ViewOfferSegue"){
            let offer : ViewOffers = segue.destination as! ViewOffers
            offer.offer = viewOffer
            offer.uid = viewOffer.offerUID
            offer.postKey = viewOffer.listingKey
            offer.sentOffer = false
          
        }

    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
}
