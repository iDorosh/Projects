//
//  StartScreenViewController.swift
//  Simple Addition
//
//  Created by Ian Dorosh on 2/9/16.
//  Copyright © 2016 Vulcan Studio. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GameKit
import StoreKit
import AVFoundation
import MessageUI



class StartScreenViewController: UIViewController, GKGameCenterControllerDelegate, IAPManagerDelegate, MFMailComposeViewControllerDelegate{
    var product: SKProduct!
    var purchased : Bool = false
    var soundMuted : Bool = false
    var gameCenterOn : Bool = true
    var alertController1 : UIAlertController = UIAlertController()
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var restoreHighScoreButton: UIButton!
    @IBOutlet weak var restore: UIButton!
    
    @IBOutlet weak var doneBttn: UIButton!
    
    @IBAction func restoreAction(sender: UIButton)
    {
        
        if (Network.isConnectedToNetwork()){
            activitySpinner()
        IAPManager.sharedInstance.restorePurchases()
        } else {
            noNetwork()
        }
    }
    
    func activitySpinner(){
        alertController1 = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.Alert)
        
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        spinnerIndicator.center = CGPointMake(135.0, 65.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        
        alertController1.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        
        alertController1.view.addSubview(spinnerIndicator)
        self.presentViewController(alertController1, animated: false, completion: nil)
    }
    
