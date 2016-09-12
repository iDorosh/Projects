//
//  ViewOffers.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/2/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import FirebaseDatabase

class ViewOffers: UIViewController {
    
//Variables
    //Data
    var offer : Offers!
    var itemRef : FIRDatabaseReference!
    var allOffers = [Offers]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var offerImageString : String = String()
    var offerUserString : String = String()
    var offerTextString : String = String()
    var offerKey : String = String()
    var uid : String = String()
    var postKey : String?
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Boolean
    var previousProfile : Bool = false
    var sentOffer : Bool = false
    var offerComplete : Bool = false
    var accepted = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Float
    var offerRating : Float = Float()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    
//Outlets
    @IBOutlet weak var offerRatingView: FloatRatingView!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var deleteOffer: UIButton!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerUser: UILabel!
    @IBOutlet weak var offerText: UITextView!
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var acceptBttn: UIButton!
    @IBOutlet weak var declineBttn: UIButton!
    @IBOutlet weak var cancelBttn: UIButton!
    @IBOutlet weak var messageBttn: UIButton!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    @IBAction func deleteOfferAction(_ sender: UIButton) { deleteOfferAlert() }
    @IBAction func backClicked(_ sender: UIButton) { back() }
    @IBAction func newMessage(_ sender: UIButton) { performSegue(withIdentifier: "NewMessage", sender: self) }
    @IBAction func acceptOffer(_ sender: UIButton) { self.sendAccepted() }
    @IBAction func declineOffer(_ sender: UIButton) { self.backToOffer() }
    @IBAction func cancelOffer(_ sender: UIButton) { cancelOffer() }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//UI
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewWillAppear(_ animated: Bool) { setUpViewWillAppear() }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Display proper buttons and labels
    func setUpViewWillAppear(){
        navigationController?.isNavigationBarHidden = true
        if (sentOffer) {
            acceptBttn.isHidden = true
            declineBttn.isHidden = true
            messageBttn.isHidden = true
            cancelBttn.isHidden = false
            deleteOffer.isHidden = true
        }
        
        if offerComplete {
            acceptBttn.isHidden = true
            declineBttn.isHidden = true
            messageBttn.isHidden = true
            cancelBttn.isHidden = true
            deleteOffer.isHidden = false
        }
        
        //Set Images and labels
        rating.rating = 5.0
        offerImageString = offer.offerProfileImage
        offerUserString = offer.offerUser
        offerTextString = offer.offerText
        offerKey = offer.offerKey
        offerRating = Float(offer.offerRating)!
        
        offerImage.image = decodeString(offerImageString)
        offerUser.text = offerUserString
        offerText.text = offerTextString
        offerTitle.text = offer.offerTitle
        offerText.font = UIFont(name: "Avenir", size: 15)
        offerRatingView.rating = offerRating
        
        if !sentOffer {
            offerViewed()
        }
        
        //Move the buttons and adjust label size to fit offer text
        let fixedWidth = offerText.frame.size.width
        offerText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = offerText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = offerText.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height+10)
        offerText.frame = newFrame;
        
