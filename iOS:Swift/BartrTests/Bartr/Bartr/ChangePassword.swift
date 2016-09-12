//
//  ChangePassword.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/23/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView

class ChangePassword: UIViewController, UITextFieldDelegate {
    
//Variables
    //Alert controller
    var alertController = UIAlertController()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Boolean
    var length : Bool = false
    var short : Bool = false
    var space : Bool = false
    var empty : Bool = false
    var validPassword : Bool = false
    var passwordsMatch : Bool = false
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
     @IBOutlet weak var currentPassword: UITextField!
     @IBOutlet weak var newPassword: UITextField!
     @IBOutlet weak var confirmPassword: UITextField!
     @IBOutlet weak var done: UIButton!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Actions
    
    @IBAction func done(_ sender: UIButton) {
        self.view.endEditing(true)
        checkFields()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        done.isHidden = true
        currentPassword.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        alertController = showLoading("Saving Changes...")
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Keyboard
        //Get keyboard string and check
            func textFieldDidBeginEditing(_ textField: UITextField) {
                done.isHidden = false
            }
            
            func checkFields(){
                validPassword = false
                passwordsMatch = false
               
                //Errors
                length  = false
                short  = false
                space  = false
                empty  = false
                
                //Check for space
                for c in newPassword.text!.characters {
                    if c == " "{
                        space = true
                    }
                }
                
                //Field empty
                let trimmedString = currentPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
                let trimmedString2 = newPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
                let trimmedString3 = confirmPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
                
                if  trimmedString == ""  {
                    emptyFields("Current password is missing")
                } else if trimmedString2 == ""{
                    emptyFields("New password is missing")
                } else if trimmedString3 == ""{
                    emptyFields("Confirm password is missing")
                }else if newPassword.text?.characters.count > 18 {
                    length = true
                    toLong()
                    
                } else if newPassword.text?.characters.count < 6 && newPassword.text != ""{
                    short = true
                    toShort()
                } else if space{
                    space = true
                    containsSpace()
                } else {
                    if confirmPassword.text == newPassword.text {
                        changePassword()
                    }else {
                        passwordMatch()
                    }
                }
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Change Password
            func changePassword(){
            
                //Show activity
                self.present(alertController, animated: true, completion: nil)
                var credential: FIRAuthCredential
                
                //Create current user credential to reauthenticate user
                let user = FIRAuth.auth()?.currentUser
                credential = FIREmailPasswordAuthProvider.credential(withEmail: (FIRAuth.auth()?.currentUser?.email)!, password: currentPassword.text!)

                //Reauthenticate user with credential
                user?.reauthenticate(with: credential) { error in
                    if error != nil {
                        self.incorrectPassword()
                    } else {
                    FIRAuth.auth()?.currentUser?.updatePassword(self.newPassword.text!, completion: { (error) in
                        if error != nil {
                            self.alertController.dismiss(animated: true, completion: nil)
                            self.fail()
                        } else {
                            self.alertController.dismiss(animated: true, completion: nil)
                            
                            //Reauthenticat once more to update information
                            var newCredential: FIRAuthCredential
                            newCredential = FIREmailPasswordAuthProvider.credential(withEmail: (FIRAuth.auth()?.currentUser?.email)!, password: self.newPassword.text!)
                             user?.reauthenticate(with: newCredential, completion: nil)
                            self.view.endEditing(true)
                            self.success()
                        }
                        
                    })
                }
              }
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
    
            //Incorrect current password
            func incorrectPassword(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    self.currentPassword.becomeFirstResponder()
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "Current Password is incorrect")
            }

            //Failed
            func fail(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Done"){
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "Something went wrong")
            }
    
            //Success
            func success(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Done"){
                    alertView.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "BackToEdit", sender: self)}
                alertView.showCloseButton = false
                self.view.endEditing(true)
                alertView.showSuccess("Update", subTitle: "Password update successful")
            }
    
            //Password is to long
            func toLong(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    self.newPassword.becomeFirstResponder()
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "New password is to long")
            }
    
            //Password is to short
            func toShort(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    self.newPassword.becomeFirstResponder()
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "New password is to short")
            }
    
            //Password Contains space
            func containsSpace(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    self.newPassword.becomeFirstResponder()
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "New password contains spaces")
            }
    
            //Passwords dont match
            func passwordMatch(){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    self.confirmPassword.becomeFirstResponder()
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: "passwords don't match")
            }
    
            //Field is empty
            func emptyFields(_ subTitle : String){
                alertController.dismiss(animated: true, completion: nil)
                let alertView = SCLAlertView
                alertView.addButton("Ok"){
                    if subTitle == "Current password is missing"{
                        self.currentPassword.becomeFirstResponder()
                    } else if subTitle == "New password is missing" {
                        self.newPassword.becomeFirstResponder()
                    } else {
                        self.confirmPassword.becomeFirstResponder()
                    }
                    alertView.dismiss(animated: true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showWarning("Error", subTitle: subTitle)
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
