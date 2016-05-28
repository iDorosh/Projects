//
//  Register.swift
//  iOSUsers&Data
//
//  Created by Ian Dorosh on 1/9/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import UIKit
import Parse

class Register: UIViewController {

    //References to the text fields
    @IBOutlet weak var usersname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //Will hold the email and password that is coming in from the login screen
    var currentEmail : String = String()
    var currentPassword : String = String()
    
    //Will check for empty fields when the register button is clicked
    @IBAction func completeRegistration(sender: UIButton) {
        checkEmptyFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Will set the email and password field to the ones that are coming in from the login screen
        email.text = currentEmail
        password.text = currentPassword
        
        //Sets navigation bar to show
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Will check for empty fields before registering account
    func checkEmptyFields(){
        if (usersname.text == ""){
            showAlert("Empty Name", message: "Please enter a username to complete registration", dismiss: "OK")
        }
        else if (email.text == ""){
            showAlert("Empty Email", message: "Please enter a email to complete registration", dismiss: "OK")
        }
        else if (password.text == ""){
            showAlert("Empty Password", message: "Please enter a password to complete registration", dismiss: "OK")
        }
        else {
            checkAccount()
        }
    }
    
    //Will show alert based on what is calling it
    func showAlert(title : String, message : String, dismiss : String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: dismiss, style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Check Account will register the user using the email as a username and a name as the one that the user put into the name field
    func checkAccount(){
        let user = PFUser()
        user.username = self.currentEmail
        user.password = self.currentPassword
    
        user["name"] = self.usersname.text!
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
            } else {
                self.login()
            }
        }    }
    
    //Perform Login Segue
    func login(){
        PFUser.logInWithUsernameInBackground(currentEmail, password:currentPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // The login failed. Check error to see why.
            }
        }
        
    }

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