        let fixedWidth2 = offerView.frame.size.width
        offerView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.greatestFiniteMagnitude))
        let newSize2 = offerView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame2 = offerView.frame
        newFrame2.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize.height + 30)
        offerView.frame = newFrame2;
        
        acceptBttn.frame.origin = CGPoint(x: acceptBttn.frame.origin.x, y: newSize.height + 260)
        declineBttn.frame.origin = CGPoint(x: declineBttn.frame.origin.x, y: newSize.height + 260)
        cancelBttn.frame.origin = CGPoint(x: cancelBttn.frame.origin.x, y: newSize.height + 260)
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Mark offer as read and offerChecked as true for current user
        func offerViewed(){
            let selectedPostRef2 = DataService.dataService.CURRENT_USER_REF.child("offers").child(offerKey)
            selectedPostRef2.updateChildValues([
                "offerChecked": "true",
                "offerStatus" : "Read",
                ])
            
            //Mark offer as read and offerChecked as true for other
            let selectedPostRef = DataService.dataService.USER_REF.child(uid).child("offers").child(offerKey)
            selectedPostRef.updateChildValues([
                "offerChecked": "true",
                "offerStatus" : "Read",
                ])
        }
    
        //Delete offer for current user and update status for the other user
        func deleteCompletedOffer(){
            if !sentOffer {
                if (offer.offerDeclined == "false") {
                    if offer.feedbackLeft == "false" {
                        let updateRef = DataService.dataService.USER_REF.child("\(offer.offerUID)").child("offers").child("\(offerKey)")
                        updateRef.updateChildValues([
                            "offerStatus" : "Declined",
                            "offerDeclined" : "true"
                            ])
                    }
                    let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(offerKey)")
                    deleteRef.removeValue()
                }
                
                let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(offer.offerKey)")
                
                deleteRef.removeValue()
            } else if sentOffer {
                if (offer.offerDeclined == "false") {
                    if offer.offerAccepted == "false" {
                        let updateRef = DataService.dataService.USER_REF.child("\(offer.offerUID)").child("offers").child("\(offerKey)")
                        updateRef.updateChildValues([
                            "offerStatus" : "Canceled",
                            "offerDeclined" : "true"
                            ])
                    }
                    let deleteRef = DataService.dataService.CURRENT_USER_REF.child("offers").child("\(offer.offerKey)")
                    deleteRef.removeValue()
                }
                
            }
            
            performSegue(withIdentifier: "BackToProfile", sender: self)
        }
    
        //OfferAccepted
        func success(){
            //Mark offer as accepted for the current user
            let selectedPostRef = DataService.dataService.CURRENT_USER_REF.child("offers").child(offerKey)
            selectedPostRef.updateChildValues([
                "offerAccepted": "true",
                "offerDeclined": "false",
                "offerStatus" : "Accepted",
                ])
            
            //Mark offer as accepted for the other user
            let selectedPostRef2 = DataService.dataService.USER_REF.child(uid).child("offers").child(offerKey)
            selectedPostRef2.updateChildValues([
                "offerAccepted": "true",
                "offerDeclined": "false",
                "offerStatus" : "Accepted",
                ])
            
            //Mark post as complete
            let selectedPostRef3 = DataService.dataService.POST_REF.child(postKey!)
            selectedPostRef3.updateChildValues([
                "postComplete": true,
                ])
            
            //Alert for offer accepted
            let alertView = SCLAlertView
            alertView.addButton("Message User", target: self, selector: #selector(messageUser))
            alertView.addButton("Done", target: self, selector: #selector(backToListing))
            alertView.showCloseButton = false
            alertView.showSuccess("Offer Accepted", subTitle: "You can send a user more information on a meeting location")
        }
    
        //Offer canceled
        func cancelOffer(){
            //Mark offer as canceled for current user
            let selectedPostRef = DataService.dataService.CURRENT_USER_REF.child("offers").child(offerKey)
            selectedPostRef.updateChildValues([
                "offerStatus" : "Canceled",
                "offerDeclined" : "true"
                ])
            

            //Mark offer as canceled for other
            let updateRef = DataService.dataService.USER_REF.child(offer.recieverUID).child("offers").child(offer.offerKey)
            updateRef.updateChildValues([
                "offerStatus" : "Canceled",
                "offerDeclined" : "true"
                ])
            
            //Allert for offer canceled
            let alertView = SCLAlertView
            alertView.addButton("Done"){
                alertView.dismiss(animated: true, completion: nil)
                self.back()
            }
            alertView.showCloseButton = false
            alertView.showSuccess("Canceled", subTitle: "Your offer has been canceled")
        }
    
        //Decline offer
        func removeOffer(){
            //Mark offer as declinded for other user
            let updateRef = DataService.dataService.USER_REF.child("\(offer.offerUID)").child("offers").child("\(offer.offerKey)")
            updateRef.updateChildValues([
                "offerStatus" : "Declined",
                "offerDeclined" : "true"
                ])
            
            //Mark offer as declined for current user
            let updateRef2 = DataService.dataService.CURRENT_USER_REF.child("offers").child(offerKey)
            updateRef2.updateChildValues([
                "offerStatus" : "Declined",
                "offerDeclined" : "true"
                ])
            
            //Back to previous screen
            if previousProfile {
                performSegue(withIdentifier: "BackToProfile", sender: self)
            } else {
                performSegue(withIdentifier: "BackToOffersThread", sender: self)
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewMessage"{
            let chatVc : ChatViewController = segue.destination as! ChatViewController
            chatVc.senderId = FIRAuth.auth()?.currentUser?.uid
            chatVc.recieverUsername = offerUserString
            chatVc.recieverUID = offer.offerUID
            chatVc.selectedTitle = offer.offerTitle
            chatVc.selectedImage = offerImageString
            chatVc.selectedUser = offerUserString
            chatVc.currentUser = currentUsernameString
            chatVc.senderUID = uid
            chatVc.title = offerUserString
            chatVc.avatar = offerImageString
            chatVc.previousScreen = "accepted"
            chatVc.accepted = accepted
            chatVc.previousProfile = previousProfile
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
        //OfferAccepted
        func sendAccepted(){
            let alertView = SCLAlertView
            alertView.addButton("Accept", target: self, selector: #selector(success))
            alertView.addButton("Cancel", target: self, selector: #selector(back))
            alertView.showCloseButton = false
            alertView.showWarning("Accept Offer?", subTitle: "Are you sure you want to accept this offer? It cannot be undone.")
        }
    
        func deleteOfferAlert(){
            let alertView = SCLAlertView
            alertView.addButton("Delete") {self.deleteCompletedOffer()}
            alertView.addButton("Cancel") {alertView.dismiss(animated: true, completion: nil)}
            alertView.showCloseButton = false
            alertView.showWarning("Delete Offer?", subTitle: "Are you sure you want to delete this offer? It cannot be undone.")
        }
    
        //OfferAccepted
        func backToOfferListing(){
            let alertView = SCLAlertView
            alertView.showSuccess("Offer Accepted", subTitle: "Once the transaction is complete please come back to your post to leave the user feedback")
        }
        
        //OfferAccepted
        func backToOffer(){
            let alertView = SCLAlertView
            alertView.addButton("Decline", target: self, selector: #selector(removeOffer))
            alertView.addButton("Cancel", target: self, selector: #selector(back))
            alertView.showCloseButton = false
            alertView.showSuccess("Decline Offer", subTitle: "Are you sure you want to decline this offer?")
        }

        func messageUser(){
            let alertView = SCLAlertView
            alertView.showSuccess("Offer Accepted", subTitle: "Once the transaction is complete please come back to your post to leave the user feedback")
            accepted = true
            performSegue(withIdentifier: "NewMessage", sender: self)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Unwind
        func back(){
            if previousProfile {
                performSegue(withIdentifier: "BackToProfile", sender: self)
            } else {
                performSegue(withIdentifier: "BackToOffersThread", sender: self)
            }
        }
        
        
        func backToListing(){
            backToOfferListing()
            if previousProfile {
                performSegue(withIdentifier: "BackToProfile", sender: self)
            } else {
                performSegue(withIdentifier: "OfferAccepted", sender: self)
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
}
