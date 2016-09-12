//
//  Register.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/12/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//


import UIKit
import ALCameraViewController
import FirebaseDatabase
import FirebaseAuth
import SCLAlertView

class Register: UIViewController, UITextFieldDelegate {
    
//Variables
    //FireBase URL
    let ref = BASE_URL
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Data
    var users : [String] = []
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var typeString : String = String()
    var emailText : String = String()
    var passwordText : String = String()
    var errorMessage : String = ""
    
    var base64String : NSString!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Boolean
    var croppingEnabled: Bool = true
    var libraryEnabled: Bool = true
    var usernameExists = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImageView
    var capturedImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIColor
    var defaultColor = UIColor()
    var textColor = UIColor()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    // UIAlert View
     var alertController = UIAlertController()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var userNameRequirements: UILabel!
    @IBOutlet weak var passwordRequirements: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!

    //Username text field
    @IBOutlet weak var usernameField: UITextField!
    //Email text field
    @IBOutlet weak var emailField: UITextField!
    //password text field
    @IBOutlet weak var passwordField: UITextField!
    //confirm password text field
    @IBOutlet weak var confirmPasswordField: UITextField!
    //Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    //Profile Image
    @IBOutlet weak var profileImage: UIImageView!
    //Add Image
    @IBOutlet weak var addImage: UIButton!
    //BG Image
    @IBOutlet weak var BG: UIImageView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    
//Actions
    @IBAction func addImageAction(_ sender: UIButton) { openCamera() }
    @IBAction func openLibrary(_ sender: AnyObject) { openLibrary() }
    @IBAction func libraryChanged(_ sender: AnyObject) { libraryEnabled = !libraryEnabled }
    @IBAction func croppingChanged(_ sender: AnyObject) { croppingEnabled = !croppingEnabled }
    
