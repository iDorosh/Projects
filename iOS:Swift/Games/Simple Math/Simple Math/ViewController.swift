//
//  ViewController.swift
//  Simple Addition
//
//  Created by Ian Dorosh on 2/8/16.
//  Copyright © 2016 Vulcan Studio. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation
import SpriteKit
import GameKit


class ViewController: UIViewController{
    
    //GameCenterAchievemnets
    var gameCenterAchievements = [String : GKAchievement]()
    var generateEq = true
    var soundMuted : Bool = false
    var totalTime : Double = 0.0
    var pausedTime : Double = 0.0
    var firstEq = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,4,1,11,20]
    var secondEq : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,5,2,8,20]
    var firstEqShuffled : [Int] = []
    var secondEqShuffled : [Int] = []
    var purchased : Bool = false
    var recievedMove : NSDictionary = NSDictionary()
    var recievedChange : NSDictionary = NSDictionary()
    var firstNumber : Int = Int()
    var secondNumber : Int = Int()
    var highscoreDouble : Double = Double()
    var answerString : String = String()
    var eqautionString : String = String()
    var eqautionAnswer : Int = Int()
    var duration : Timer!
    var counter : Int = 0
    var click : AVAudioPlayer?
    var clicking: SystemSoundID = 0
    var points: SystemSoundID = 1
    var wrong: SystemSoundID = 2
    var winner: SystemSoundID = 3
    var lost: SystemSoundID = 4
    var fail: SystemSoundID = 5
    var first : Bool = true
    var threeSeconds : Int = 3
    var countdownTimer : NSTimer?
    var gameCenterOn : Bool = true
    
    @IBOutlet var fields: [TTTImageView]!
    
    @IBOutlet weak var flawless: UILabel!
    
    @IBOutlet weak var pauseBttn: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var pausedLabel: UIImageView!
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var quitButton: UIButton!

    @IBOutlet weak var RESULT: UILabel!
    
    @IBOutlet weak var countdownView: UIView!

    @IBOutlet weak var showScore: UIView!

    @IBOutlet weak var currentScore: UILabel!
    
    @IBOutlet weak var highscore: UILabel!
   
    @IBOutlet weak var eqaution: UILabel!
    
    @IBOutlet weak var countDown: UIImageView!
    
    var board : [GKLeaderboard] = [GKLeaderboard()]
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.progress = 0.0
        
        reset()
        userDefaults()
        if (gameCenterOn){
        getScoreAchievement()
        }
        
        firstEq.shuffle()
        secondEq.shuffle()
        updateCounter()
        setupField()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.Close), name: "popToRoot", object: nil)
        
        let clickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("zipclick", ofType: "mp3")!)
        
        let pointSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("point", ofType: "wav")!)
        
        let wrongSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrong", ofType: "mp3")!)
        
        let winnerSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("winner", ofType: "mp3")!)
        
        let lostSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lost", ofType: "mp3")!)
        
        let failSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fail", ofType: "mp3")!)
        
        
        AudioServicesCreateSystemSoundID(clickSound, &self.clicking)
        AudioServicesCreateSystemSoundID(pointSound, &self.points)
        AudioServicesCreateSystemSoundID(wrongSound, &self.wrong)
        AudioServicesCreateSystemSoundID(winnerSound, &self.winner)
        AudioServicesCreateSystemSoundID(lostSound, &self.lost)
        AudioServicesCreateSystemSoundID(failSound, &self.fail)
        
        if (gameCenterOn){
            if GKLocalPlayer.localPlayer().authenticated {
                
                // Initialize the leaderboard for the current local player
                let gkLeaderboard = GKLeaderboard(players: [GKLocalPlayer.localPlayer()])
                gkLeaderboard.identifier = "salb"
                gkLeaderboard.timeScope = GKLeaderboardTimeScope.AllTime
                
                // Load the scores
                gkLeaderboard.loadScoresWithCompletionHandler({ (scores, error) -> Void in
                    
                    // Get current score
                    var currentScore: Double = 0
                    if error == nil {
                        if (scores != nil){
                            if scores!.count > 0 {
                                currentScore = Double((scores![0] ).value)
                                let currentscoreGC : Double = Double(currentScore/100)
                                let userDefaults = NSUserDefaults.standardUserDefaults()
                                print(currentscoreGC)
                                print(self.highscoreDouble)
                                if (currentscoreGC < self.highscoreDouble || self.highscoreDouble == 0.0){
                                userDefaults.setValue(currentscoreGC, forKey: "highscore")
                                userDefaults.synchronize()
                                self.highscoreDouble = currentscoreGC
                                }
                            }
                        }
                    }
                    
                })
            }
        }

        
    }
    
    //Will get all the current achievments to place them into an dictionary
    func getScoreAchievement(){
        GKAchievement.loadAchievementsWithCompletionHandler({ (allAchievements, error) -> Void in
            if error != nil{
            } else {
                if allAchievements != nil {
                    for theAchievement in allAchievements! {
                        if let singleAchievement: GKAchievement = theAchievement {
                            self.gameCenterAchievements[singleAchievement.identifier!] = singleAchievement
                        }
                    }
                }
            }
        })
    }
    
    
    func reset(){
        firstEq = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,4,1,11,20]
        secondEq = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,5,2,8,20]
        
        firstEqShuffled  = []
        secondEqShuffled = []
        
        recievedMove = NSDictionary()
        recievedChange = NSDictionary()
        
        firstNumber = Int()
        secondNumber = Int()
        
        highscoreDouble = Double()
        
        answerString = String()
        eqautionString = String()
        
        eqautionAnswer = Int()
        
        duration = Timer()
        
        counter = 0
        
        //Click
        click = AVAudioPlayer()
        
        clicking = 0
        points = 1
        wrong = 2
        winner = 3
        lost = 4
        
        first  = true
        
        threeSeconds  = 3
        
        countdownTimer = NSTimer()
    }
        
    func userDefaults(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        if let cachedHighscore = userDefaults.valueForKey("highscore") {
            self.highscoreDouble = Double(cachedHighscore as! NSNumber)
        }
        
        if let iad = userDefaults.valueForKey("iad") {
            self.purchased = Bool(iad as! Bool)
        }
        
        if let adCounter1 = userDefaults.valueForKey("adCounter") {
            self.adCounter = Int(adCounter1 as! Int)
        }
        
        if let mute = userDefaults.valueForKey("muted") {
            self.soundMuted = Bool(mute as! Bool)
        }
        
        if let gcOn = userDefaults.valueForKey("gcOn") {
            self.gameCenterOn = Bool(gcOn as! Bool)
        }
        
    }
    
    func updateCounter(){
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.0), target: self, selector: #selector(ViewController.updateImage), userInfo: nil, repeats: true)
    }
    
    func updateImage(){
        if (generateEq){
            if (threeSeconds != 1){
                threeSeconds -= 1
                countDown.image = UIImage(named: String(threeSeconds))
            } else {
                countdownView.hidden = true
                countdownTimer?.invalidate()
                countdownTimer = nil
                generateEquation()
                duration = Timer()
                generateEq = true
                
            }
        } else {
            if (threeSeconds != 1){
                threeSeconds -= 1
                countDown.image = UIImage(named: String(threeSeconds))
            } else {
                countdownView.hidden = true
                countdownTimer?.invalidate()
                countdownTimer = nil
                duration = Timer()
                generateEq = true
                
            }
        }
    }
    
    func setupField(){
        for index in 0 ... fields.count - 1{
            let getstureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.fieldTapped(_:)))
            getstureRecognizer.numberOfTapsRequired = 1
            
            fields[index].addGestureRecognizer(getstureRecognizer)
        }
    }

    func playSound(){
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.points)
        }
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.4), target: self, selector: #selector(ViewController.winnerDone), userInfo: nil, repeats: false)
    }
    
    var adCounter : Int = 0
    
    func winnerDone(){
        adCounter += 1
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(adCounter, forKey: "adCounter")
        userDefaults.synchronize()
        
        if let adCounter1 = userDefaults.valueForKey("adCounter") {
            self.adCounter = Int(adCounter1 as! Int)
        }
        
        if(!purchased) {
            Chartboost.showInterstitial(CBLocationGameOver)
        }
        
        eqaution.text = ""
        
        totalTime = duration.stop()
       
            totalTime = totalTime + mistake + pausedTime
        
            currentScore.text = "\(totalTime) secs"
        
        
            showScore.hidden = false
        
        if (totalTime < highscoreDouble || highscoreDouble < 1){
     
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(totalTime, forKey: "highscore")
        userDefaults.synchronize()
        
        if let highscore = userDefaults.valueForKey("highscore") {
            self.highscoreDouble = Double(highscore as! NSNumber)
        }
            
        }
        
        if (highscoreDouble < 60.0){
             reportAchievment("under2", percent: 100.0)
        }
        
        if (highscoreDouble < 40.0){
            reportAchievment("under1", percent: 100.0)
        }
        
        if (highscoreDouble < 30.0){
            reportAchievment("underHalf", percent: 100.0)
        }
        
        if (mistake == 0.0){
            reportAchievment("noMistakes", percent: 100.0)
        }
        
        if(totalTime > highscoreDouble){
            currentScore.textColor = UIColor.redColor()
            if (!soundMuted){
                AudioServicesPlaySystemSound(self.fail)
            }
            
        } else {
            currentScore.textColor = UIColor.greenColor()
            if (!soundMuted){
                AudioServicesPlaySystemSound(self.winner)
            }
        }
        
        highscore.text = ("\(highscoreDouble) secs")
        
        if (mistake == 0){
            flawless.text = "Perfect Game!"
        } else {
            flawless.text = (String(Int(mistake/3)) + " Mistakes   +" + String(Int(mistake)) + " seconds" )
        }
        
        //Save Highscore will push the current highscore to game center after verifiying that the user is logged in.
        
        let scoreReporter = GKScore(leaderboardIdentifier: "salb")
        scoreReporter.value = Int64((highscoreDouble*100))
        let scoreArray: [GKScore] = [scoreReporter]
        GKScore.reportScores(scoreArray, withCompletionHandler: { (NSError) -> Void in
        })
    }
    
    var mistake : Double = 0

    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func wrongAnswer() {
        mistake = mistake + 3.0
        
        eqaution.textColor = UIColor.redColor()
        
        delay(0.5) {
            self.eqaution.textColor = UIColor.whiteColor()
        }
        
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.wrong)
        }
        answerString = String()
        eqautionString = (String(firstEq[counter]) + "+" + String(secondEq[counter]) + " = ?")
        eqaution.text = eqautionString
    }

    func generateEquation(){
        
        progress.progress = progress.progress + 0.05
        if (!first){
            if (!soundMuted){
        AudioServicesPlaySystemSound(self.points)
            }
        }
        answerString = String()
        counter += 1
        
        eqautionAnswer = firstEq[counter]+secondEq[counter]
       
        
        eqautionString = (String(firstEq[counter]) + "+" + String(secondEq[counter]) + " = ?")
        
        eqaution.text = eqautionString
    
        
        first = false
    }
    
    //Will report the achievement to game center
    func reportAchievment(id : String, percent : Double){
        let achievement = GKAchievement(identifier: id)
        achievement.percentComplete = percent
        achievement.showsCompletionBanner = true
        
        let achievementArray : [GKAchievement] = [achievement]
        
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            error -> Void in
            
            if (error != nil){
                print(error)
            } else {
                
            }
        })
        
    }

    func fieldTapped (recognizer: UITapGestureRecognizer){
        
        changeColor()
        
        
        if (answerString.characters.count <= 1){
            
            
            let tappedField = recognizer.view as! TTTImageView
            
            if (!soundMuted){
                AudioServicesPlaySystemSound(self.clicking)
            }
            
            
            if (tappedField.tag == 0){
                answerString = answerString + "1"
                
            } else if (tappedField.tag == 1){
                answerString = answerString + "2"
                
            } else if (tappedField.tag == 2){
                answerString = answerString + "3"
                
            } else if (tappedField.tag == 3) {
                answerString = answerString + "4"
                
            } else if (tappedField.tag == 4) {
                answerString = answerString + "5"
                
            } else if (tappedField.tag == 5) {
                answerString = answerString + "6"
                
            } else if (tappedField.tag == 6) {
                answerString = answerString + "7"
                
            } else if (tappedField.tag == 7) {
                answerString = answerString + "8"
                
            } else if (tappedField.tag == 8) {
                answerString = answerString + "9"
                
            } else if (tappedField.tag == 9) {
                answerString = answerString + "0"
                
            }
            
            
            
            eqautionString = (String(firstEq[counter]) + "+" + String(secondEq[counter]) + " = " + answerString)
            eqaution.text = eqautionString
            
            
            if (String(eqautionAnswer).characters.count == 1 && answerString.characters.count == 1 && answerString != String(eqautionAnswer)) {
                NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.4), target: self, selector: #selector(ViewController.wrongAnswer), userInfo: nil, repeats: false)
                
            } else if (answerString.characters.count == 2 && answerString != String(eqautionAnswer)){
                NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.4), target: self, selector: #selector(ViewController.wrongAnswer), userInfo: nil, repeats: false)
            } else {
                
                if (Int(answerString) == eqautionAnswer){
                    if (counter == 19){
                        progress.progress = progress.progress + 0.05
                        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.4), target: self, selector: #selector(ViewController.playSound), userInfo: nil, repeats: false)
                    } else {
                        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.4), target: self, selector: #selector(ViewController.generateEquation), userInfo: nil, repeats: false)
                    }
                }
            }
        }
    }
    
    func changeColor(){
        eqaution.textColor = UIColor.whiteColor()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func Close(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //Actions
    @IBAction func menuBttn(sender: UIButton) {
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.clicking)
        }
    }
    
    @IBAction func pause(sender: UIButton) {
        pausedTime = pausedTime + duration.stop()
        countDown.hidden = true
        countdownView.hidden = false
        pauseBttn.hidden = true
        pausedLabel.hidden = false
        resumeButton.hidden = false
        quitButton.hidden = false
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.clicking)
        }
    }
    
    @IBAction func resumeButtonAction(sender: UIButton) {
        threeSeconds = 3
        generateEq = false
        pausedLabel.hidden = true
        resumeButton.hidden = true
        quitButton.hidden = true
        countDown.image = UIImage(named: String(threeSeconds))
        countDown.hidden = false
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.clicking)
        }
        updateCounter()
    }
    
    @IBAction func replayButton(sender: UIButton) {
        self.loadView()
        if (!soundMuted){
            AudioServicesPlaySystemSound(self.clicking)
        }
        answerString = "?"
        counter = 0
        pausedTime = 0.0
        totalTime = 0.0
        firstEq.shuffle()
        secondEq.shuffle()
        progress.progress = 0.0
        first = true
        mistake = 0.0
        threeSeconds = 3
        countDown.image = UIImage(named: String(3))
        updateCounter()
        setupField()
        countdownView.hidden = false
        showScore.hidden = true
    }
    
    @IBAction func removeLast(sender: UIButton) {
        if (!eqautionString.characters.contains("?")){
            answerString = String(answerString.characters.dropLast())
            eqautionString = (String(firstEq[counter]) + "+" + String(secondEq[counter]) + " = " + answerString)
            eqaution.text = eqautionString
        }
    }
}

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

