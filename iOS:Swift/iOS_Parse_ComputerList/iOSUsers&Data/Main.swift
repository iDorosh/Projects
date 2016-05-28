//
//  Main.swift
//  iOSUsers&Data
//
//  Created by Ian Dorosh on 1/9/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import UIKit
import Parse

class Main: UIViewController {
    
    //begining of the google search url
    var urlString : String = "http://google.com/#q="
    
    //Will hold all the prices of the components
    var casePrice : Int = Int()
    var mbPrice : Int = Int()
    var cpuPrice : Int = Int()
    var gpuPrice : Int = Int()
    var ramPrice : Int = Int()
    var storagePrice : Int = Int()
    
    
    //References fot the labels and also for the buttons
    @IBOutlet weak var buildTitle: UILabel!
    
    
    @IBOutlet weak var helloName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var caseButtonBG: UIButton!
    @IBOutlet weak var pcCaseLabel: UILabel!
    
    @IBOutlet weak var motherboardButtonBG: UIButton!
    @IBOutlet weak var pcMotherboardLabel: UILabel!
    
    @IBOutlet weak var cpuButtonBG: UIButton!
    @IBOutlet weak var pcCPULabel: UILabel!
    
    @IBOutlet weak var gpuButtonBG: UIButton!
    @IBOutlet weak var pcGPULabel: UILabel!
    
    
    @IBOutlet weak var ramButtonBG: UIButton!
    @IBOutlet weak var pcRAMLabel: UILabel!
    
    @IBOutlet weak var storageButtonBG: UIButton!
    @IBOutlet weak var pcStorageLabel: UILabel!
    
    
    @IBOutlet weak var showView: UIView!
    
    @IBOutlet weak var helloView: UIView!
    
    
    @IBOutlet weak var caseSearch: UIButton!
    @IBOutlet weak var mbSearch: UIButton!
    @IBOutlet weak var cpuSearch: UIButton!
    @IBOutlet weak var gpuSearch: UIButton!
    @IBOutlet weak var ramSearch: UIButton!
    @IBOutlet weak var storageSearch: UIButton!
    
    //Avtions that will determing if the user has selected a specific component and then will search for it
    @IBAction func caseButton(sender: UIButton) {
        if (pcCaseLabel.text == "Not Selected"){
            notSelected("Case")
        } else {
            goToURL(urlString+removeSpaces(pcCaseLabel.text!))
        }
    }
    
    @IBAction func motherboardButton(sender: UIButton) {
        if (pcMotherboardLabel.text == "Not Selected"){
            notSelected("Motherboard")
        } else {
        goToURL(urlString+removeSpaces(pcMotherboardLabel.text!))
        }
    }
    
    @IBAction func cpuButton(sender: UIButton) {
        if (pcCPULabel.text == "Not Selected"){
            notSelected("CPU")
        } else {
            goToURL(urlString+removeSpaces(pcCPULabel.text!))
        }
    
    }
    
    @IBAction func gpuButton(sender: UIButton) {
        if (pcGPULabel.text == "Not Selected"){
            notSelected("GPU")
        } else {
        goToURL(urlString+removeSpaces(pcGPULabel.text!))
        }
    }
    
    @IBAction func ramButton(sender: UIButton) {
        if (pcRAMLabel.text == "Not Selected"){
            notSelected("RAM")
        } else {
        goToURL(urlString+removeSpaces(pcRAMLabel.text!))
        }
    }
    
