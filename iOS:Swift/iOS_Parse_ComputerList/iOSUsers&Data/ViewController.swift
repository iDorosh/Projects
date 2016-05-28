//
//  ViewController.swift
//  iOSUsers&Data
//
//  Created by Ian Dorosh on 1/9/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate{
    
    var email : String = String();
    var password : String = String();
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    

    //Login Button Action to determine if the account exists or needs to be created
    @IBAction func LoginorRegister(sender: UIButton) {
        indicator.hidesWhenStopped = true
        indicator.hidden = false
        indicator.startAnimating()
        userInput()
    }
    
    
    //Text field references
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Will check if the user is logged in
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            performSegueWithIdentifier("loginSegue", sender: self)
        } else {
            // Show the signup or login screen
        }
        
        //Will minimize the keyboard when the user hits done
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //Looks for single or multiple taps to dismis the keyboard when the user clicks outside the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //will dismiss the keyboard when the user clickes outside the keyboard
        view.endEditing(true)
    }
    
    //will dismiss the keyboard when the user clickes the done key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    //hides the indicator and the navigation bar
    override func viewDidAppear(animated: Bool) {
        indicator.hidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Will bring the user back to the login screen after the log out
    @IBAction func backToCreate(segue: UIStoryboardSegue)
    {
    }
    
    
    
    //Custom Functions
    
    //Get Email and Password
    func userInput(){
        //Will get email and password from the textfields
        email = self.emailTextField.text!
        password = self.passwordTextField.text!
        
        checkUser()
        
    }
    
    //Will check to see if the user exists. If the user exists it will attempt login else it will bring them to the register screen
    func checkUser(){
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: email)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if (objects!.count > 0){
                    self.login()
                } else {
                    self.register()
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    
    //Perform Login Segue
    func login(){
        
        //Will attempt login and if the password is incorrect then an alert will display
        PFUser.logInWithUsernameInBackground(email, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.indicator.stopAnimating()
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                self.showAlert("Incorrect Password", message: "The password you have entered doesn't match our records. \n\nPlease Try Again", dismiss: "Dismiss")
            }
        }
    }
    
    //Perform Register Segue
    func register(){
        performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    //Will pass data to the register screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "registerSegue"){
            let registerVC : Register = segue.destinationViewController as! Register
            registerVC.currentEmail = email
            registerVC.currentPassword = password
        }
    }
    
    //Will show alert if the password is incorrect
    func showAlert(title : String, message : String, dismiss : String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: dismiss, style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

