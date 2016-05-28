//
//  AddBuild.swift
//  iOSUsers&Data
//
//  Created by Ian Dorosh on 1/14/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import UIKit
import Parse

class AddBuild: UIViewController {
    
    
    //References for all the text fields (Component and Price)
    @IBOutlet weak var buildTitle: UITextField!
    
    @IBOutlet weak var buildCase: UITextField!
    @IBOutlet weak var casePrice: UITextField!
    
    @IBOutlet weak var buildMB: UITextField!
    @IBOutlet weak var mbPrice: UITextField!
    
    @IBOutlet weak var buildCPU: UITextField!
    @IBOutlet weak var cpuPrice: UITextField!
    
    @IBOutlet weak var buildGPU: UITextField!
    @IBOutlet weak var gpuPrice: UITextField!
    
    
    @IBOutlet weak var buildRAM: UITextField!
    @IBOutlet weak var ramPrice: UITextField!
    
    @IBOutlet weak var buildStorage: UITextField!
    @IBOutlet weak var storagePrice: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Will display the save alert whent the save is clicked
    @IBAction func saveButton(sender: UIBarButtonItem) {
        saveAlert()
    }
    
    //Save build will get all the information from the text fields and put the into the current user custom object relation unless the field is empty then it will initalize it with an empty field
    func saveBuild(){
        PFUser.currentUser()!.fetchInBackground()
        
        let currentUser = PFUser.currentUser()
        
        
        // Create the post
        let computers = PFObject(className:"Computer")
        
        if (self.buildTitle.text == ""){
            computers["title"] = ""
        } else {
            computers["title"] = self.buildTitle.text
        }
        
        
        if (self.buildCase.text == ""){
            computers["case"] = ""
        } else {
            computers["case"] = self.buildCase.text
        }
        
        if (self.buildMB.text == ""){
            computers["motherboard"] = ""
        } else {
            computers["motherboard"] = self.buildMB.text
        }
        
        if (self.buildCPU.text == ""){
            computers["cpu"] = ""
        } else {
            computers["cpu"] = self.buildCPU.text
        }
        
        if (self.buildGPU.text == ""){
            computers["gpu"] = ""
        } else {
            computers["gpu"] = self.buildGPU.text
        }
        
        if (self.buildRAM.text == ""){
            computers["ram"] = ""
        } else {
            computers["ram"] = self.buildRAM.text
        }
        
        if (self.buildStorage.text == ""){
            computers["storage"] = ""
        } else {
            computers["storage"] = self.buildStorage.text
        }
    
        
        if (self.casePrice.text == ""){
            computers["casePrice"] = 0
        } else {
            computers["casePrice"] = Int(self.casePrice.text!)
        }
        
        if (self.mbPrice.text == ""){
            computers["motherboardPrice"] = 0
        } else {
            computers["motherboardPrice"] = Int(self.mbPrice.text!)
        }
        
        if (self.cpuPrice.text == ""){
            computers["cpuPrice"] = 0
        } else {
            computers["cpuPrice"] = Int(self.cpuPrice.text!)
        }
        
        if (self.gpuPrice.text == ""){
            computers["gpuPrice"] = 0
        } else {
            computers["gpuPrice"] = Int(self.gpuPrice.text!)
        }
        
        if (self.ramPrice.text == ""){
            computers["ramPrice"] = 0
        } else {
            computers["ramPrice"] = Int(self.ramPrice.text!)
        }
        
        if (self.storagePrice.text == ""){
            computers["storagePrice"] = 0
        } else {
            computers["storagePrice"] = Int(self.storagePrice.text!)
        }
        
        //Will set the object read and write to the user only
        computers.ACL = PFACL(user: currentUser!)
        
        currentUser!["computers"] = computers
        
        currentUser!.saveInBackgroundWithBlock({ (test, error) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    //Save alert will make sure that the user wants to add the new build
    func saveAlert(){
        let alertController = UIAlertController(title:  "Save new build", message:
            "Are you sure that you would like to save this as a new build?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default,handler: {(UIAlertAction) in
            self.saveBuild()
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