    @IBAction func storageButton(sender: UIButton) {
        if (pcStorageLabel.text == "Not Selected"){
            notSelected("Storage")
        } else {
            goToURL(urlString+removeSpaces(pcStorageLabel.text!))
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDisplay", name: UIApplicationWillEnterForegroundNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        updateDisplay()
    
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func deleteObject(sender: UIBarButtonItem) {
        //Will show and alert to verify that the user wishes to delete the object
        deleteCurrentBuild()
    }
    
    
    

    //Will bring the user back to this screen once they save the new build
    @IBAction func backToMain(segue: UIStoryboardSegue)
    {
    }
    
    func updateDisplay(){
        
        //Will fetch the current user to refresh the cached data and then will update the display
        PFUser.currentUser()?.fetchInBackground()
        
        let currentUser = PFUser.currentUser()
    
        //Will place all the correct text into the corrisponding component labels and also sets the button background to grey or colored based on if the user has selected a component
        if (currentUser?.valueForKey("computers") != nil){
            let computers : PFObject = currentUser?.valueForKey("computers") as! PFObject
            
            computers.fetchInBackgroundWithBlock(){
                (computer: PFObject?, error: NSError?) -> Void in
                if error == nil && computer != nil {
                    self.showView.hidden = false
                    self.helloView.hidden = true
                    
                    if (computer!["case"] as? String == "") {
                        self.pcCaseLabel.text = ("Not Selected");
                        self.caseSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.caseSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcCaseLabel.text = computer!["case"] as? String
                    }
                    
                    if (computer!["motherboard"] as? String == "") {
                        self.pcMotherboardLabel.text = ("Not Selected");
                        self.mbSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.mbSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcMotherboardLabel.text = computer!["motherboard"] as? String
                    }
                    
                    if (computer!["cpu"] as? String == "") {
                        self.pcCPULabel.text = ("Not Selected");
                        self.cpuSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.cpuSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcCPULabel.text = computer!["cpu"] as? String
                    }
                    
                    if (computer!["gpu"] as? String == "") {
                        self.pcGPULabel.text = ("Not Selected");
                        self.gpuSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.gpuSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcGPULabel.text = computer!["gpu"] as? String
                    }
                    
                    if (computer!["ram"] as? String == "") {
                        self.pcRAMLabel.text = ("Not Selected");
                        self.ramSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.ramSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcRAMLabel.text = computer!["ram"] as? String
                    }
                    
                    if (computer!["storage"] as? String == "") {
                        self.pcStorageLabel.text = ("Not Selected");
                        self.storageSearch.setBackgroundImage(UIImage(named: "greyedout.png"), forState: .Normal)
                    } else {
                        self.storageSearch.setBackgroundImage(UIImage(named: "buttonbackground.png"), forState: .Normal)
                        self.pcStorageLabel.text = computer!["storage"] as? String
                    }
                    
                    if (computer!["title"] as? String == "") {
                        self.buildTitle.text = ("No Title");
                    } else {
                        self.buildTitle.text = computer!["title"] as? String
                    }
                    
                    self.casePrice = (computer!["casePrice"] as? Int)!
                    self.mbPrice = (computer!["motherboardPrice"] as? Int)!
                    self.cpuPrice = (computer!["cpuPrice"] as? Int)!
                    self.gpuPrice = (computer!["gpuPrice"] as? Int)!
                    self.ramPrice = (computer!["ramPrice"] as? Int)!
                    self.storagePrice = (computer!["storagePrice"] as? Int)!
                    
                    let newnumber:Int = self.casePrice + self.mbPrice + self.cpuPrice + self.gpuPrice + self.ramPrice + self.storagePrice
                    
                    self.price.text = "$" + String(newnumber)
                    
                } else {
                    //Will set the hello text based on the users name and also hide or show the correct views
                    self.helloName.text = "Hello " + ((currentUser?.valueForKey("name"))! as! String);
                    self.showView.hidden = true
                    self.helloView.hidden = false
                    
                }
            }

        } else {
            //Will set the hello text based on the users name and also hide or show the correct views
            self.showView.hidden = true
            self.helloView.hidden = false
            self.helloName.text = "Hello " + ((currentUser?.valueForKey("name"))! as! String);
        }
        

        
        
        
            
        
        
        
    }

    @IBAction func logout(sender: UIBarButtonItem)
    {
        //Will verify that the user wants to logout
        showAlert("Logout", message: "Are you sure that your want to logout?", dismiss: "Logout")
    }
    
    //Show the logout alert
    func showAlert(title : String, message : String, dismiss : String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: dismiss, style: UIAlertActionStyle.Default,handler: {(UIAlertAction) in
            self.logout()
        
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Will show that nothing is selected when the user hits a greyed out search button
    func notSelected(component : String){
            let alertController = UIAlertController(title: "Not Selected", message:
                "The "+component+" hasn't been selected for this build", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    //Will verify that the user wants to delete the current build
    func deleteCurrentBuild(){
        let alertController = UIAlertController(title: "Delete Build", message:
            "Are your sure that you want to delete the current build", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default,handler: {(UIAlertAction) in
            let currentUser = PFUser.currentUser()
            
            let computers : PFObject = currentUser!["computers"] as! PFObject
            
            computers.deleteInBackground()
            
            self.updateDisplay()
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Will logout the current user
    func logout(){
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.navigationController?.popToRootViewControllerAnimated(true)
            PFUser.logOut()
            _ = PFUser.currentUser() // this will now be nil
        } else {
            // Show the signup or login screen
        }
    }
    
    //Will do a google search for a component and replaces all the spaces with a plus to work with the google search url
    func goToURL(urlString : String){
        var url : NSURL;
        url = NSURL(string: urlString)!;
        UIApplication.sharedApplication().openURL(url)
    }
    
    func  removeSpaces(searchText : String) -> String
    {
    
        return searchText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
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
