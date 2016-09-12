//
//  LoginViewController.swift
//  Project X
//
//  Created by Ian Dorosh on 4/25/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class LoginViewController: UIViewController, UITextFieldDelegate {
    //Will bring the user back to the login screen
    @IBAction func backToLogin(_ segue: UIStoryboardSegue){}

//Variables
    //Strings
    var emailTextFieldText : String = String()
    var passwordTextFieldText : String = String()
    var errorMessage : String = ""
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alert view controllers
    var alertController = UIAlertController()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIColors
    var defaultColor = UIColor()
    var defaultBorderColor = UIColor()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    
    //User Email
    @IBOutlet weak var loginEmail: UITextField!
    //User Password
    @IBOutlet weak var loginPassword: UITextField!
    //Log In Button
    @IBOutlet weak var logInBttn: UIButton!
    //Register Button
    @IBOutlet weak var registerBttn: UIButton!
    //Skip Button
    @IBOutlet weak var skipBttn: UIButton!
    //Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    //Background Img
    @IBOutlet weak var BG: UIImageView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    
    //Log In Button Action
    @IBAction func logInAction(_ sender: UIButton) {
        logInClicked()
    }
    
    //Register Button Action
    @IBAction func registerAction(_ sender: UIButton) {
        registerClicked()
    }
    
    //Forgot password action
    @IBAction func forgotPassword(_ sender: UIButton) {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        enterEmail()
    }
    
    //Skip Button Action
    @IBAction func skipAction(_ sender: UIButton) {
        skipClicked()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultColor = loginEmail.textColor!
        defaultBorderColor = loginEmail.backgroundColor!
        UIApplication.shared.statusBarStyle = .default
        setUpTextFields()
        setUpBackground()
        setUpTapRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertController = showLoading("Signing In...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //UI
        //Blurr effect for the background image
        func setUpBackground(){
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            self.BG.addSubview(blurEffectView)
        }
    
        //Tap recognizer to minimize keyboard
        func setUpTapRecognizer(){
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        
        //Text Field Set Up
        func setUpTextFields(){
            loginEmail.delegate = self
            loginPassword.delegate = self
            loginEmail.addTarget(self, action: #selector(self.textViewDidChange(_:)), for: UIControlEvents.editingChanged)
            loginPassword.addTarget(self, action: #selector(self.textViewDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Keyboard
        //Next text field
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField === loginEmail) {
                loginPassword.becomeFirstResponder()
            } else if (textField === loginPassword) {
                loginPassword.resignFirstResponder()
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
                //self.presentViewController(alertController, animated: true, completion: nil)
                logInClicked()
            } else {
            }
            return true
        }
        
        //Resets view
        func textFieldDidEndEditing(_ textField: UITextField) {
            if (textField == loginPassword){
                scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            }
        }
        
        //Sets proper view postition when keyboard pops up
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if (textField == loginEmail){
                scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
            } else if (textField == loginPassword){
                scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
            }
        }
    
        //Changing back to default color
        func textViewDidChange(_ textView: UITextView) {
            if textView === loginEmail{
                loginEmail.layer.borderColor = defaultBorderColor.cgColor
            } else {
                loginPassword.layer.borderColor = defaultBorderColor.cgColor
            }
            textView.textColor = defaultColor
        }
        
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
            //Resets view offset
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            view.endEditing(true)
        }
    
        //Setting first responder to proper text fields
        func setFirstResponder(){
            if errorMessage == "Email"{
                loginEmail.becomeFirstResponder()
                setError(loginEmail)
            } else if errorMessage == "Invalid"{
                loginEmail.becomeFirstResponder()
                setError(loginEmail)
            }else {
                loginPassword.becomeFirstResponder()
                setError(loginPassword)
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Sends current email a with steps to reset the password
    func forgotPasswordSend(_ email : String){
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if error != nil {
              
                //Checking for errors
                if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                    switch (errorCode) {
                    case .errorCodeInvalidEmail:
                        self.errorMessage = "Invalid"
                        self.alertController.dismiss(animated: true, completion: nil)
                        self.errorResetingPassword("Error", subTitle: "Please enter a valid email")
                    case .errorCodeUserNotFound:
                        self.errorMessage = "Invalid"
                        self.alertController.dismiss(animated: true, completion: nil)
                        self.errorResetingPassword("Error", subTitle: "There is no account associated with this email")
                    default:
                        print(errorCode.rawValue)
                    }
                }
            } else {
                //Successfully sent email
                self.success("Email Sent", subTitle: "Follow the instructions in your email to reset your password")
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Log In Button has been clicked
    func logInClicked(){
        errorMessage = ""
        
            let email = loginEmail.text
            let password = loginPassword.text
            
            if email != "" && password != "" {
                dismissKeyboard()
                self.present(alertController, animated: true, completion: nil)
                // Login with the Firebase's authUser method
                
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                    if error != nil{
                        if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                            switch (errorCode) {
                            case .errorCodeInvalidEmail:
                                self.errorMessage = "Invalid"
                                self.alertController.dismiss(animated: true, completion: nil)
                                self.errorSigningIn("Oops!", subTitle: "Please enter a valid email")
                            case .errorCodeWrongPassword:
                                self.errorMessage = "Password"
                                self.alertController.dismiss(animated: true, completion: nil)
                                self.errorSigningIn("Oops!", subTitle : "The specified password is invalid")
                            case .errorCodeUserNotFound:
                                self.errorMessage = "Invalid"
                                self.alertController.dismiss(animated: true, completion: nil)
                                self.errorSigningIn("Oops!", subTitle: "This email is not associated with an account")
                            default:
                                print(errorCode.rawValue)
                            }
                        }
                    }
                    else {
                        // Storing User UID
                        UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                        self.alertController.dismiss(animated: true, completion: nil)
                        // Enter Main Feed
                        self.success("Signed In!", subTitle: "Welcome to Bartr")
                        
                    }
                }
                
                
            } else {
                // There was a problem
                self.alertController.dismiss(animated: true, completion: nil)
                errorSigningIn("Oops!", subTitle: "Don't forget to enter your email and password.")
            }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Send email and password to registration screen
    
    //Sending email and password to the register screen if they were filled out.
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registerNew" {
                let signUp : Register = segue.destination as! Register
                let email = loginEmail.text
                let password = loginPassword.text
            if email != "" {
                signUp.emailText = email!
                signUp.passwordText = password!
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    //Alert views
    
    //Successfully signed in
    func success(_ title : String, subTitle : String){
        let alertView = SCLAlertView
        alertView.addButton("Continue") {
            alertView.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "skipLoginSegue", sender: nil)}
        alertView.showCloseButton = false
        alertView.showSuccess(title, subTitle: subTitle)
    }
    
    //Error reseting password
    func errorResetingPassword(_ title : String, subTitle : String){
        let alertView = SCLAlertView
        alertView.showCloseButton = false
        alertView.addButton("Try Again") {
            self.enterEmail()
        }
        alertView.addButton("Cancel") {
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess(title, subTitle: subTitle) 
    }
    
    //Error signing in
    func errorSigningIn(_ title : String, subTitle : String){
        let alertView = SCLAlertView
        alertView.addButton("Done", target:self, selector:#selector(setFirstResponder))
        alertView.showCloseButton = false
        
        alertView.showWarning(title, subTitle: subTitle)
    }
    
    //Enter email to reset password
    func enterEmail(){
        let alert = SCLAlertView
        alert.showCloseButton = false
        let txt = alert.addTextField("Enter Email")
        alert.addButton("Reset Password") {
            self.forgotPasswordSend((txt.text!).lowercased())
        }
        alert.addButton("Cancel"){ alert.dismiss(animated: true, completion: nil)}
        alert.showEdit("Forgot Password", subTitle: "Please enter an email address so we can send you a password reset link")
    }

    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    // Segues
    //Register Button has been clicked
    func registerClicked(){
            performSegue(withIdentifier: "registerNew", sender: nil)
    }
    
    //Skip Button has been clicked
    func skipClicked(){
        performSegue(withIdentifier: "skipLoginSegue", sender: nil)
    }
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Setting errors to text fields
    func setError(_ textField : UITextField){
        textField.layer.borderColor = hexStringToUIColor("#f27163").cgColor
        textField.layer.cornerRadius = 10.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
    }
    
    //Setting good to go to text fields
    func setGoodToGo(_ textField : UITextField){
        textField.layer.borderColor = hexStringToUIColor("#91c769").cgColor
        textField.layer.cornerRadius = 10.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    

}