    func notPublishedYet(){
        alertController1.dismissViewControllerAnimated(true, completion: nil)
        let alertController = UIAlertController(title: "Not Published Yet", message:
            "Can't verify Apple Reciept because the app is not published yet.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func gameCenterBttnClick(sender: UIButton) {
        if (Network.isConnectedToNetwork()){
            if (gameCenterOn){
                
                let refreshAlert = UIAlertController(title: "Game Center", message: "Turning off Game Center will prevent you from restoring your score on other devices\nContinue?", preferredStyle: UIAlertControllerStyle.Alert)
                
                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                            let refreshAlert = UIAlertController(title: "Reset Highscore", message: "Would you like to reset your local high score?", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        self.gameCenterOn = false
                        self.restoreHighScoreButton.setTitle("Game Center Off", forState: .Normal)
                        
                        let image = UIImage(named: "gcOL.png") as UIImage!
                        self.gcbttn.setImage(image, forState: .Normal)
                        
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "gcOn")
                            
                            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                                NSUserDefaults.standardUserDefaults().setDouble(9999.99, forKey: "highscore")
                            }))
                            
                            refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
                                
                            }))
                            
                            self.presentViewController(refreshAlert, animated: true, completion: nil)

                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
            } else {
                if (Network.isConnectedToNetwork()){
                    gameCenterOn = true
                    let image = UIImage(named: "gc.png") as UIImage!
                    self.gcbttn.setImage(image, forState: .Normal)
                    startGC()
                    restoreHighScoreButton.setTitle("Game Center On", forState: .Normal)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "gcOn")
                    let alertController = UIAlertController(title: "Game Center On", message:
                        "Your scores will be updated if needed", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else {
            noNetwork()
        }
    }
    
    
    
    @IBOutlet weak var purchaseAdsButton: UIButton!
    
    @IBAction func doneButton(sender: UIButton) {
        settingsView.hidden = true
    }
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBAction func Settings(sender: UIButton) {
        settingsView.hidden = false
    }
    
    @IBOutlet weak var twitterBttn: UIButton!
    @IBAction func twitterAction(sender: UIButton) {
        if (Network.isConnectedToNetwork()){
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/VulkanMN")!)
        } else {
            noNetwork()
        }
    }
    
    @IBOutlet weak var contactUsBttn: UIButton!
    
    @IBAction func contactAction(sender: UIButton) {
        if (Network.isConnectedToNetwork()){
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else {
            noNetwork()
        }
    }
    
    
    

    @IBOutlet weak var playbttn: UIButton!

    @IBOutlet weak var gcbttn: UIButton!
    
    @IBAction func sound(sender: UIButton) {
        soundO.hidden = true
        soundMute0.hidden = false
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(true, forKey: "muted")
        userDefaults.synchronize()
        if let mute = userDefaults.valueForKey("muted") {
            self.soundMuted = Bool(mute as! Bool)
        }
    }
    
    @IBOutlet weak var soundO: UIButton!
    
    @IBAction func soundMute(sender: UIButton) {
        soundO.hidden = false
        soundMute0.hidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(false, forKey: "muted")
        userDefaults.synchronize()
        if let mute = userDefaults.valueForKey("muted") {
            self.soundMuted = Bool(mute as! Bool)
        }
    }
    
    @IBOutlet weak var soundMute0: UIButton!
    
    
    @IBAction func playing(sender: UIButton) {
        if (!soundMuted){
        AudioServicesPlaySystemSound(self.clicking)
        }
    }
    
    var clicking: SystemSoundID = 0
    
    @IBAction func iap(sender: UIButton) {
        if gameCenterOn{
            if (!soundMuted){
            AudioServicesPlaySystemSound(self.clicking)
            }
        
            if (Network.isConnectedToNetwork()){
                let vc = self.view?.window?.rootViewController
                let gc = GKGameCenterViewController()
                gc.gameCenterDelegate = self
                vc?.presentViewController(gc, animated: true, completion: nil)
            } else {
                noNetwork()
            }
        } else {
            let alertController = UIAlertController(title: "Not Logged In", message:
                "Please turn Game Center on in settings", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func removeAds(sender: UIButton)
    {
        if (Network.isConnectedToNetwork()){
            activitySpinner()
        IAPManager.sharedInstance.createPaymentRequestForProduct(IAPManager.sharedInstance.products.objectAtIndex(0) as! SKProduct)
        } else {
            noNetwork()
        }
    }
    
    
    
    //Will bring the user back to this screen once they save the new build
    @IBAction func backToMain(segue: UIStoryboardSegue)
    {
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBOutlet weak var settingsBG: UIView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
   
    
    override func viewDidLoad() {
        
        
        IAPManager.sharedInstance.delegate = self
      
        
        
        let clickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("zipclick", ofType: "mp3")!)
        if (!soundMuted){
        AudioServicesCreateSystemSoundID(clickSound, &self.clicking)
        }
        
        userDefaults()
        
        if (gameCenterOn){
            let image = UIImage(named: "gc.png") as UIImage!
            self.gcbttn.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "gcOL.png") as UIImage!
            self.gcbttn.setImage(image, forState: .Normal)
        }
        if (soundMuted){
            soundO.hidden = true
            soundMute0.hidden = false
        } else {
            soundO.hidden = false
            soundMute0.hidden = true
        }
        if (!purchased){
            loadBanner()
        } else {
            self.restore.hidden = true
            self.purchaseAdsButton.hidden = true
            
            
            let bounds: CGRect = UIScreen.mainScreen().bounds
            let screenHeight: NSNumber = bounds.size.height
            
            if (screenHeight == 480){
               
                restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 125)
                
                twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 125)
                
                
                contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 125)
                
                doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
                
                
                settingsBG.frame.size.height = settingsBG.frame.size.height - 120
                
                
            settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 60)
            
            settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 60)
            } else if (screenHeight == 568){
                restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 155)
                
                twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 155)
                
                
                contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 155)
                
                doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
                
                
                settingsBG.frame.size.height = settingsBG.frame.size.height - 150
                
                
                settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 80)
                
                settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 60)
                
            } else {
                
                restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 155)
                
                twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 155)
                
                
                contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 155)
                
                doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
                
                
                settingsBG.frame.size.height = settingsBG.frame.size.height - 150
                
                settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 100)
                
                settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 100)
            }

        }
        
        if (gameCenterOn){
            startGC()
            self.restoreHighScoreButton.setTitle("Game Center On", forState: .Normal)
        } else {
            self.restoreHighScoreButton.setTitle("Game Center Off", forState: .Normal)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func failed() {
        alertController1.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    func loadBanner(){
        Chartboost.showInterstitial(CBLocationHomeScreen)
    }
    

    
    //Starts Game Center with the local player
    func startGC(){
        let player = GKLocalPlayer.localPlayer()
        player.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
        }
    }
    
    func userDefaults(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        if let iad = userDefaults.valueForKey("iad") {
            self.purchased = Bool(iad as! Bool)
        }
        
        if let mute = userDefaults.valueForKey("muted") {
            self.soundMuted = Bool(mute as! Bool)
        }
        
        if let gcOn = userDefaults.valueForKey("gcOn") {
            self.gameCenterOn = Bool(gcOn as! Bool)
        }
    }

    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func startGame(){
        performSegueWithIdentifier("StartGame", sender: self)
    }
    
    func managerDidRestorePurchases() {
        self.restore.hidden = true
        self.purchaseAdsButton.hidden = true
        
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let screenHeight: NSNumber = bounds.size.height
        
        if (screenHeight == 480){
            restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 125)
            
            twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 125)
            
            
            contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 125)
            
            doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
            
            
            settingsBG.frame.size.height = settingsBG.frame.size.height - 120
            
            
            settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 60)
            
            settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 60)
        } else if (screenHeight == 568){
            restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 155)
            
            twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 155)
            
            
            contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 155)
            
            doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
            
            
            settingsBG.frame.size.height = settingsBG.frame.size.height - 150
            
            
            settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 80)
            
            settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 60)
            
        } else {
            restoreHighScoreButton.frame.origin = CGPoint(x: restoreHighScoreButton.frame.origin.x, y: restoreHighScoreButton.frame.origin.y - 155)
            
            twitterBttn.frame.origin = CGPoint(x: twitterBttn.frame.origin.x, y: twitterBttn.frame.origin.y - 155)
            
            
            contactUsBttn.frame.origin = CGPoint(x: contactUsBttn.frame.origin.x, y: contactUsBttn.frame.origin.y - 155)
            
            doneBttn.frame.origin = CGPoint(x: doneBttn.frame.origin.x, y: doneBttn.frame.origin.y - 50)
            
            
            settingsBG.frame.size.height = settingsBG.frame.size.height - 150
            
            settingsBG.frame.origin = CGPoint(x: settingsBG.frame.origin.x, y: settingsBG.frame.origin.y + 100)
            
            settingsLabel.frame.origin = CGPoint(x: settingsLabel.frame.origin.x, y: settingsLabel.frame.origin.y + 100)
        }
            alertController1.dismissViewControllerAnimated(true, completion: nil)
        
            let alertController = UIAlertController(title: "In-App Purchase", message:
                "Simple Addition is now Ad Free!\nThank You!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            purchased = true
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func noPurchases() {
        let alertController = UIAlertController(title: "In-App Purchase", message:
            "Sorry\nNo Purchases found", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func noNetwork(){
        let alertController = UIAlertController(title: "Error", message:
            "No Network detected\nPlease connect to continue", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        var versionString : String = ""
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                versionString = version
        }
        
        mailComposerVC.setToRecipients(["vulkancontactus@gmail.com"])
        mailComposerVC.setSubject("Simple Addition Support, Version: " + versionString)
        mailComposerVC.setMessageBody("Type your message Here", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
