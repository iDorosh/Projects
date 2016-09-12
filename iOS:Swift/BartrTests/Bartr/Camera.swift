//
//  Camera.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import ALCameraViewController
import FirebaseDatabase
import SCLAlertView

class Camera: UIViewController, UITextFieldDelegate {
    
    @IBAction func backToPhoto(_ segue: UIStoryboardSegue){}
    
//Data
    //Edit selected post
    var postForEdit = [Post]()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Variables
    //Strings
    var orignalView : String = ""
    var city : String = ""
    var previousScreen : String?
    var editedTitle : String?
    var editedPrice : String?
    var editedLocation : String?
    var editedPhoto : String?
    var editedType : String = String()
    var editedProfileImg : String?
    var editedUser : String?
    var editedDetails : String?
    var editKey : String = String()
    var typeString : String = String()
    var errorMessage : String = ""
    //NSString
    var base64String : NSString!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Double
    var longitude : Double = Double()
    var latitude : Double = Double()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Booleans
    var cameraOpened : Bool = false
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    var locationFound : Bool = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImage 
    var capturedImage : UIImage = UIImage()
    var decodedPreviewImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIColor
    var defaultColor = UIColor()
    var defaultBorderColor = UIColor()
    var defaultLabelColor = UIColor()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
    var alertController = UIAlertController()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    
    //Title text field
    @IBOutlet weak var titleField: UITextField!
    //Description Text Box
    @IBOutlet weak var textBox: UITextView!
    //PreviewImage
    @IBOutlet weak var previewImage: UIImageView!
    //BackgroundImage
    @IBOutlet weak var bgImage: UIImageView!
    //ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    //Price Field
    @IBOutlet weak var priceField: UITextField!
    //Title
    @IBOutlet weak var screenTitle: UILabel!
    //Error Labels
    @IBOutlet weak var priceErrorLabel: UILabel!
    @IBOutlet weak var requiredCharacterFields: UILabel!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    
    //Open Gallery
    @IBAction func takeImage(_ sender: UIButton) {
       openCamera()
    }
    
    //Open Library
    @IBAction func openLibrary(_ sender: AnyObject) {
        openLibrary()
    }
    
    //Permision not available
    @IBAction func libraryChanged(_ sender: AnyObject) {
        libraryEnabled = !libraryEnabled
    }
    
    //Crop
    @IBAction func croppingChanged(_ sender: AnyObject) {
        croppingEnabled = !croppingEnabled
    }
    
    //Discard New
    @IBAction func discardListing(_ sender: UIButton) {
        discardNew("Discard Listing", subTitle: "Listing will be discarded")
    }
    
