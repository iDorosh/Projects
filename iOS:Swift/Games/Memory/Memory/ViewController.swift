//
//  ViewController.swift
//  Memory
//
//  Created by Ian Dorosh on 5/14/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import GameKit


class ViewController: UIViewController, GKGameCenterControllerDelegate, AVAudioPlayerDelegate,  MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var startGameBttn: UIButton!
    @IBOutlet var soundBttn: [UIButton]!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIView!
    @IBOutlet weak var gameCenterButtonMM: UIView!
    
    @IBOutlet weak var memoryTitle: UIImageView!
    
    @IBOutlet weak var goView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var goScore: UILabel!
    @IBOutlet weak var goHighScore: UILabel!
    
    var sound1Player : AVAudioPlayer!
    var sound2Player : AVAudioPlayer!
    var sound3Player : AVAudioPlayer!
    var sound4Player : AVAudioPlayer!
    
    var sound1 : AVAudioPlayer!
    var sound2 : AVAudioPlayer!
    var sound3 : AVAudioPlayer!
    var sound4 : AVAudioPlayer!
    
    var playlist = [Int]()
    var currentItem = 0
    var numberOfTaps = 0
    var readyForUser = false
    
    var level = 1
    var highscore = 0
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let cachedHighscore = userDefaults.valueForKey("Highscore") {
            highscore = Int(cachedHighscore as! Int)
        }
        
        let player = GKLocalPlayer.localPlayer()
        player.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
        }
        
        
        
        setUpAudioFiles()
        levelLabel.hidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func setUpAudioFiles(){
        let soundFilePath = NSBundle.mainBundle().pathForResource("1", ofType: "wav")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath!)
        
        let soundFilePath2 = NSBundle.mainBundle().pathForResource("2", ofType: "wav")
        let soundFileURL2 = NSURL(fileURLWithPath: soundFilePath2!)
        
        let soundFilePath3 = NSBundle.mainBundle().pathForResource("3", ofType: "wav")
        let soundFileURL3 = NSURL(fileURLWithPath: soundFilePath3!)
        
        let soundFilePath4 = NSBundle.mainBundle().pathForResource("4", ofType: "wav")
        let soundFileURL4 = NSURL(fileURLWithPath: soundFilePath4!)
        
        let soundFile1 = NSBundle.mainBundle().pathForResource("1", ofType: "wav")
        let soundURL1 = NSURL(fileURLWithPath: soundFile1!)
        
        let soundFile2 = NSBundle.mainBundle().pathForResource("2", ofType: "wav")
        let soundURL2 = NSURL(fileURLWithPath: soundFile2!)
        
        let soundFile3 = NSBundle.mainBundle().pathForResource("3", ofType: "wav")
        let soundURL3 = NSURL(fileURLWithPath: soundFile3!)
        
        let soundFile4 = NSBundle.mainBundle().pathForResource("4", ofType: "wav")
        let soundURL4 = NSURL(fileURLWithPath: soundFile4!)
        
        do {
            try sound1Player = AVAudioPlayer(contentsOfURL: soundFileURL)
            try sound2Player = AVAudioPlayer(contentsOfURL: soundFileURL2)
            try sound3Player = AVAudioPlayer(contentsOfURL: soundFileURL3)
            try sound4Player = AVAudioPlayer(contentsOfURL: soundFileURL4)
            
            try sound1 = AVAudioPlayer(contentsOfURL: soundURL1)
            try sound2 = AVAudioPlayer(contentsOfURL: soundURL2)
            try sound3 = AVAudioPlayer(contentsOfURL: soundURL3)
            try sound4 = AVAudioPlayer(contentsOfURL: soundURL4)
        } catch {
            print(error)
        }
        
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        
        sound1.delegate = self
        sound2.delegate = self
        sound3.delegate = self
        sound4.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
        
        sound1.numberOfLoops = 0
        sound2.numberOfLoops = 0
        sound3.numberOfLoops = 0
        sound4.numberOfLoops = 0
    }
    
    
    @IBAction func startGame(sender: UIButton) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            // Initialize the leaderboard for the current local player
            let gkLeaderboard = GKLeaderboard(players: [GKLocalPlayer.localPlayer()])
            gkLeaderboard.identifier = "mhs"
            gkLeaderboard.timeScope = GKLeaderboardTimeScope.AllTime
            
            // Load the scores
            gkLeaderboard.loadScoresWithCompletionHandler({ (scores, error) -> Void in
                
                // Get current score
                var currentScore: Int = 0
                if error == nil {
                    if (scores != nil){
                        if scores!.count > 0 {
                            currentScore = Int((scores![0] ).value)
                            let currentscoreGC : Int = currentScore
                            
                            if (currentscoreGC > self.highscore || self.highscore == 0){
                                self.userDefaults.setValue(currentscoreGC, forKey: "Highscore")
                                self.userDefaults.synchronize()
                                self.highscore = currentscoreGC
                            }
                        }
                    }
                }
                
            })
        }
        

        
        memoryTitle.hidden = true
        settingsButton.hidden = true
        gameCenterButtonMM.hidden = true
        levelLabel.hidden = false
        levelLabel.text = "Level 1"
        disableButtons()
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playlist.append(randomNumber)
        startGameBttn.hidden = true
        playNextItem()
    }
    
    func checkIfCorrect (buttonPressed: Int){
        if buttonPressed == playlist[numberOfTaps] {
            if numberOfTaps == playlist.count - 1 { // we have arrived at the last item of the playlist
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC))
                
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.nextRound()
                })
                
                return
            }
            
            numberOfTaps += 1
        }else{ // GAME OVER
            resetGame()
        }

    }
    
    func resetGame(){
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        playlist = []
        startGameBttn.hidden = false
        disableButtons()
        goView.hidden = false
        goScore.text = String(level)
        
        if level > highscore{
            userDefaults.setInteger(level, forKey: "Highscore")
            highscore = userDefaults.objectForKey("Highscore") as! Int
            userDefaults.synchronize()
            
            if let highscore = userDefaults.valueForKey("highscore") {
                self.highscore = Int(highscore as! Int)
            }

        }
        
        goHighScore.text = "\(highscore)"
        
        let scoreReporter = GKScore(leaderboardIdentifier: "mhs")
        scoreReporter.value = Int64((highscore))
        let scoreArray: [GKScore] = [scoreReporter]
        GKScore.reportScores(scoreArray, withCompletionHandler: { (NSError) -> Void in
        })
        
        levelLabel.hidden = true
        level = 1
    }
    
    func nextRound(){
        level += 1
        levelLabel.text = "Level \(level)"
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        disableButtons()
        
        
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playlist.append(randomNumber)
        
        playNextItem()
    }
    
    
    
    @IBAction func soundButtonPressed(sender: UIButton) {
        
        if readyForUser {
            let button = sender 
            
            switch button.tag {
            case 1:
                if sound1Player.playing {
                    sound1.play()
                    checkIfCorrect(1)
                } else if sound1.playing {
                    sound1Player.play()
                    checkIfCorrect(1)
                } else {
                    sound1Player.play()
                    checkIfCorrect(1)
                }
                break
            case 2:
                if sound2Player.playing {
                    sound2.play()
                    checkIfCorrect(2)
                } else if sound2.playing {
                    sound2Player.play()
                    checkIfCorrect(2)
                } else {
                    sound2Player.play()
                    checkIfCorrect(2)
                }
                break
            case 3:
                if sound3Player.playing {
                    sound3.play()
                    checkIfCorrect(3)
                } else if sound3.playing {
                    sound3Player.play()
                    checkIfCorrect(3)
                } else {
                    sound3Player.play()
                    checkIfCorrect(3)
                }
                break
            case 4:
                if sound4Player.playing {
                    sound4.play()
                    checkIfCorrect(4)
                } else if sound4.playing{
                    sound4Player.play()
                    checkIfCorrect(4)
                } else {
                    sound4Player.play()
                    checkIfCorrect(4)
                }
                break
            default:
                break
            }
            
        }
        

        
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if currentItem <= playlist.count - 1 {
            playNextItem()
        }else{
            readyForUser = true
            resetButtonHighlights()
            enableButtons()
        }
    }
    
    func playNextItem(){
        let selectedItem = playlist[currentItem]
        
        switch selectedItem {
        case 1:
            highlightButtonWithTag(1)
            sound1Player.play()
            break
        case 2:
            highlightButtonWithTag(2)
            sound2Player.play()
            break
        case 3:
            highlightButtonWithTag(3)
            sound3Player.play()
            break
        case 4:
            highlightButtonWithTag(4)
            sound4Player.play()
            break
        default:
            break;
        }
        
        currentItem += 1

    }
    
    func highlightButtonWithTag(tag: Int){
        switch tag {
        case 1:
            resetButtonHighlights()
            soundBttn[tag - 1].setImage(UIImage(named:"redPressed"), forState: .Normal)
        case 2:
            resetButtonHighlights()
            soundBttn[tag - 1].setImage(UIImage(named:"yellowPressed"), forState: .Normal)
        case 3:
            resetButtonHighlights()
            soundBttn[tag - 1].setImage(UIImage(named:"bluePressed"), forState: .Normal)
        case 4:
            resetButtonHighlights()
            soundBttn[tag - 1].setImage(UIImage(named:"greenPressed"), forState: .Normal)
        default:
            break
        }

    }
    
    func resetButtonHighlights (){
        soundBttn[0].setImage(UIImage(named: "red"), forState: .Normal)
        soundBttn[1].setImage(UIImage(named: "yellow"), forState: .Normal)
        soundBttn[2].setImage(UIImage(named: "blue"), forState: .Normal)
        soundBttn[3].setImage(UIImage(named: "green"), forState: .Normal)
    }
    
    func disableButtons(){
        for button in soundBttn {
            button.userInteractionEnabled = false
        }
    }
    
    func enableButtons(){
        for button in soundBttn {
            button.userInteractionEnabled = true
        }
    }
    
    
    @IBAction func playAgain(sender: UIButton) {
        goView.hidden = true
        goScore.text = ""
        goHighScore.text = ""
        memoryTitle.hidden = false
        settingsButton.hidden = false
        gameCenterButtonMM.hidden = false
    }
    
    
    @IBAction func soundAction(sender: UIButton) {
    }
    
    @IBAction func twitterAction(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/VulkanMN")!)
    }
    
    
    @IBAction func contactUsAction(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)

        }
    }
    
    @IBAction func doneAction(sender: UIButton) {
        settingsView.hidden = true
    }
 
    
    
    
    @IBAction func settingsButton(sender: UIButton) {
        settingsView.hidden = false
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func openGameCenter(sender: UIButton) {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        var versionString : String = ""
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            versionString = version
        }
        
        mailComposerVC.setToRecipients(["vulkancontactus@gmail.com"])
        mailComposerVC.setSubject("Memory, Version: " + versionString)
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