    //Register Action
    @IBAction func registerAction(_ sender: UIButton) {
        registerClicked()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//UI
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }
   
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Set up ui textfield and colors
    func setUpViewDidLoad(){
        setUpTextFields()
        //Get default color to change back after user enters text
        defaultColor = emailField.backgroundColor!
        textColor = userNameRequirements.textColor!
        getUsers()
        
        //Alert view will display when creating an account
        alertController = showLoading("Creating Account...")
        
        //Set email and password text from previous screen
        emailField.text = emailText
        passwordField.text = passwordText
        
        if emailField.text != "" {
            checkEmail()
        }
        
        //Setting background blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        self.BG.addSubview(blurEffectView)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Register.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if profileImage.image == nil {
            profileImage.image = UIImage(named: "LoginImg")
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Open Camera
    func openCamera()
        {
            //Present camera view controller and set image to taken image
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                self!.profileImage.image = image
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
        
    func openLibrary(){
        //Present library view controller and set image to picked image
        let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled) { image, asset in
            self.profileImage.image = image
            self.dismiss(animated: true, completion: nil)
        }
        present(libraryViewController, animated: true, completion: nil)
    }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Keyboard && Text fields
        //Check if email is valid
        func checkEmail(){
            if isValidEmail(emailField.text!) {
                setGoodToGo(emailField)
            } else {
                setError(emailField)
            }
        }
    
        //Set first responders
    
        func MakeFirstResponder(){
            if errorMessage == "match" {
                setError(confirmPasswordField)
                passwordField.becomeFirstResponder()
            }
            if errorMessage == "passwords"{
                setError(passwordField)
                setError(confirmPasswordField)
                passwordField.becomeFirstResponder()
            }
            
            if errorMessage == "email"{
                setError(emailField)
                emailField.becomeFirstResponder()
            }
            
            if (errorMessage == "username"){
                setError(usernameField)
                usernameField.becomeFirstResponder()
            }
            
            if errorMessage == "missing"{
                if confirmPasswordField.text == "" {
                    setError(confirmPasswordField)
                    confirmPasswordField.becomeFirstResponder()
                }
                
                if passwordField.text == "" {
                    setError(passwordField)
                    passwordField.becomeFirstResponder()
                }
                
                if emailField.text == "" {
                    setError(emailField)
                    emailField.becomeFirstResponder()
                }
                
                if usernameField.text == "" {
                    setError(usernameField)
                    usernameField.becomeFirstResponder()
                }
                
            }
        }
    
        //Set errors for text field
        func setError(_ textField : UITextField){
            textField.layer.borderColor = hexStringToUIColor("#f27163").cgColor
            textField.layer.cornerRadius = 10.0
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
        }
    
        //Set good to go for text field
        func setGoodToGo(_ textField : UITextField){
            textField.layer.borderColor = hexStringToUIColor("#91c769").cgColor
            textField.layer.cornerRadius = 10.0
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
        }

        
        
        //Text Field Set Up
        func setUpTextFields(){
            //Will set delegates and selectors
            usernameField.delegate = self
            emailField.delegate = self
            passwordField.delegate = self
            confirmPasswordField.delegate = self
            usernameField.addTarget(self, action: #selector(self.usernameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            emailField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            passwordField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            confirmPasswordField.addTarget(self, action: #selector(self.confirmPasswordDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Check fields
        func usernameFieldDidChange(_ textView: UITextView) {
            //User exists error usename is to long or contains space
            var uExists : Bool = false
            var length : Bool = false
            var space : Bool = false
            
            //User name exists or !
            if users.contains(usernameField.text!.lowercased()){
                uExists = true
                setError(usernameField)
            } else {
                setGoodToGo(usernameField)
            }
            
            //User name is to long
            if usernameField.text?.characters.count > 18 {
                length = true
                setError(usernameField)
            }
            
            //username is less then 6 characters
            if usernameField.text?.characters.count < 6 {
                setError(usernameField)
                userNameRequirements.textColor = hexStringToUIColor("#f27163")
                userNameRequirements.text = "Username to short"
            }
            
            //Username contains a space
            for c in usernameField.text!.characters {
                if c == " "{
                    space = true
                    setError(usernameField)
                }
            }
            
            //Set lavel and text color for username
            userNameRequirements.textColor = textColor
            userNameRequirements.text = "6-18 Characters, No Spaces"
            
            //Set text error and color to short
            if usernameField.text?.characters.count < 6 {
                setError(usernameField)
                userNameRequirements.textColor = hexStringToUIColor("#f27163")
                userNameRequirements.text = "Username to short"
            }
            
            //Set text error and color exists
            if uExists {
                userNameRequirements.textColor = hexStringToUIColor("#f27163")
                userNameRequirements.text = "Username already exists"
            }
            
            //Set text error and color has space
            if space {
                userNameRequirements.textColor = hexStringToUIColor("#f27163")
                userNameRequirements.text = "Contains spaces"
            }
            
            //Set text error and color to long
            if length {
                    userNameRequirements.textColor = hexStringToUIColor("#f27163")
                    userNameRequirements.text = "Over 18 characters"
            
            }
            
            //Set text error and color username empty
            if usernameField.text == "" {
                userNameRequirements.textColor = hexStringToUIColor("#f27163")
                userNameRequirements.text = "Username empty"
            }
            
            
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
        //Check email
        func emailFieldDidChange(_ textView: UITextView) {
            if isValidEmail(emailField.text!){
                setGoodToGo(emailField)
            } else {
                setError(emailField)
            }
        
        }
    
        //Check for valid email
        func isValidEmail(_ testStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = Predicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        //Password changed
        func passwordFieldDidChange(_ textView: UITextView) {
            
            //Check length and for space
            var length : Bool = false
            var space : Bool = false
            
            //Check length
            if passwordField.text?.characters.count >= 6 {
                setGoodToGo(passwordField)
            }
            if passwordField.text?.characters.count > 18 {
                length = true
                setError(passwordField)
            }
            
            
            if passwordField.text?.characters.count < 6 {
                textView.layer.borderColor = defaultColor.cgColor
            }
            
            //Check for space
            for c in passwordField.text!.characters {
                if c == " "{
                    space = true
                    setError(passwordField)
                }
            }
            
            //check for size
            if passwordField.text?.characters.count < 6 {
                textView.layer.borderColor = defaultColor.cgColor
            }
            
            //Set label color for default text
            passwordRequirements.textColor = textColor
            passwordRequirements.text = "6-18 Characters, No Spaces"
            
            //Set label and color for error contains space
            if space {
                passwordRequirements.textColor = hexStringToUIColor("#f27163")
                passwordRequirements.text = "Contains space"
            }
            
            //Set label and color for error over 18 characters
            if length {
                passwordRequirements.textColor = hexStringToUIColor("#f27163")
                passwordRequirements.text = "Over 18 characters"
            }
            
            
            if confirmPasswordField.text != "" {
                if confirmPasswordField.text == passwordField.text {
                    setGoodToGo(confirmPasswordField)
                    confirmPasswordLabel.textColor = textColor
                    confirmPasswordLabel.text = "6-18 Characters, No Spaces"
                }
            }
        }
    
        //Passwords dont match
        func confirmPasswordDidChange(_ textView: UITextView) {
            if confirmPasswordField.text != passwordField.text{
                setError(confirmPasswordField)
                confirmPasswordLabel.textColor = hexStringToUIColor("#f27163")
                confirmPasswordLabel.text = "Passwords don't match"
            } else {
                setGoodToGo(confirmPasswordField)
                confirmPasswordLabel.text = ""
            }
        }
    
        //Next text field
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField === usernameField) {
                emailField.becomeFirstResponder()
            } else if (textField === emailField){
                passwordField.becomeFirstResponder()
            } else if (textField === passwordField){
                confirmPasswordField.becomeFirstResponder()
            } else if (textField === confirmPasswordField) {
                confirmPasswordField.resignFirstResponder()
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
                registerClicked()
            } else {
            }
            return true
        }
        
        //Move scroll view up with keyboard
        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == usernameField {
                if usernameField.text == "" {
                    userNameRequirements.textColor = hexStringToUIColor("#f27163")
                    userNameRequirements.text = "Username empty"
                }
            }
            
            //check password length
            if textField == passwordField {
                if passwordField.text?.characters.count < 6 {
                    setError(passwordField)
                    passwordRequirements.textColor = hexStringToUIColor("#f27163")
                    passwordRequirements.text = "Password is to short"
                }
                if passwordField.text == "" {
                    passwordRequirements.textColor = hexStringToUIColor("#f27163")
                    passwordRequirements.text = "Password empty"
                }
            }

            //Hide status bar
            UIApplication.shared.isStatusBarHidden = false
            if (textField == confirmPasswordField){
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            }
        }
    
        //Move up scroll view
        func textFieldDidBeginEditing(_ textField: UITextField) {
            UIApplication.shared.isStatusBarHidden = true
            scrollView.setContentOffset(CGPoint(x: 0,y: 160), animated: true)
        }
        
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            view.endEditing(true)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Get all users
    func getUsers(){
        DataService.dataService.USER_REF.observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.usernameExists = false
                for snap in snapshots {
                    let test = snap.value!.object(forKey: "username") as! String
                    self.users.append(test.lowercased())
                }
            }
        })
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Complete Registration
    func registerClicked(){
        dismissKeyboard()
        errorMessage = ""
        //Send data from text fields to Firebase
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        capturedImage = profileImage.image!
        
        //JPEG to a Base64String to allow saving to Firebase
        var data: Data = Data()
        data = UIImageJPEGRepresentation(capturedImage,0.1)!
        
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
 
        //Checks if passwords are the same
            if username != "" && email != "" && password != "" && confirmPassword != "" && password?.characters.count >= 6 && username?.characters.count >= 6 && confirmPassword?.characters.count >= 6 && isValidEmail(emailField.text!){
                if (confirmPassword == password){
                self.present(alertController, animated: true, completion: nil)
                            if (!self.usernameExists) {
                                // Set Email and Password for the New User.
                                FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                                    
                                    if error != nil {
                            
                                        //Check errors from firebase
                                        if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                                            switch (errorCode) {
                                            case .errorCodeEmailAlreadyInUse:
                                                self.errorMessage = "email"
                                                self.alertController.dismiss(animated: true, completion: nil)
                                                self.errorSigningUp("Oops!", subTitle: "An account with this email address already exists")
                                                self.setError(self.emailField)
                                                self.emailField.becomeFirstResponder()
                                            case .errorCodeInvalidEmail:
                                                self.errorMessage = "email"
                                                self.alertController.dismiss(animated: true, completion: nil)
                                                self.errorSigningUp("Oops!", subTitle: "Please enter a valid email address")
                                                self.emailField.becomeFirstResponder()
                                            default:
                                                print("Handle default situation")
                                            }
                                        }
                                    } else {
                                        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (createdusername, error) in
                                            let user = ["email": email!, "username": username!, "profileImage" : base64String, "rating" : "5.0"]
                                            // Send Data to DataService.swift
                                            DataService.dataService.createNewAccount((createdusername?.uid)!, user: user)
                                            
                                            //Saving User uid to User Defaults
                                            UserDefaults.standard.setValue(FIRAuth.auth()?.currentUser?.uid, forKey: "uid")
                                            
                                            //Opens Main Feed
                                            self.alertController.dismiss(animated: true, completion: nil)
                                            self.success("Registered!", subTitle: "Welcome to Bartr")

                                        })
                                        
                                    }
                                    
                                }
                            } else {
                                self.errorMessage = "username"
                                self.alertController.dismiss(animated: true, completion: nil)
                                errorSigningUp("Oops!", subTitle: "This username already exists")
                            }
            } else {
                //Shows Passwords don't match allert
                    self.errorMessage = "match"
                    errorSigningUp("Oops!", subTitle: "Passwords don't match")
                    confirmPasswordField.becomeFirstResponder()

            }
        } else {
            //Shows Alert
                if userNameRequirements.text == "Username already exists" {
                    self.errorMessage = "username"
                    errorSigningUp("Oops!", subTitle: "This username is taken")
                    usernameField.becomeFirstResponder()
                }else if usernameField.text == "" || usernameField.text?.characters.count < 6 || usernameField.text?.characters.count > 18 {
                    self.errorMessage = "username"
                    errorSigningUp("Oops!", subTitle: "Please enter a valid username")
                    usernameField.becomeFirstResponder()
                }else if emailField.text == "" || !isValidEmail(emailField.text!){
                    self.errorMessage = "email"
                    errorSigningUp("Oops!", subTitle: "Please enter a valid email")
                    emailField.becomeFirstResponder()
                }else if passwordField.text == "" || passwordField.text?.characters.count < 6 || passwordField.text?.characters.count > 18 {
                    self.errorMessage = "passwords"
                    errorSigningUp("Oops!", subTitle: "Please enter a valid password")
                    passwordField.becomeFirstResponder()
                }else if confirmPasswordField.text != passwordField.text {
                    self.errorMessage = "match"
                    errorSigningUp("Oops!", subTitle: "Passwords don't match")
                    confirmPasswordField.becomeFirstResponder()
                }
            
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Alerts
    
    //Successfully signed in
    func success(_ title : String, subTitle : String){
        let alertView = SCLAlertView
        alertView.addButton("Continue") {
            alertView.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "registerSegue", sender: nil)}
        alertView.showCloseButton = false
        alertView.showSuccess(title, subTitle: subTitle)
    }
    
    //Error
    func errorSigningUp(_ title : String, subTitle : String){
        let alertView = SCLAlertView
        alertView.showCloseButton = false
        alertView.addButton("Ok") {
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess(title, subTitle: subTitle)
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}

