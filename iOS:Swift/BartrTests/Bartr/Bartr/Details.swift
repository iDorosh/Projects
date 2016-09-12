//
//  Details.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/14/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import SCLAlertView

class Details: UIViewController, UITextViewDelegate {
    
    @IBAction func backToDetails(_ segue: UIStoryboardSegue){}
    

//Data
    //Holds selcted Types
    var type : [String] = []
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Variables
    //Strings
    var pickedTitle : String = String()
    var pickedLocation : String = String()
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
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImages
    var pickedImage: UIImage = UIImage()
    var Unchecked : UIImage = UIImage(named: "NotChecked")!
    var Checked : UIImage = UIImage(named: "Checked")!

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Doubles
    var longitude : Double = Double()
    var latitude : Double = Double()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image4: UIImageView!
    @IBOutlet weak var pickedDescription: UITextView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    
//Actions
    @IBAction func forSale(_ sender: UIButton) {
        checkedChecker(Image1, listingType: "Sale")
    }
    
    @IBAction func forTrade(_ sender: UIButton) {
        checkedChecker(Image2, listingType: "Trade")
    }
    
    @IBAction func lookingFor(_ sender: UIButton) {
        checkedChecker(Image3, listingType: "Looking")
    }
    
    @IBAction func free(_ sender: UIButton) {
        checkedChecker(Image4, listingType: "Free")
    }
    
    @IBAction func backBttnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backTolocation(_ sender: UIButton) {
        performSegue(withIdentifier: "backToLocation", sender: self)
    }
    
    @IBAction func goToSummary(_ sender: UIButton) {
        checkInput()
    }
   
    
    @IBAction func discardListing(_ sender: UIButton) {
        discardListingAlert("Discard Listing", subTitle: "Listing will be discarded")
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()}
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        loadUI()
        super.viewDidLoad()
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Functions
    //UI Setup
        //Sets up ui with existing data
        func loadUI(){
            applyBlurrEffect()
            addTapRecognizer()
            pickedDescription.delegate = self
            if previousScreen == "EditView"{
                if ((editType.contains("Sale"))){
                    Image1.image = Checked
                    type.append("Sale")
                }
                if ((editType.contains("Trade"))){
                    Image2.image = Checked
                    type.append("Trade")
                }
                if ((editType.contains("Looking"))){
                    Image3.image = Checked
                    type.append("Looking")
                }
                if ((editType.contains("Free"))){
                    Image4.image = Checked
                    type.append("Free")
                }
                pickedDescription.text = editDetails
            }
        }
        
        //Tap Recognizer to minimize the keyboard
        func addTapRecognizer(){
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Camera.dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        
        //Checks and Unchecks type boxes
        func checkedChecker(_ image: UIImageView, listingType: String) {
            if image.image == Unchecked{
                image.image = Checked
                type.append(listingType)
            } else {
                image.image = Unchecked
                type.remove(at: type.index(of: listingType)!)
            }
        }
    
        //Applies Blurr effect to the background image
        func applyBlurrEffect(){
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            self.previewImage.addSubview(blurEffectView)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Keyboard
        //Will offset the scroll view to fit the text view
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            UIApplication.shared.isStatusBarHidden = true
            detailsScrollView.setContentOffset(CGPoint(x: 0,y: 190), animated: true)
        }
        
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
            //Resets view offset
            detailsScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            view.endEditing(true)
            UIApplication.shared.isStatusBarHidden = false
        }
        
        //Resets the scroll view
        func textViewDidEndEditing(_ textView: UITextView) {
            detailsScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Discard New
        //Show alert view to verify that the users wants to discard the listing
        func discardListingAlert(_ title : String, subTitle : String){
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
    
        //Back to Main Feed
        func removeListing(){
            performSegue(withIdentifier: "MainSegue", sender: self)
        }
    
        func noType(_ title : String, subtitle : String){
            let alertView = SCLAlertView
            alertView.addButton("Ok"){
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showCloseButton = false
            alertView.showWarning(title, subTitle: subtitle)
        }
    
        func withoutDescription(){
            let alertView = SCLAlertView
            alertView.addButton("Continue"){
                self.pickedDescription.text = "No description provided"
                self.performSegue(withIdentifier: "GotoSummarySegue", sender: self)
            }
            alertView.addButton("Add Discription") {
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showCloseButton = false
            alertView.showWarning("No Discription", subTitle: "Continue without discription?")
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Check for type and discription
    func checkInput(){
          let trimmedString = pickedDescription.text.trimmingCharacters(in: CharacterSet.whitespaces)
        if type.count == 0 {
            noType("Type", subtitle: "Please select a type of listing")
        } else if trimmedString == ""{
            withoutDescription()
        } else {
            self.performSegue(withIdentifier: "GotoSummarySegue", sender: self)
        }
    }
    
    //Segue
        //Creates the type string to be passed into the next view
        func createTypeString(){
            typesString = ""
            for types in type {
                if type.index(of: types) == 0 {
                    typesString = typesString + types
                } else {
                    typesString = typesString + ", \(types)"
                }
            }
        }

        //Sends data to the Summary Page
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            createTypeString()
            detailsScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            
            if (segue.identifier == "GotoSummarySegue"){
                let summary : Summary = segue.destination as! Summary
                summary.pickedImage = pickedImage
                summary.pickedTitle = pickedTitle
                summary.pickedLocation = pickedLocation
                summary.pickedTypes = typesString
                summary.pickedDescription = pickedDescription.text
                summary.pickedPrice = pickedPrice
                summary.editKey = editKey
                summary.longitude = longitude
                summary.latitude = latitude
                if (previousScreen == "EditView"){
                    summary.previousVC = "EditView"
                }
            }
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