    //Go to location
    @IBAction func nextClicked(_ sender: UIButton) {
        view.endEditing(true)
        if priceErrorLabel.text == "Please enter numbers only" {
            priceError("Price Error", subTitle: "Please enter numbers only")
        } else {
            checkFields()
        }
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Load UI
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewWillAppear(_ animated: Bool) { setUpViewWillAppear()}
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        setUpViewDidLoad()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Setup View
        //Check if the user wants to edit the listng
        func setUpViewWillAppear(){
            navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            if UserDefaults.standard.string(forKey: "posted") == "true"{
                let defaults = UserDefaults.standard
                defaults.set("false", forKey: "posted")
                viewDidLoad()
            }
        }
        
        //Set up the ui and place in data if its an edit
        func setUpViewDidLoad(){
            
            //Get default colors for text fields and labels
            defaultLabelColor = requiredCharacterFields.textColor
            defaultColor = titleField.textColor!
            defaultBorderColor = titleField.backgroundColor!
            
            //Set textfield colors
            titleField.layer.borderColor = defaultBorderColor.cgColor
            priceField.layer.borderColor = defaultBorderColor.cgColor
            
            //Update posts if the previous screen is the details listing
            if previousScreen == "EditView"{
                updatePosts()
                self.tabBarController?.selectedIndex = 2
            } else {
                loadUI()
            }
        }
        
        //Setup variables if previous is details
        func setVariables(){
            let post = postForEdit[0]
            editedTitle = post.postTitle
            editedPrice = post.postPrice
            editedLocation = post.postLocation
            editedPhoto = post.postImage
            editedProfileImg = post.postUserImage
            editedUser = post.username
            editedDetails = post.postText
            editedType = post.postType
            longitude = Double(post.lon)!
            latitude = Double(post.lat)!
            city = post.postLocation
            
            decodeImages()
            addTapRecognizer()
            
            loadUI()
        }
        
        //Set up textfields and labels
        func loadUI(){
            setUpTextFields()
            addBlurrEffect()
            addTapRecognizer()
        }

        //Decode image and set it as decodedPreviewImage
        func decodeImages(){
            let decodedData = Data(base64Encoded: editedPhoto! , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedimage = UIImage(data: decodedData!)
            decodedPreviewImage = decodedimage! as UIImage
        }
    
        //Add blur effect to the background image
        func addBlurrEffect(){
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            self.bgImage.addSubview(blurEffectView)
        }
        
        //Tap Recognizer to minimize the keyboard
        func addTapRecognizer(){
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Camera.dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Text Fields
        //Text Field Set Up
        func setUpTextFields(){
            titleField.delegate = self
            priceField.delegate = self
            titleField.addTarget(self, action: #selector(self.textViewDidChange(_:)), for: UIControlEvents.editingChanged)
            priceField.addTarget(self, action: #selector(self.textViewDidChange(_:)), for: UIControlEvents.editingChanged)

            
            if previousScreen == "EditView"{
                titleField.text = editedTitle
                if editedPrice == "Negotiable" {
                    priceField.placeholder = "Negotiable"
                } else {
                    _ = Locale.current
                    let formatter = NumberFormatter()
                    formatter.locale = Locale(localeIdentifier: "en_US")
                    formatter.numberStyle = NumberFormatter.Style.currency
                    
                    let moneyInt = formatter.number(from: editedPrice!)?.int32Value
                    priceField.text = String(moneyInt!)
                }
                
                screenTitle.text = "Edit About"
                previewImage.image = decodedPreviewImage
            } else {
                screenTitle.text = "About"
                titleField.text = ""
                priceField.text = ""
                previewImage.image = UIImage(named: "NoImageSelected")
            }
            
        }
        
        //Next text field
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField === titleField) {
                priceField.becomeFirstResponder()
            } else if (textField === priceField) {
                priceField.resignFirstResponder()
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            } else {
            }
            return true
        }
        
        //Sets proper view postition when keyboard pops up
        func textFieldDidBeginEditing(_ textField: UITextField) {
            UIApplication.shared.isStatusBarHidden = true
            if (textField == titleField){
                scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
            } else if (textField == priceField){
                scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
            }
        }
        
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
            //Resets view offset
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            view.endEditing(true)
            UIApplication.shared.isStatusBarHidden = false
        }
        
        //Resets view
        func textFieldDidEndEditing(_ textField: UITextField) {
            if (textField == priceField){
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            }
        }
    
        //Check Fields
        func checkFields(){
            if titleField.text == "" {
                titleField.becomeFirstResponder()
                errorInvalid("Missing Title", subTitle: "Please include a title")
            } else if self.titleField.text?.characters.count < 6 {
                titleField.becomeFirstResponder()
                errorInvalid("Short Title", subTitle: "The title is to short")
            } else if self.titleField.text?.characters.count > 24  {
                titleField.becomeFirstResponder()
                errorInvalid("Long Title", subTitle: "The title is to long")
            }
            else {
                if previousScreen == "EditView"{
                    performSegue(withIdentifier: "editingSegue", sender: self)
                } else {
                    performSegue(withIdentifier: "locationSegue", sender: self)
                }
            }
        }
        
        
        func textViewDidChange(_ textView: UITextView) {
            textView.layer.borderColor = defaultBorderColor.cgColor
            textView.textColor = defaultColor
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Find out what the text field will be after adding the current edit
            if (textField == priceField){
                let text = (priceField.text! as NSString).replacingCharacters(in: range, with: string)
                
                if let intVal = Int(text) {
                    priceErrorLabel.textColor = defaultLabelColor
                    priceErrorLabel.text = "Only Numbers, Default is Negotiable"
                    print(intVal)
                    
                } else {
                    priceErrorLabel.textColor = hexStringToUIColor("#f27163")
                    priceErrorLabel.text = "Please enter numbers only"
                }
                
            }
            
            // Return true so the text field will be changed
            return true
        }
    
    
        //Create Invalid alert
        func errorInvalid(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.showCloseButton = false
            alertView.addButton("Ok") {
                if self.priceField.text != "" {
                    if Int(self.priceField.text!) == nil{
                        self.setError(self.priceField)
                        self.priceField.becomeFirstResponder()
                    }
                }
                if self.titleField.text == "" || self.titleField.text?.characters.count < 7 {
                    self.setError(self.titleField)
                    self.titleField.becomeFirstResponder()
                }
            }
            alertView.showWarning(title, subTitle: subTitle)
        }
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Camera
        //Opening custom CameraViewController
        func openCamera()
        {
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                if (image != nil){
                   self!.previewImage.image = image 
                }
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
        
        //Opeing Library
        func openLibrary(){
            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled) { image, asset in
                self.previewImage.image = image
                self.dismiss(animated: true, completion: nil)
            }
            present(libraryViewController, animated: true, completion: nil)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Update Posts
    func updatePosts(){
        DataService.dataService.POST_REF.child(editKey).observeSingleEvent(of: .value, with: { snapshot in
            self.postForEdit = []
            
            
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                
                
                if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    let post = Post(key: key, dictionary: postDictionary)
                    self.postForEdit.insert(post, at: 0)
                    self.setVariables()
                    self.loadUI()
                } else {
                    //self.navigationController?.popViewControllerAnimated(true)
                }
            }
            
        })
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Remove Listing
    func removeListing(){
        titleField.text = ""
        priceField.text = ""
        previewImage.image = UIImage(named: "NoImageSelected")
        if previousScreen == "EditView"{
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "MainSegue", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Prepare for segue
        //Sends data to next view controller
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
            UIApplication.shared.isStatusBarHidden = false
                if previousScreen == "EditView"{
                    if segue.identifier == "editingSegue"{
                        let listingLocation : ListingLocation = segue.destination as! ListingLocation
                        listingLocation.editType = editedType
                        listingLocation.previousScreen = "EditView"
                        listingLocation.pickedImage = previewImage.image!
                        listingLocation.pickedTitle = titleField.text!
                        listingLocation.pickedLocation = editedLocation!
                        listingLocation.editProfileImg = editedProfileImg!
                        listingLocation.editPhoto = previewImage.image!
                        listingLocation.editUser = editedUser!
                        listingLocation.editDetails = editedDetails!
                        listingLocation.editKey = editKey
                        listingLocation.pickedPrice = priceField.text!
                        listingLocation.longitude = longitude
                        listingLocation.latitude = latitude
                        listingLocation.city = city
                    }
                } else {
                    if segue.identifier == "locationSegue"{
                    let listingLocation : ListingLocation = segue.destination as! ListingLocation
                    listingLocation.pickedImage = previewImage.image!
                    listingLocation.pickedTitle = titleField.text!
                    if priceField.text == ""{
                        listingLocation.pickedPrice = priceField.placeholder!
                    } else {
                        listingLocation.pickedPrice = priceField.text!
                    }

                }
            }
        }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
        //Discard New Listing
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
    
        //Set Price Error
        func priceError(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.showCloseButton = false
            alertView.addButton("Ok") {
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showWarning(title, subTitle: subTitle)
        }

        //Set error for textfield
        func setError(_ textField : UITextField){
            textField.layer.borderColor = hexStringToUIColor("#f27163").cgColor
            textField.layer.cornerRadius = 10.0
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
