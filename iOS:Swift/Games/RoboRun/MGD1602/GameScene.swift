//
//  GameScene.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/1/16.
//  Copyright (c) 2016 Ian Dorosh. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //----Sprites for the background, platform, start, replay, and the robot-----
    
    var start = SKSpriteNode()
    var replay = SKSpriteNode()
    var menu = SKSpriteNode()
    
    var robot = SKSpriteNode()

    var background : SKSpriteNode = SKSpriteNode()
    var background2 : SKSpriteNode = SKSpriteNode()
    
    var ground : SKSpriteNode = SKSpriteNode()
    var ground2 : SKSpriteNode = SKSpriteNode()
    
    var pause : SKSpriteNode = SKSpriteNode()
    var pausedLabel : SKSpriteNode = SKSpriteNode()
    
    
    
    //------Buttons to resume and restart the game-----------
    
    var replayButton = SKSpriteNode()
    var resumeButton = SKSpriteNode()
    
    //Will appear when the user gets a highscore
    var new = SKSpriteNode()

    
    //-------Arrays and Atlases for the robot which will be used to make running, jumping, sliding, and dying animations------
    
    var runningArray : [SKTexture] = [SKTexture]()
    var runningAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var jumpArray : [SKTexture] = [SKTexture]()
    var jumpAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var slideArray : [SKTexture] = [SKTexture]()
    var slideAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var diedArray : [SKTexture] = [SKTexture]()
    var diedAtlas : SKTextureAtlas = SKTextureAtlas()
    
    var makeSpace : Bool = false
    
    
    //-------------Actions for the sounds and animations-------------
    
    var hit : SKAction!
    var jump : SKAction!
    var jumpAnimation : SKAction!
    var slideAnimation : SKAction!
    var runningAnimation : SKAction!

    
    //-------Will be used to tell if the game has been started or if the user lost--------
    
    var started : Bool = false
    var gameOver : Bool = false
    
    
    //----------Will change once the user touches the ground---------
    
    var isCharacterOnGround : Bool = false
    var newScore : Bool = false
    
    
    //Is game paused
    var gameIsPaused : Bool = false
    
    //Will stop jumping when sliding
    var sliding : Bool = false
    
    //Will stop sliding when jumping
    var jumping : Bool = false
    
    
    //------Integers to update the score and to determine if the user has double jumped to stop a 3rd jump------
    
    var metersTimer : Int = 0
    var scoreMeters : Int = 0
    var doubleJump : Int = 0
    var highScoreInt : Int = 0
    
    
    //--------Will display the current score------------
    
    var scoreLabel : SKLabelNode = SKLabelNode()
    var highScore : SKLabelNode = SKLabelNode()
    var currentScore : SKLabelNode = SKLabelNode()
    
    
    //--------Constants that will be used for determining collistions--------
    
    let CharacterCategory   : UInt32 = 0x1 << 1
    let PlatformCategory    : UInt32 = 0x1 << 2
    let ObstacleCategory    : UInt32 = 0x1 << 3
    
    
    //Sets the speed at which the obstacles will move accross the screen
    var ObstacleVelocity : CGFloat = 6.0

    
    //Will determine when new obsticles will be added
    var lastObstacleAdded : CFTimeInterval = 0
    
    
    //Will play the background music
    var backgroundMusic : AVAudioPlayer?
    
    //Will add 1 to the obstacle velocity
    var counter : Int = 0
    
    
    override func didMoveToView(view: SKView) {
        
        //SKAction to play sounds
        
        hit = (SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false))
        jump = (SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: false))
        
        
        //Adding gravity to pull down the robot after jumping
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.5)
        physicsWorld.contactDelegate = self
        
        //UserDefaults for the highscore
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        //Will set the sprite to image "replay" in assets
        new = SKSpriteNode(imageNamed: "NewLabel")
        
        //Setting position
        new.anchorPoint = CGPointMake(0.5, 0.5)
        
        
        //Will check device for the new label position
        if checkDevice(){
            new.position = CGPointMake(self.frame.midX + 120, self.frame.midY - 15)
        } else {
            new.position = CGPointMake(self.frame.midX + 120, self.frame.midY - 55)
        }
        new.zPosition = 30
        
        //Will get the high score
        if let cachedHighscore = userDefaults.valueForKey("highscore") {
            self.highScoreInt = Int(cachedHighscore as! NSNumber)
        }
        
        //Setting audio player
        backgroundMusic = BackgroundMusic.setupAudioPlayerWithFile()
        
        //Will get atlases and arrays from Animation.swift
        getAnimations()
        
        //Will get UI Elements from UI Object.swift
        getUIElements()
        
        //Will add children to the screen
        populateUI()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Will check to see if the user lost
        if (!gameOver){
            //Will check if the game hasn't yet started
            if (!started){
                //Will start the game
                startGame()
            } else {
                //If the game has started. Touches will be registed as a left or right tap
                for touch: AnyObject in touches {
                    let location = touch.locationInNode(self)
                    let touchedNode = self.nodeAtPoint(location)
                    if let name = touchedNode.name
                    {
                        //If the pause button is clicked
                        if name == "pause"
                        {
                            //Pauses background music
                            backgroundMusic!.pause()
                            
                            //Will set the pausedLabel position
                            pausedLabel.position = CGPointMake(self.frame.midX, self.frame.midY + 100)
                            
                            //Will set the resume buttin position
                            self.resumeButton.position = CGPointMake(CGRectGetMidX(self.frame), 360)
                            
                            //Adding label and button
                            addChild(pausedLabel)
                            addChild(resumeButton)
                            
                            //Removing pause button and running pauseGame
                            pause.removeFromParent()
                            self.runAction(SKAction.runBlock(self.pauseGame))
                        }
                        
                        //If the resume button is clicked
                        if name == "resume"{
                            //Resumes background music
                            backgroundMusic!.play()
                            //Removes paused label and resume button then adds back the pause button
                            pausedLabel.removeFromParent()
                            resumeButton.removeFromParent()
                            addChild(pause)
                            //Resumes the scene
                            self.scene!.view?.paused = false
                        }
                        
                    } else {
                        if location.x < self.size.width/2 {
                            //The robot will slide if the left side of the screen is tapped
                            screenTapped("slide")
                        } else {
                            //The robot will jump if the left side of the screen is tapped
                            screenTapped("jump")
                        }
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
                    if name == "button"{
                        restartGame()
                    }
                    //Will open the main menu
                    if name == "menu"{
                        let startScene = StartScene(size: self.size)
                        startScene.scaleMode = SKSceneScaleMode.AspectFill
                        let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                        self.view?.presentScene(startScene, transition:  transition)
                    }
                }
            }

            
        }
    }
    
    
    override func update(currentTime: CFTimeInterval){
        counter++
        if (counter == 2000){
            ObstacleVelocity = ObstacleVelocity + 1
            counter = 0
        }
    
        
        //Will check if the game isn't over to move the background, platform, obstacles, and the robot
        if (!gameOver){
            if (started){
                //Updatescore will update the score at a constant rate
                updateScore()
                
                //Will add a new obstacle when
                if currentTime - self.lastObstacleAdded > 3 {
                    self.lastObstacleAdded = currentTime + 1
                    //self.addObstacle()
                    makeSpace = true
                }
            }
            
            //Will move the background and platform
            moveBackground()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        
        if (!gameOver){
            //Will get the first and second body that made contact
            var firstBody : SKPhysicsBody
            var secondBody : SKPhysicsBody
            
            //will set the first body and second body
            if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
                firstBody = contact.bodyA;
                secondBody = contact.bodyB;
            }else {
                firstBody = contact.bodyB;
                secondBody = contact.bodyA;
            }
            
            //If the game isn't over to prevent muliple runs if the robot hits the obstacle again
            if (!gameOver){
                if (firstBody.categoryBitMask == CharacterCategory && secondBody.categoryBitMask == ObstacleCategory){
                    //Will check the current score and will set the new highscore if its higher
                    if (scoreMeters > highScoreInt){
                        newScore = true
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setValue(scoreMeters, forKey: "highscore")
                        userDefaults.synchronize()
                        
                        if let highscore = userDefaults.valueForKey("highscore") {
                            self.highScoreInt = Int(highscore as! NSNumber)
                        }
                        else {
                        }
                    }

                    //Will play the hit sound effect
                    runAction(hit)
                    
                    //Will removeAllActions to stop any movement of the ui objects except the robot
                    robot.removeAllActions()
                    //Will make the robot fall back
                    robot.runAction((SKAction.repeatAction(SKAction.animateWithTextures(diedArray, timePerFrame: 0.07, resize: false, restore: false), count: 1)), completion: {
                        self.robot.physicsBody = nil
                        self.ground.physicsBody = nil
                        self.showReplay()
                    })
                    robot.position.y = robot.position.y - 10
                    //Will make the start screen apear if the screen is touched again
                    gameOver = true
                    robot.physicsBody?.dynamic = false
                }
            }
        }
        
        //Will allow the player to double jump again after touching the ground
        doubleJump = 0
    }
    
    
    
    //Will run when the screen is tapped
    func screenTapped(action : String){
        
        //If the action was slide than it will run an action to make the robot slide and will also play the sound effect
        if (action == "slide"){
            if (!jumping) {
                robot.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 65))
                robot.anchorPoint = CGPointMake(0.4, 0.4)
                self.robot.physicsBody?.categoryBitMask = self.CharacterCategory
                self.robot.physicsBody?.collisionBitMask = self.ObstacleCategory | self.PlatformCategory
                self.robot.physicsBody?.contactTestBitMask = self.ObstacleCategory | self.PlatformCategory
                    runAction(jump)
                sliding = true
                robot.runAction((slideAnimation), completion : {
                    self.sliding = false
                    self.resetRobot()
                })
            }
        }
        else {
            if (!sliding){
                //If the action was jump than it will run an action to make the robot jump and will also play the sound effect
                //Will add 1 to double jump
                //If the player double jumped it will stop them from jumping again
                doubleJump++
                if (doubleJump < 3){
                    
                    jumping = true
                    runAction(jump)
                    robot.runAction(jumpAnimation, completion: {
                        self.jumping = false
                    })
                    
                    //Will move the robot up
                    robot.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    robot.physicsBody?.applyImpulse(CGVectorMake(0, 150))
                }
            }
        }
    }
    
    
    
    //Will move the background and ground and will reset the position once it is off the screen
    func moveBackground(){
        
        
        
        //Will set background and background 2 positions
        background.position = CGPoint(x: background.position.x - 1, y: background.position.y)
        background2.position = CGPoint(x: background2.position.x - 1, y: background2.position.y)
        
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
        
        if (!started){
            //Will reposition the ground when it goes off of the screen
            if (ground.position.x < -ground.size.width){
                ground.removeAllChildren()
                ground.position = CGPointMake(ground2.position.x + ground2.size.width, ground.position.y)
            }
            
            //Will reposition the ground2 when if goes off of the screen
            if (ground2.position.x < -ground2.size.width){
                ground2.removeAllChildren()
                ground2.position = CGPointMake(ground.position.x + ground.size.width, ground2.position.y)
            }
        } else {
            
            //Used to randomly create a gap
            let gapPosition : CGFloat = CGFloat(arc4random_uniform(10))
            
            //Will reposition the ground when it goes off of the screen while adding gaps once the user actually starts playing
            if (ground.position.x < -ground.size.width){
                ground.removeAllChildren()
                
                //Randomly create cap
                if (gapPosition == 2 || gapPosition == 4 || gapPosition == 6 || gapPosition == 8 || gapPosition == 10){
                    ground.position = CGPointMake(ground2.position.x + ground2.size.width + 300, ground.position.y)
                } else {
                    ground.position = CGPointMake(ground2.position.x + ground2.size.width, ground.position.y)
                }
                addObstacle1(ground)
               
            }
            
            //Will reposition the ground2 when if goes off of the screen while adding gaps when the user starts playing
            if (ground2.position.x < -ground2.size.width){
                ground2.removeAllChildren()
                ground2.position = CGPointMake(ground.position.x + ground.size.width + 300, ground2.position.y)
                addObstacle1(ground2)
                
            }
        }
        
        //Setting a point that will end the game and currently simply restart it
        if (!gameOver){
            if (robot.position.y < frame.minY){
                
                if (scoreMeters > highScoreInt){
                    newScore = true
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(scoreMeters, forKey: "highscore")
                    userDefaults.synchronize()
                    
                    if let highscore = userDefaults.valueForKey("highscore") {
                        self.highScoreInt = Int(highscore as! NSNumber)
                    }
                    else {
                    }
                }

                showReplay()
                gameOver = true
            }
        }
    }
    
    
    //Get Animation will set the atlases and arrays in this class usng the functions in the Animation.swift file
    func getAnimations(){
        runningArray = Animation.getRobot().0
        runningAtlas = Animation.getRobot().1
        
        jumpArray = Animation.getJump().0
        jumpAtlas = Animation.getJump().1
        
        slideArray = Animation.getSlide().0
        slideAtlas = Animation.getSlide().1
        
        diedArray = Animation.getDied().0
        diedAtlas = Animation.getDied().1
    }
    
    //Will get all the UI elements from the UIObjects.swift file
    func getUIElements(){
        scoreLabel = UIObjects.score()
        start = UIObjects.start()
        replay = UIObjects.replay()
        background = UIObjects.background().0
        background2 = UIObjects.background().1
        ground = UIObjects.ground().0
        ground2 = UIObjects.ground().1
        robot = UIObjects.robot(runningAtlas)
        pause = UIObjects.pause()
        pausedLabel = UIObjects.pausedLabel()
        replayButton = UIObjects.replayButton()
        currentScore = UIObjects.currentScore()
        highScore = UIObjects.highScore()
        resumeButton = UIObjects.resumeButton()
        menu = UIObjects.menuButton()
        
        if (checkDevice()){
            pause.position = CGPointMake(60, 680)
            scoreLabel.position = CGPointMake(930, 680)
        }
        
    }
    
    //Will add all the children to the parent
    func populateUI(){
        addChild(start)
        addChild(background)
        addChild(background2)
        addChild(ground)
        addChild(ground2)
        self.addChild(robot)
        
        //Preloading SKActions for animations
        jumpAnimation = (SKAction.repeatAction(SKAction.animateWithTextures(jumpArray, timePerFrame: 0.1, resize: false, restore: false), count: 1))
        slideAnimation = (SKAction.repeatAction(SKAction.animateWithTextures(slideArray, timePerFrame: 0.1, resize: false, restore: false), count: 1))
        runningAnimation = (SKAction.repeatActionForever(SKAction.animateWithTextures(runningArray, timePerFrame: 0.1)))
        
        //Will start the running animation
        robot.runAction(runningAnimation)
        
        //Will loop the background music
        backgroundMusic?.numberOfLoops = -1
        
        //Will start the background music
        backgroundMusic!.play()
        
    }
    
    //Start the game
    func startGame(){
        scoreLabel.text = "0"
        addChild(scoreLabel)
        addChild(pause)
        start.removeFromParent()
        started = true
    }
    
    //Will pause the game
    func pauseGame()
    {
        self.scene!.view?.paused = true
    }
    
    //Will begin the game by setting the score label to 0 then adding it,
    // remove the start instructions from parent
    //Set started to true and will add an obsticle
    
    func showReplay(){
        
        if (checkDevice()){
            replay.position = CGPointMake(self.frame.midX, self.frame.midY)
            self.replayButton.position = CGPointMake(CGRectGetMidX(self.frame) - 100, 190)
            self.menu.position = CGPointMake(CGRectGetMidX(self.frame) + 100, 190)
            self.currentScore.position = CGPoint(x:self.frame.midX, y:405)
            self.highScore.position = CGPoint(x:self.frame.midX, y:390-100)
        } else {
            self.currentScore.position = CGPoint(x:self.frame.midX, y:370)
            self.highScore.position = CGPoint(x:self.frame.midX, y:355-100)
            replay.position = CGPointMake(self.frame.midX, self.frame.midY-40)
            menu.position = CGPointMake(self.frame.midX + 100, 160)
            self.replayButton.position = CGPointMake(CGRectGetMidX(self.frame)  - 100 , 160)
        }
        pause.removeFromParent()
        scoreLabel.removeFromParent()
        currentScore.text = String(scoreMeters)
        highScore.text = String(highScoreInt)
        self.addChild(self.currentScore)
        self.addChild(self.highScore)
        self.addChild(self.replay)
        self.addChild(self.replayButton)
        self.addChild(self.menu)
        
        if (newScore){
            self.addChild(new)
            newScore = false
        }
    }
    
    //Will restart the game by re initializing game sceen, and clearing variables to free up ram
    func restartGame(){
        let gameScene = GameScene(size: self.size)
        
        //Clearing out variables
        start = SKSpriteNode()
        replay = SKSpriteNode()
        
        robot = SKSpriteNode()
        
        background = SKSpriteNode()
        background2  = SKSpriteNode()
        
        ground  = SKSpriteNode()
        ground2  = SKSpriteNode()
        
        runningArray  = [SKTexture]()
        runningAtlas  = SKTextureAtlas()
        
        jumpArray  = [SKTexture]()
        jumpAtlas  = SKTextureAtlas()
        
        slideArray  = [SKTexture]()
        slideAtlas  = SKTextureAtlas()
        
        diedArray  = [SKTexture]()
        diedAtlas  = SKTextureAtlas()
        
        backgroundMusic?.stop()
        
        //Creates an closing transistion and opens a new game scene
        let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    
    //Will update the score label
    func updateScore(){
        var scoreText : String = String()
        
        metersTimer++
        if (metersTimer == 60){
            scoreMeters++
            scoreText = String(scoreMeters)
            scoreLabel.text = scoreText + " M"
            metersTimer = 0
        }
        
        //Will move the obsticle along the bottom of the screen
        self.moveObstacle()
        
    }
    
    func addObstacle1(platform : SKSpriteNode) {
        
        let ObstaclePosition : CGFloat = CGFloat(arc4random_uniform(10))
        
        //Creating a new Instance of the Obstacle Sprite
        let obstacle = SKSpriteNode(imageNamed: "Obstacle")
        
        //Setting the position of Obstacle
        obstacle.anchorPoint = CGPointMake(0.5, 0.4)
        obstacle.setScale(0.8)
        obstacle.zPosition = 5
        
        //Setting the physics body size
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 90))
        
        //Setting physics body properties
        obstacle.physicsBody?.dynamic = false
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.restitution = 0.0
        obstacle.physicsBody?.friction = 0.0
        obstacle.physicsBody?.angularDamping = 0.0
        obstacle.physicsBody?.linearDamping = 0.0
        obstacle.physicsBody?.affectedByGravity = false
        
        //Setting constants to be used for contact and collisions
        obstacle.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle.physicsBody?.collisionBitMask = CharacterCategory | PlatformCategory
        obstacle.physicsBody?.contactTestBitMask = CharacterCategory | PlatformCategory
        
        //Setting the obstacle name
        obstacle.name = "Obstacle"
        
        
        
        //Trying to spawn obstacles randomly on the platform while missing the gaps and only having them spawn off screen
        let random : CGFloat = CGFloat(arc4random_uniform(1200 - 200) + 200)
        obstacle.position = CGPointMake(random, 150)
        
        if (ObstaclePosition == 2 || ObstaclePosition == 4 || ObstaclePosition == 6 || ObstaclePosition == 8 || ObstaclePosition == 10){
            obstacle.position = CGPointMake(random, 300)
            obstacle.yScale = -0.8
        }
        
        platform.addChild(obstacle)
        
        let ObstaclePosition2 : CGFloat = CGFloat(arc4random_uniform(10))
        
        //Creating a new Instance of the obstacle2 Sprite
        let obstacle2 = SKSpriteNode(imageNamed: "Obstacle")
        
        //Setting the position of obstacle2
        obstacle2.anchorPoint = CGPointMake(0.5, 0.4)
        obstacle2.setScale(0.8)
        obstacle2.yScale = -0.8
        obstacle2.zPosition = 5
        
        //Setting the physics body size
        obstacle2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 90))
        
        //Setting physics body properties
        obstacle2.physicsBody?.dynamic = false
        obstacle2.physicsBody?.allowsRotation = false
        obstacle2.physicsBody?.restitution = 0.0
        obstacle2.physicsBody?.friction = 0.0
        obstacle2.physicsBody?.angularDamping = 0.0
        obstacle2.physicsBody?.linearDamping = 0.0
        obstacle2.physicsBody?.affectedByGravity = false
        
        //Setting constants to be used for contact and collisions
        obstacle2.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle2.physicsBody?.collisionBitMask = CharacterCategory | PlatformCategory
        obstacle2.physicsBody?.contactTestBitMask = CharacterCategory | PlatformCategory
        
        //Setting the obstacle2 name
        obstacle2.name = "Obstacle"
        
        //Trying to make the obstacles spawn off screen
        let random2 : CGFloat = CGFloat(arc4random_uniform(3500 - 1500) + 1500)
        obstacle2.position = CGPointMake(random2, 300)
       
        if (ObstaclePosition2 == 2 || ObstaclePosition2 == 4 || ObstaclePosition2 == 6 || ObstaclePosition2 == 8 || ObstaclePosition2 == 10){
            obstacle2.position = CGPointMake(random2, 150)
            obstacle2.yScale = 0.8
        }
        
        //Adding obstacle to the ground
        platform.addChild(obstacle2)
        
        if (obstacle2.position.y < 1800){
            let ObstaclePosition3 : CGFloat = CGFloat(arc4random_uniform(10))
            
            //Creating a new Instance of the obstacle2 Sprite
            let obstacle3 = SKSpriteNode(imageNamed: "Obstacle")
            
            //Setting the position of obstacle2
            obstacle3.anchorPoint = CGPointMake(0.5, 0.4)
            obstacle3.setScale(0.8)
            obstacle3.yScale = -0.8
            obstacle3.zPosition = 5
            
            //Setting the physics body size
            obstacle3.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100, 90))
            
            //Setting physics body properties
            obstacle3.physicsBody?.dynamic = false
            obstacle3.physicsBody?.allowsRotation = false
            obstacle3.physicsBody?.restitution = 0.0
            obstacle3.physicsBody?.friction = 0.0
            obstacle3.physicsBody?.angularDamping = 0.0
            obstacle3.physicsBody?.linearDamping = 0.0
            obstacle3.physicsBody?.affectedByGravity = false
            
            //Setting constants to be used for contact and collisions
            obstacle3.physicsBody?.categoryBitMask = ObstacleCategory
            obstacle3.physicsBody?.collisionBitMask = CharacterCategory | PlatformCategory
            obstacle3.physicsBody?.contactTestBitMask = CharacterCategory | PlatformCategory
            
            //Setting the obstacle2 name
            obstacle3.name = "Obstacle"
            
            //Trying to make the obstacles spawn off screen
            let random3 : CGFloat = CGFloat(arc4random_uniform(3500 - 3000) + 3000)
            obstacle3.position = CGPointMake(random3, 300)
            
            if (ObstaclePosition3 == 2 || ObstaclePosition3 == 4 || ObstaclePosition3 == 6 || ObstaclePosition2 == 8 || ObstaclePosition3 == 10){
                obstacle3.position = CGPointMake(random3, 150)
                obstacle3.yScale = 0.8
            }
            
            //Adding obstacle to the ground
            platform.addChild(obstacle3)
        }
  
    }
    
    
    
    //Will move the ostacle along the bottom of the screen
    func moveObstacle() {
        self.enumerateChildNodesWithName("Obstacle", usingBlock: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                    if obstacle.position.x < -60 {
                        //The obstacle will be removed if its position is less than -60
                        obstacle.removeFromParent()
                    }
                
            }
        
        })
    }
    
    
    //Will reset the proper physics to the robot sprite after sliding
    func resetRobot(){
        self.robot.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 100))
        self.robot.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.dynamic = true
        
        //Setting resistance and bounce to 0
        robot.physicsBody?.restitution = 0.0
        robot.physicsBody?.friction = 0.0
        robot.physicsBody?.angularDamping = 0.0
        robot.physicsBody?.linearDamping = 0.0
        
        //Assigning constants to determine collisions
        self.robot.physicsBody?.categoryBitMask = self.CharacterCategory
        self.robot.physicsBody?.collisionBitMask = self.ObstacleCategory | self.PlatformCategory
        self.robot.physicsBody?.contactTestBitMask = self.ObstacleCategory | self.PlatformCategory
    }
    
    
    //Will check if the device is an ipad
    func checkDevice() -> Bool{
        return (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        
    }
}
