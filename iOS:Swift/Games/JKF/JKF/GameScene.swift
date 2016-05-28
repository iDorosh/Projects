//
//  GameScene.swift
//  JKF
//
//  Created by Ian Dorosh on 3/3/16.
//  Copyright (c) 2016 Ian Dorosh. All rights reserved.
//



import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    
    //GameCenterAchievemnets
    var gameCenterAchievements = [String : GKAchievement]()
    
    //Sprites for the background, platform, start, replay, and the eagle
    var start = SKSpriteNode()
    var replay = SKSpriteNode()
    var eagle = SKSpriteNode()
    
    
    var background : SKSpriteNode = SKSpriteNode()
    var background2 : SKSpriteNode = SKSpriteNode()
    
    var ground : SKSpriteNode = SKSpriteNode()
    var ground2 : SKSpriteNode = SKSpriteNode()

    var forground = SKSpriteNode()
    var forground2 = SKSpriteNode()
    
    var totalCoins : Int = 0
    var coinsLabel : String = String()
    
    var values : [Int] = [1,5,10,20]
    
    var secondChance : Bool = false

    
    //Arrays and Atlases for the eagle which will be used to make flying and dying animations
    var flyingArray : [SKTexture] = [SKTexture]()
    var flyingAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var boostArray : [SKTexture] = [SKTexture]()
    var boostAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var diedArray : [SKTexture] = [SKTexture]()
    var diedAtlas : SKTextureAtlas = SKTextureAtlas()
    
    //Badge for a new high score
    var new = SKSpriteNode()
    
    //Buttons for power ups and to replay the game
    var replayButton = SKSpriteNode()
    var boostButton = SKSpriteNode()
    var secondChanceButton = SKSpriteNode()
    var gameCenterButton = SKSpriteNode()
    var menuButton = SKSpriteNode()

    
    //Will stop the bird from flying above the frame
    var ceiling = SKSpriteNode()
    
    
    //Will be used to tell if the game has been started or if the user lost
    var started : Bool = false
    var gameOver : Bool = false
    
    //Will change once the user touches the ground
    var isCharacterOnGround : Bool = false
    var birdDied = false
    
    
    //Integers to update the score
    var score : Int = 0
    var highscore : Int = 0
    
    //Animation and sound actions
    var flapSound : SKAction!
    var hitSound : SKAction!
    var boostSound : SKAction!
    var clickSound : SKAction!
    var flyingAnimation : SKAction!
    var diedAnimation : SKAction!
    var boostAnimation : SKAction!
    
    
    //Constants that will be used for determining collistions
    let CharacterCategory   : UInt32 = 0x1 << 1
    let PlatformCategory    : UInt32 = 0x1 << 2
    let ObstacleCategory    : UInt32 = 0x1 << 3
    let CeilingCategory     : UInt32 = 0x1 << 4
   
    
    
    //Sets the speed at which the obstacles will move accross the screen
    var ObstacleVelocity : CGFloat = 5.0
    var Velocity : CGFloat = 1.0
    var Velocity2 : CGFloat = 0.5
    
    
    //Will determine when new obstacles will be added
    var lastObstacleAdded : CFTimeInterval = 0
    let currentScore = UILabel()
    
    //Game over scores
    let goScore = UILabel()
    let goHighScore = UILabel()

    var timer : Int = 0
    
    var oTimer : Double = 1.0
    var boosting : Bool = false
    
    var scoreText : String = String()
    let currentCoins = SKLabelNode(fontNamed:"MutantAcademyBB")
    
    
    override func didMoveToView(view: SKView) {
        
        //clearAchiements()
        
        getScoreAchievement()
        
        //Assigning actions
        flapSound = (SKAction.playSoundFileNamed("flap.mp3", waitForCompletion: false))
        hitSound = (SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false))
        boostSound = (SKAction.playSoundFileNamed("boost.mp3", waitForCompletion: false))
        clickSound = (SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false))
        
        //Will add ceiling
        addCieling()
        
        //Coin icon for current amount
        let coin = SKSpriteNode(imageNamed: "Coin")
        coin.anchorPoint = CGPointMake(0.5,0.5)
        coin.setScale(0.2)
        coin.position = CGPointMake(frame.minX + 50, frame.maxY - 140)
        coin.zPosition = 9
        coin.name = "totalCoin"

        addChild(coin)
        
        createFont()
        
        self.view!.addSubview(currentScore)
        
        userDefaults()
        
        currentCoins.text = String(totalCoins)
        currentCoins.fontSize = 50
        currentCoins.zPosition = 7
        currentCoins.position = CGPoint(x:self.frame.minX + 120, y:self.frame.maxY - 155)
        
        self.addChild(currentCoins)
 
        // Adding gravity to pull down the eagle after jumping
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.8)
        physicsWorld.contactDelegate = self
        
        
        //Will get atlases and arrays from Animation.swift
        getAnimations()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 29, ground.size.width, 110))
    
        self.physicsBody?.categoryBitMask = PlatformCategory
        self.physicsBody?.collisionBitMask = CharacterCategory
    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if let name = touchedNode.name
            {
                
                //Will open the game center view controller
                if name == "gc" {
                    runAction(clickSound)
                    leaderboard()
                }
        
            }
        }
        if (!birdDied){
            // Will check to see if the user lost
            if (!gameOver){
                
                //Will check if the game hasn't yet started
                for touch: AnyObject in touches {
                    let location = touch.locationInNode(self)
                    if location.y > self.frame.maxY - 200 {
                        
                    } else {
                        if (!started){
                            //Will boost the bird if the player has more than 100 coins
                            let touchedNode = self.nodeAtPoint(location)
                            if let name = touchedNode.name {
                                if (totalCoins > 100){
                                    if name == "boost"{
                                        runAction(clickSound)
                                        boost()
                                    }
                                }
                            } else {
                                //Will start the game normally
                                normalStart()
                            }
                        } else {
                            //Will make the bird fly up
                            screenTapped()
                            self.runAction(flapSound)
                        }
                    }
                }
            } else {
                
                for touch: AnyObject in touches {
                    let location = touch.locationInNode(self)
                    let touchedNode = self.nodeAtPoint(location)
                    
                    if let name = touchedNode.name
                    {
                        //Will restart the game
                        if name == "replayButton"
                        {
                            runAction(clickSound)
                            replay.removeFromParent()
                            replayButton.removeFromParent()
                            secondChanceButton.removeFromParent()
                            gameCenterButton.removeFromParent()
                            new.removeFromParent()
                            //If it is game over than the game will be restarted
                            restartGame()
                        }
                        
                        if name == "secondChance"
                        {
                            runAction(clickSound)
                            runSecondChance()
                            menuButton.removeFromParent()
                        }
                        
                        
                        
                        //Will open the main menu after removing
                        if name == "menu" {
                            runAction(clickSound)
                            goHighScore.removeFromSuperview()
                            goScore.removeFromSuperview()
                            replay.removeFromParent()
                            let startScene = StartScene(size: self.size)
                            startScene.scaleMode = SKSceneScaleMode.AspectFill
                            let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                            self.view?.presentScene(startScene, transition:  transition)
                        }

                    }
                }

            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        //Will check if the game isn't over to move the background, platform, obstacles, and the eagle
        if (!gameOver){
            if (started){
                //Updatescore will update the score at a constant rate
                updateScore()
                
                //Will add a new obstacle when
                if currentTime - self.lastObstacleAdded > oTimer {
                    self.lastObstacleAdded = currentTime + 1
                    self.addObstacle()
                }
            }
            timer = timer + 1
            //Will move the background and platform
            moveBackground()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //If the game isn't over to prevent muliple runs if the eagle hits the obstacle again
        if (!gameOver){
            removeScore()
            var body1: SKPhysicsBody
            var body2: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            {
                body1 = contact.bodyA
                body2 = contact.bodyB
            }
            else {
                body1 = contact.bodyB
                body2 = contact.bodyA
            }
            
            //Will stop the game and set the highscore if needed
            if body1.categoryBitMask == CharacterCategory && body2.categoryBitMask == PlatformCategory {
                if (!birdDied){
                    self.runAction(hitSound)
                }
                if (score > highscore){
                    
                    addChild(new)
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(score, forKey: "highscore")
                    userDefaults.synchronize()
                    
                    if let highscore = userDefaults.valueForKey("highscore") {
                        self.highscore = Int(highscore as! NSNumber)
                    }
                    else {
                        print(0)
                    }
                }
                
                
                createScore()
                addChild(replay)
                if (highscore >= 50){
                    reportAchievment("iad160350", percent: 100.0)
                }
                
                if (highscore >= 100){
                    reportAchievment("iad1603100", percent: 100.0)
                }
                
                
                percentage(score)
                
                saveHighscore()
                birdDied = false
                gameOver = true
                eagle.physicsBody?.dynamic = false
                
                //Will add the second chance button if the user has enough coins
                if (totalCoins >= 200 && !secondChance && highscore >= 100){
                    replayButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) - 105, 200)).1
                    secondChanceButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) - 305, 200)).3
                    gameCenterButton = sprites.mainMenu(CGPointMake(CGRectGetMidX(self.frame) + 305, 200)).2
                    menuButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) + 105, 200)).4
                    addChild(secondChanceButton)
                    addChild(replayButton)
                    addChild(gameCenterButton)
                    addChild(menuButton)
                } else {
                    replayButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) - 205, 200)).1
                    gameCenterButton = sprites.mainMenu(CGPointMake(CGRectGetMidX(self.frame) + 205, 200)).2
                    menuButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame), 200)).4
                    addChild(menuButton)
                    addChild(replayButton)
                    addChild(gameCenterButton)
                }
                
                
            }
            
            
            if body1.categoryBitMask == CharacterCategory && body2.categoryBitMask == ObstacleCategory {
                birdDied = true
                self.runAction(hitSound)
                self.ObstacleVelocity = CGFloat(0.0)
                self.Velocity = CGFloat(0.0)
                self.Velocity2 = CGFloat(0.0)
                physicsWorld.gravity = CGVector(dx: 0.0, dy: -12.8)
                
                self.enumerateChildNodesWithName("Obstacle", usingBlock: { (node, stop) -> Void in
                    if let obstacle = node as? SKSpriteNode {
                        obstacle.physicsBody = nil
                    }
                })
                
                
            }
            
            if body1.categoryBitMask == CharacterCategory && body2.categoryBitMask == CeilingCategory {
                reportAchievment("iad1603Sky", percent: 100.0)
                birdDied = true
                self.runAction(hitSound)
                self.ObstacleVelocity = CGFloat(0.0)
                self.Velocity = CGFloat(0.0)
                self.Velocity2 = CGFloat(0.0)
                physicsWorld.gravity = CGVector(dx: 0.0, dy: -12.8)
                
                self.enumerateChildNodesWithName("Obstacle", usingBlock: { (node, stop) -> Void in
                    if let obstacle = node as? SKSpriteNode {
                        obstacle.physicsBody = nil
                    }
                })
                
                
            }
            
            //Will removeAllActions to stop any movement of the ui objects except the eagle
            eagle.removeAllActions()
            eagle.size = CGSize(width: 80, height: 100)
            //Will make the eagle fall back
            eagle.anchorPoint = CGPointMake(0.5,0.6)
            eagle.runAction(diedAnimation)
           
            }
    }
    
    //shows leaderboard screen
    func leaderboard() {
        let viewController = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        viewController?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func removeScore(){
        currentScore.removeFromSuperview()
        
    }
    
    //Will begin the game by setting the score label to 0 then adding it,
    // remove the start instructions from parent
    //Set started to true and will add an obsticle
    
    func startGame(){
        start.removeFromParent()
        started = true
        
    }
    
    //Will restart the game by re initializing game sceen, and clearing variables to free up ram
    func restartGame(){
        let gameScene = GameScene(size: self.size)
        
        //Clearing out variables
        start = SKSpriteNode()
        replay = SKSpriteNode()
        
        eagle = SKSpriteNode()
        
        background = SKSpriteNode()
        background2  = SKSpriteNode()
        
        ground  = SKSpriteNode()
        ground2  = SKSpriteNode()
        
        forground  = SKSpriteNode()
        forground2  = SKSpriteNode()
        
        flyingArray  = [SKTexture]()
        flyingAtlas  = SKTextureAtlas()
        
        diedArray  = [SKTexture]()
        diedAtlas  = SKTextureAtlas()
        
        
        goHighScore.removeFromSuperview()
        goScore.removeFromSuperview()
        
        //Creates an closing transistion and opens a new game scene
        let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    //Will run when the screen is tapped
    func screenTapped(){
        eagle.physicsBody?.velocity = CGVector(dx: eagle.physicsBody!.velocity.dx, dy: 0.0)
        eagle.physicsBody?.applyImpulse(CGVectorMake(0, 70))
    }
    
    var moving : Bool = false
    //Will move the background and ground and will reset the position once it is off the screen
    func moveBackground(){
        //Will set background and background 2 positions
        background.position = CGPoint(x: background.position.x - Velocity2, y: background.position.y)
        background2.position = CGPoint(x: background2.position.x - Velocity2, y: background2.position.y)
        
        //Will repostion the background back to the just off of the right side of the screen when it goes off the left side
        if (background.position.x < -background.size.width){
            background.position = CGPointMake(background2.position.x + background2.size.width, background.position.y)
        }
        
        // Will repsition the background 2 when it goes off of the left side of the screen
        if (background2.position.x < -background2.size.width){
            background2.position = CGPointMake(background.position.x + background.size.width, background2.position.y)
        }
        
        //Setting the ground postions
        ground.position = CGPoint(x: ground.position.x - ObstacleVelocity, y: ground.position.y)
        ground2.position = CGPoint(x: ground2.position.x - ObstacleVelocity, y: ground2.position.y)
        
        //Will reposition the ground when it goes off of the screen
        if (ground.position.x < -ground.size.width){
            ground.position = CGPointMake(ground2.position.x + ground2.size.width, ground.position.y)
        }
        
        //Will reposition the ground2 when if goes off of the screen
        if (ground2.position.x < -ground2.size.width){
            ground2.position = CGPointMake(ground.position.x + ground.size.width, ground2.position.y)
        }
        
        //Setting the forground postions
        forground.position = CGPoint(x: forground.position.x - Velocity, y: forground.position.y)
        forground2.position = CGPoint(x: forground2.position.x - Velocity, y: forground2.position.y)
        
        //Will reposition the forground when it goes off of the screen
        if (forground.position.x < -forground.size.width){
            forground.position = CGPointMake(forground2.position.x + forground2.size.width, forground.position.y)
        }
        
        //Will reposition the forground2 when if goes off of the screen
        if (forground2.position.x < -forground2.size.width){
            forground2.position = CGPointMake(forground.position.x + forground.size.width, forground2.position.y)
        }
        
        
        
        
        if (!started && !boosting){
            if (moving){
                eagle.position = CGPoint(x: eagle.position.x, y: eagle.position.y + 0.4)
            } else {
                eagle.position = CGPoint(x: eagle.position.x, y: eagle.position.y - 0.4)
            }
            
            
            if (eagle.position.y > 450){
                moving = false
            }
            if (eagle.position.y < 350){
                moving = true
            }
        }
        
    }
    
    //Will update the score label
    func updateScore(){
        
        
        
        
        
        
        //Will move the obsticle along the bottom of the screen
        self.moveObstacle()
    }
    
    func addObstacle() {
        //Creating a new Instance of the Obstacle Sprite
        let obstacle = SKSpriteNode(imageNamed: "Obstacle")
        
        //Setting the position of Obstacle
        obstacle.anchorPoint = CGPointMake(0.5, 0.56)
        obstacle.position = CGPoint(x: frame.size.width + 200, y: 200)
        obstacle.setScale(1.0)
        obstacle.zPosition = 3
        
       
        
        //Setting the physics body size
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 300))
        
        //Setting physics body properties
        obstacle.physicsBody?.dynamic = false
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.restitution = 0.0
        obstacle.physicsBody?.friction = 0.0
        obstacle.physicsBody?.angularDamping = 0.0
        obstacle.physicsBody?.linearDamping = 0.0
        
        //Setting constants to be used for contact and collisions
        obstacle.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle.physicsBody?.collisionBitMask = CharacterCategory
        obstacle.physicsBody?.contactTestBitMask = CharacterCategory
        
        //Setting the obstacle name
        obstacle.name = "Obstacle"
        
        // Selecting random x position for Obstacle
        let random : CGFloat = CGFloat(arc4random_uniform(300))
        obstacle.position = CGPointMake(50 + frame.size.width, random)
        
        
        //Creating a new Instance of the Obstacle Sprite
        let obstacle2 = SKSpriteNode(imageNamed: "Obstacle")
        
        //Setting the position of obstacle2
        obstacle2.anchorPoint = CGPointMake(0.5, 0.56)
        obstacle2.position = CGPoint(x: frame.size.width + 200, y: 700)
        obstacle2.setScale(-1.0)
        obstacle2.xScale = -1.0
        obstacle2.zPosition = 3
        
        
        
        
        //Setting the physics body size
        obstacle2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 300))
        
        //Setting physics body properties
        obstacle2.physicsBody?.dynamic = false
        obstacle2.physicsBody?.allowsRotation = false
        obstacle2.physicsBody?.restitution = 0.0
        obstacle2.physicsBody?.friction = 0.0
        obstacle2.physicsBody?.angularDamping = 0.0
        obstacle2.physicsBody?.linearDamping = 0.0
        
        //Setting constants to be used for contact and collisions
        obstacle2.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle2.physicsBody?.collisionBitMask = CharacterCategory
        obstacle2.physicsBody?.contactTestBitMask = CharacterCategory
        
        //Setting the obstacle2 name
        obstacle2.name = "Obstacle2"
        
        // Selecting random x position for Obstacle
        //let random : CGFloat = CGFloat(arc4random_uniform(800))
        obstacle2.position = CGPointMake(50 + frame.size.width, obstacle.position.y + 500)
        
        //Adding the obstacle
        self.addChild(obstacle)
        
        //Adding the obstacle2
        self.addChild(obstacle2)
        
        var start = SKSpriteNode()
        //Will set the sprite to the image "start" in assets
        start = SKSpriteNode(imageNamed: "Coin")
        start.anchorPoint = CGPointMake(0.5,0.5)
        start.setScale(0.3)
        start.position = CGPointMake(obstacle.position.x, obstacle.position.y+250)
        start.zPosition = 3
        start.name = "Coin"
        
        let coinPosition : CGFloat = CGFloat(arc4random_uniform(20))
     
        if (coinPosition == 2 || coinPosition == 6 || coinPosition == 8 || coinPosition == 10 || coinPosition == 12 || coinPosition == 16)
        {
            if !boosting {
                self.addChild(start)
            }
            
        }
    }
    
    //Will move the ostacle along the bottom of the screen
    func moveObstacle() {
        self.enumerateChildNodesWithName("Obstacle", usingBlock: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                //Will move the obstacle along the bottom of the screen with the velocity that is set in the ObstacleVelocity
                obstacle.position = CGPoint(x: obstacle.position.x - self.ObstacleVelocity, y: obstacle.position.y)
                if (self.timer > 60){
                    if (obstacle.position.x + 60 < 200) {
                        if (!self.birdDied){
                            if self.boosting{
                                self.runAction(SKAction.playSoundFileNamed("point.wav", waitForCompletion: false))
                               self.score = self.score + 5
                            } else {
                                self.runAction(SKAction.playSoundFileNamed("point.wav", waitForCompletion: false))
                              self.score = self.score+1
                                
                            }
                            
                            
                            self.scoreText = String(self.score)
                            self.createFont()
                            self.timer = 0
                        }
                        
                        if (self.score > 5 && self.score < 7){
                            self.oTimer = self.oTimer - 0.1
                        }
                        if (self.score > 15 && self.score < 17){
                            self.oTimer = self.oTimer - 0.1
                        }
                        if (self.score > 25 && self.score < 27){
                            self.oTimer = self.oTimer - 0.1
                        }
                        if (self.score > 30 && self.score < 34){
                            self.oTimer = self.oTimer - 0.1
                        }
                    }
                }
                if obstacle.position.x < -60 {
                    //The obstacle will be removed if its position is less than -60
                    obstacle.removeFromParent()
                }
                
                if (self.boosting){
                    if obstacle.position.x < 700 {
                        obstacle.position.y = obstacle.position.y - 5
                    }
                }
            }
        })
        
        self.enumerateChildNodesWithName("Obstacle2", usingBlock: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                //Will move the obstacle along the bottom of the screen with the velocity that is set in the ObstacleVelocity
                obstacle.position = CGPoint(x: obstacle.position.x - self.ObstacleVelocity, y: obstacle.position.y)
                if obstacle.position.x < -60 {
                    //The obstacle will be removed if its position is less than -60
                    obstacle.removeFromParent()
                }
                if (self.boosting){
                    if obstacle.position.x < 700 {
                        obstacle.position.y = obstacle.position.y + 5
                    }
                }
            }
        })
        
        //Will assign random values to the coins
        self.enumerateChildNodesWithName("Coin", usingBlock: { (node, stop) -> Void in
            if let coin = node as? SKSpriteNode {
                //Will move the obstacle along the bottom of the screen with the velocity that is set in the ObstacleVelocity
                coin.position = CGPoint(x: coin.position.x - self.ObstacleVelocity, y: coin.position.y)
                if coin.position.x < 200 {
                    let coinValue : CGFloat = CGFloat(arc4random_uniform(40))
                    
                    if (coinValue == 2 || coinValue == 4 || coinValue == 6 || coinValue == 8 || coinValue == 10 || coinValue == 12) {
                        self.totalCoins = self.totalCoins + 1
                    } else if (coinValue == 7 || coinValue == 19 || coinValue == 15){
                        self.totalCoins = self.totalCoins + 10
                    } else if (coinValue == 1 || coinValue == 3 || coinValue == 5){
                        self.totalCoins = self.totalCoins + 20
                    } else {
                        self.totalCoins = self.totalCoins + 5
                    }

                    self.currentCoins.text = String(self.totalCoins)
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(self.totalCoins, forKey: "coins")
                    userDefaults.synchronize()
                   
                    
                    //The obstacle will be removed if its position is less than -200
                    self.runAction(SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false))
                    coin.removeFromParent()
                    
                }
            }
        })

        
    }
 
    //Get Animation will set the atlases and arrays in this class usng the functions in the Animation.swift file
    func getAnimations(){
        
        //eagle atlas is the set of images in a project folder and eagle array will be an array of those images
        flyingAtlas = animations.birdAnimations().0
        flyingArray = animations.birdAnimations().1
        diedAtlas = animations.birdAnimations().2
        diedArray = animations.birdAnimations().3
        boostAtlas = animations.birdAnimations().4
        boostArray = animations.birdAnimations().5
       
        getSprites()
    }
    
    
    func getSprites(){
        start = sprites.startInstructions(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame) - 120)).0
        boostButton = sprites.startInstructions(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame) - 350)).1
       
        if (totalCoins >= 100 && highscore >= 50){
            self.addChild(boostButton)
        }
        replay = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame) - 120)).0
        
        if (totalCoins >= 200){
        replayButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) - 210, 200)).1
        secondChanceButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame), 200)).3
        gameCenterButton = sprites.mainMenu((CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame) + 210))).2
            
        } else {
            replayButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) - 105, 200)).1
            secondChanceButton = sprites.gameOverScreen(CGPointMake(CGRectGetMidX(self.frame) + 105, 200)).3
            gameCenterButton = sprites.mainMenu((CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame) + 105))).2
        }
        
        new = sprites.gameOverScreen(CGPointMake(-135, 56)).2
        background = sprites.gameScene(CGPointMake(0, 140)).0
        background2 = sprites.gameScene(CGPointMake(background.size.width-1, 140)).0
        
        
      
        ground = sprites.gameScene(CGPointMake(0, 90)).1
        ground2 = sprites.gameScene(CGPointMake(ground.size.width-1, 90)).1
        
      
        forground = sprites.gameScene(CGPointMake(0, 65)).2
        forground2 = sprites.gameScene(CGPointMake(ground.size.width-1, 65)).2
    
        eagle = sprites.eagle(flyingAtlas)
        
        
        
        diedAnimation = SKAction.repeatAction(SKAction.animateWithTextures(diedArray, timePerFrame: 0.06, resize: false, restore: false), count: 1)
        flyingAnimation = (SKAction.repeatActionForever(SKAction.animateWithTextures(flyingArray, timePerFrame: 0.1)))
        boostAnimation = (SKAction.repeatAction(SKAction.animateWithTextures(boostArray, timePerFrame: 0.1), count: 12))
            
        //Will add children to the screen
        populateUI()
    }
    
    //Will add all the children to the parent
    func populateUI(){
        addChild(start)
        addChild(background)
        addChild(background2)
        addChild(ground)
        addChild(ground2)
        addChild(forground)
        addChild(forground2)
        self.addChild(eagle)
        
        //Will start the flying animation
        eagle.runAction(flyingAnimation)
    }
    
    func addCieling(){
        //Ceiling will prevent the bird from flying off the screen
        ceiling.anchorPoint = CGPointMake(0.5, 0.5)
        ceiling.position = CGPointMake(self.frame.minX, self.frame.maxY - 70)
        
        ceiling.size = CGSizeMake(self.frame.width * 2, 1)
        ceiling.color = UIColor.blackColor()
        ceiling.zPosition = 300
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width * 2, height: 1))
        ceiling.physicsBody?.categoryBitMask = CeilingCategory
        ceiling.physicsBody?.collisionBitMask = CharacterCategory
        ceiling.physicsBody?.contactTestBitMask = CharacterCategory
        ceiling.physicsBody?.dynamic = false
        
        addChild(ceiling)
    }
    
    func userDefaults(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        if let cachedHighscore = userDefaults.valueForKey("highscore") {
            self.highscore = Int(cachedHighscore as! NSNumber)
        }
        else {
        }
        
        
        if let cachedCoins = userDefaults.valueForKey("coins") {
            self.totalCoins = Int(cachedCoins as! NSNumber)
        }
        else {
        }
    }
    
    func createFont(){
        if let font =  UIFont(name: "MutantAcademyBB", size: 80) {
            
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor.blackColor(),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -3
            ]
            
            
            let myMutableString = NSMutableAttributedString(string: scoreText, attributes: textFontAttributes)
            
            
            currentScore.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 150)
            currentScore.center = CGPointMake(371, 80)
            currentScore.textAlignment = NSTextAlignment.Center
            currentScore.attributedText = myMutableString
            
            
        }
    }
    
    func createScore(){
        if let font =  UIFont(name: "MutantAcademyBB", size: 45) {
            
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor.blackColor(),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -3
            ]
            
            
            let myMutableString = NSMutableAttributedString(string: String(score), attributes: textFontAttributes)
            
            
            goScore.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 60)
            goScore.textAlignment = NSTextAlignment.Center
            goScore.attributedText = myMutableString
            
            
            self.view!.addSubview(goScore)
            createHighScore()
            
        }
    }
    
    func createHighScore(){
        if let font =  UIFont(name: "MutantAcademyBB", size: 45) {
            
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor.blackColor(),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -3
            ]
            
            
            let myMutableString = NSMutableAttributedString(string: String(highscore), attributes: textFontAttributes)
            
            
            goHighScore.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height + 65)
            
            goHighScore.textAlignment = NSTextAlignment.Center
            goHighScore.attributedText = myMutableString
            
            
            self.view!.addSubview(goHighScore)
            
            
        }
    }
    
    
    
    func boost(){
        //The boost will remove 100 from current user coins and saves to userdefaults
        totalCoins = totalCoins - 100
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(self.totalCoins, forKey: "coins")
        userDefaults.synchronize()
        
        //Setting current coin label
        currentCoins.text = String(totalCoins)
        
        reportAchievment("jfk1603Boost", percent: 100.0)
        
        //Will play the rocket sound
        self.runAction(boostSound, withKey : "boosting")
        
        //Adjusting eagle size
        eagle.size.height = 115
        eagle.size.width = 215
        eagle.anchorPoint = CGPointMake(0.80, 0.43)
        
        //Moving the obstacles closer together
        oTimer = 0.01
        
        //Making the obstacles move faster
        ObstacleVelocity = 14
        
        //Starts the game
        startGame()
        
        //Removing the boost button
        boostButton.removeFromParent()
        boosting = true
        
        //Stops bird from falling
        eagle.physicsBody?.dynamic = false
        eagle.runAction((boostAnimation), completion : {
            //Adjusting eagle after done boosting
            self.removeActionForKey("boosting")
            self.ObstacleVelocity = 5.0
            self.eagle.size = CGSize(width: 80, height: 100)
            self.eagle.anchorPoint = CGPointMake(0.5, 0.5)
            self.eagle.physicsBody?.dynamic = true
            self.eagle.physicsBody?.applyImpulse(CGVectorMake(0, 70))
            self.runAction(self.flapSound)
            self.oTimer = 1.0
            self.boosting = false
            self.eagle.physicsBody?.velocity = CGVector(dx: self.eagle.physicsBody!.velocity.dx, dy: 0.0)
            self.eagle.physicsBody?.applyImpulse(CGVectorMake(0, 70))
            
        })
    }
    
    func runSecondChance(){
        //Removing 200 coins and saving it to user defaults
        self.secondChance = true
        totalCoins = totalCoins - 200
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(self.totalCoins, forKey: "coins")
        userDefaults.synchronize()
        
        reportAchievment("jfk1603SecondChance", percent: 100.0)
        
        //Setting current coins label
        self.currentCoins.text = String(totalCoins)
        
        //setting velocity and resuming the game and removing obstacles
        self.ObstacleVelocity = CGFloat(5.0)
        self.Velocity = CGFloat(2.0)
        self.Velocity2 = CGFloat(1.0)
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.8)
        
        gameOver = false
        started = true
        
        self.view!.addSubview(currentScore)
        replay.removeFromParent()
        replayButton.removeFromParent()
        gameCenterButton.removeFromParent()
        secondChanceButton.removeFromParent()
        new.removeFromParent()
        eagle.removeFromParent()
        goHighScore.removeFromSuperview()
        removeObstacles()
        goScore.removeFromSuperview()
        
        eagle = sprites.eagle(flyingAtlas)
        eagle.runAction(flyingAnimation)
        eagle.physicsBody?.dynamic = true
        addChild(eagle)
    }
    
    //Normal game start no boost
    func normalStart(){
        startGame()
        boostButton.removeFromParent()
        eagle.physicsBody?.dynamic = true
        self.runAction(flapSound)
        eagle.physicsBody?.velocity = CGVector(dx: eagle.physicsBody!.velocity.dx, dy: 0.0)
        eagle.physicsBody?.applyImpulse(CGVectorMake(0, 70))
    }
    
    

    
    func removeObstacles(){
        self.enumerateChildNodesWithName("Obstacle", usingBlock: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                    if (obstacle.position.x < self.frame.maxX) {
                        obstacle.removeFromParent()
                        
                    }
            }
        })
        
        self.enumerateChildNodesWithName("Obstacle2", usingBlock: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                if (obstacle.position.x < self.frame.maxX) {
                    obstacle.removeFromParent()
                    
                }
            }
        })

    }
    
    //Save Highscore will push the current highscore to game center after verifiying that the user is logged in.
    func saveHighscore() {
        
            let scoreReporter = GKScore(leaderboardIdentifier: "JKF_Leaderboard")
            scoreReporter.value = Int64(highscore)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: { (NSError) -> Void in
            })
        

        
        
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
    
    //Will get the current percentage out of the dictionary if its available if not it will add the new percentage
    func percentage(score1 : Int) {
        //Will check if the percentage exists
        var currentPercentFound : Bool = false
        //Will add 0.1 to the current percent for each point made which will unlock the achievement at 1000 points
        let addPercent : Double = 0.1 * Double(score1)
        
        //Will get the current percentage for the id
        if (gameCenterAchievements.count != 0){
            for (id, achiements) in gameCenterAchievements {
                if (id == "iad1630Total"){
                    
                    //Will stop from reporting the add score
                    currentPercentFound = true
                    
                    //Will add the addPercent to the current percent based on the score
                    var currentPercent : Double = achiements.percentComplete
                    currentPercent = currentPercent + addPercent
                    
                    //Reports the current percentage
                    reportAchievment("iad1630Total", percent: currentPercent)
                    break
                }
            }
        }
        
        //Will run if the achievement percentage isn't found
        if !currentPercentFound{
            reportAchievment("iad1630Total", percent: addPercent)
        }
        
        
    }
    
    //Clearing out achievements
    func clearAchiements(){
        GKAchievement.resetAchievementsWithCompletionHandler { (error) -> Void in
        }
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


}

