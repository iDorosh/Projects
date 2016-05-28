//
//  CreateImages.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/3/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation
import SpriteKit

//Class that will populate the main GameScene
class UIObjects {
    
    
    //-----------------------LABELS--------------------------
    
    //Score will return the score label and with set position
    class func score() -> SKLabelNode{
        
        //Settung text font
        let scoreLabel = SKLabelNode(fontNamed:"Helvetica")
        
        //Setting text attributes
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.position = CGPoint(x:930, y:600)
        scoreLabel.zPosition = 6
        
        //Returns the score Label
        return scoreLabel
    }
    
    //CurrentScore will return the currentScore for the game over screen
    class func currentScore() -> SKLabelNode{
        
        //Setting text font
        let currentScore = SKLabelNode(fontNamed:"Helvetica")
        
        //Setting text attributes
        currentScore.fontSize = 65
        currentScore.fontColor = UIColor.darkGrayColor()
        currentScore.zPosition = 200
        
        //Returns the currentScore Label
        return currentScore
    }
    
    //HighScore will return the highScore label for the gameover screen
    class func highScore() -> SKLabelNode{
        
        //Settung text font
        let highScore = SKLabelNode(fontNamed:"Helvetica")
        
        //Setting text attributes
        highScore.fontSize = 65
        highScore.fontColor = UIColor.darkGrayColor()
        highScore.position = CGPoint(x:930, y:600)
        highScore.zPosition = 200
        
        //Returns the highScore Label
        return highScore
    }
    
    
    
    
    //-----------------------------------MENUS-------------------------------------
    
    //Start will display the game name and press to start when the app is launched
    class func start() -> SKSpriteNode{
        
        //Will set the sprite to the image "InstructionsScreen" in assets
        let start = SKSpriteNode(imageNamed: "InstructionsScreen")
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            start.yScale = 1.1
        }
        
        //Setting position
        start.anchorPoint = CGPointZero
        start.position = CGPointMake(-165, 0)
        start.zPosition = 10
        
        //Return the start sprite
        return start
    }
    
    //StartScreen will display the start screen when the app is launched
    class func startScreen() -> SKSpriteNode{
        
        //Will set the sprite to the image "startScreen" in assets
        let startScreen = SKSpriteNode(imageNamed: "StartScreen")
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            startScreen.yScale = 1.1
           
        }
       
        //Setting position
        startScreen.anchorPoint = CGPointZero
        startScreen.position = CGPointMake(-165, 0)
        startScreen.zPosition = 10
        
        //Return the startScreen sprite
        return startScreen
    }
    
    //CreditScreen will display the game credits
    class func creditScreen() -> SKSpriteNode{
        
        //Will set the sprite to the image "creditsScreen" in assets
        let creditScreen = SKSpriteNode(imageNamed: "CreditScreen")
        
        //Setting scale for the iPad
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            creditScreen.yScale = 1.1
            
        }
        
        //Setting position
        creditScreen.anchorPoint = CGPointZero
        creditScreen.position = CGPointMake(-165, 0)
        creditScreen.zPosition = 10
        
        //Return the credit screen sprite
        return creditScreen
    }
    
    
    //Replay will display the game over screen
    class func replay() -> SKSpriteNode{
        
        //Will set the sprite to image "replaySCreen" in assets
        let replay = SKSpriteNode(imageNamed: "ReplayScreen")
        
        //Setting position
        replay.anchorPoint = CGPointMake(0.5, 0.5)
        replay.zPosition = 15
        
        //Will return replay
        return replay
    }
    
    
    
    
    //-----------------------BUTTONS--------------------------
    
    //Playbutton will display the play button on the main menu
    class func playButton() -> SKSpriteNode{
        
        //Will set the sprite to image "playbutton" in assets
        let playButton = SKSpriteNode(imageNamed: "PlayButton")
        
        //Setting position
        playButton.anchorPoint = CGPointMake(0.5, 0.5)
        playButton.setScale(0.2)
        playButton.zPosition = 15
        playButton.name = "playButton"
        
        //Will return playbutton
        return playButton
    }
    
    //CreditsButton will display the creditsButton
    class func creditsButton() -> SKSpriteNode{
        
        //Will set the sprite to image "creditsbutton" in assets
        let creditsButton = SKSpriteNode(imageNamed: "CreditsButton")
        
        //Setting position
        creditsButton.anchorPoint = CGPointMake(0.5, 0.5)
        creditsButton.setScale(0.2)
        creditsButton.zPosition = 15
        creditsButton.name = "creditsButton"
        
        //Will return credits button
        return creditsButton
    }
    
    //Back will display the back button in the credits screen
    class func back() -> SKSpriteNode{
        
        //Will set the sprite to image "back" in assets
        let back = SKSpriteNode(imageNamed: "BackButton")
        
        //Setting position
        back.anchorPoint = CGPointMake(0.5, 0.5)
        back.zPosition = 15
        back.name = "back"
        
        //Will return back
        return back
    }
    
    //ReplayButton will display the replay button on the game over screen
    class func replayButton() -> SKSpriteNode{
        //Will set the sprite to image "replayButton" in assets
        let replayButton = SKSpriteNode(imageNamed: "ReplayButton")
        //Setting position
        replayButton.anchorPoint = CGPointMake(0.5, 0.5)
        replayButton.zPosition = 100
        replayButton.name = "button"
        replayButton.setScale(0.15)
    
        //Will return replaybutton
        return replayButton
    }
    
    //Will display the menu button on the game over screen
    class func menuButton() -> SKSpriteNode{
        //Will set the sprite to image "menuButton" in assets
        let menuButton = SKSpriteNode(imageNamed: "MenuButton")
        //Setting position
        menuButton.anchorPoint = CGPointMake(0.5, 0.5)
        menuButton.zPosition = 100
        menuButton.name = "menu"
        menuButton.setScale(0.15)
        
        //Will return menubutton
        return menuButton
    }
    
    
    //Pause will display when the game is started
    class func pause() -> SKSpriteNode{
        
        let nodeTexture = SKTexture(imageNamed: "PauseButton")
        
        let  pause : SKSpriteNode = SKSpriteNode(texture: nodeTexture)
        
        //Setting position
        pause.anchorPoint = CGPointZero
        pause.position = CGPointMake(60, 600)
        pause.zPosition = 90
        pause.setScale(0.06)
        pause.name = "pause"
        
        //Will return Pause sprite
        return pause
    }
    
    //Will return the resumeButton on the pause screen
    class func resumeButton() -> SKSpriteNode{
        //Will set the sprite to image "resumeButton" in assets
        let resumeButton = SKSpriteNode(imageNamed: "ResumeButton")
        //Setting position
        resumeButton.anchorPoint = CGPointMake(0.5, 0.5)
        resumeButton.zPosition = 100
        resumeButton.name = "resume"
        resumeButton.setScale(0.15)
        
        //Will return resumeButton
        return resumeButton
    }

    
    
    //---------------LABEL SPRITE-------------
    
    //Replay will display the game over screen
    class func pausedLabel() -> SKSpriteNode{
        
        //Will set the sprite to image "replay" in assets
        let pausedLabel = SKSpriteNode(imageNamed: "PausedLabel")
        
        //Setting position
        pausedLabel.anchorPoint = CGPointMake(0.5, 0.5)
        pausedLabel.zPosition = 140
        pausedLabel.setScale(0.4)
        pausedLabel.name = "play"
        //Will return pausedLabel
        return pausedLabel
    }
    
    
    //---------------------------GAME SCENE-------------------------------------
    
    //Creating 2 backgrounds so when one leaves the screen another will appear
    class func background() -> (SKSpriteNode, SKSpriteNode){
        
        //Will set the sprites to the image "background" in assets
        let background = SKSpriteNode(imageNamed: "Background")
        let background2 = SKSpriteNode(imageNamed: "Background")
        
        //Setting positions for both backgrounds
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        background.zPosition = 2
        
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background2.size.width-1, 0)
        
        //Will return both sprites
        return (background, background2)
    }
    
    
    //Creating 2 platforms so when one leaves the screen another will appear
    class func ground() -> (SKSpriteNode, SKSpriteNode){
        
        let CharacterCategory   : UInt32 = 0x1 << 1
        let PlatformCategory    : UInt32 = 0x1 << 2
        
        
        //Will set the sprites to the image "ground" in assets
        let ground = SKSpriteNode(imageNamed: "Ground")
        let ground2 = SKSpriteNode(imageNamed: "Ground")
        
        //Setting the positions of both sprites
        ground.anchorPoint = CGPointZero
        ground.position = CGPointMake(0, 200)
        ground.zPosition = 6
        ground.setScale(0.5)
        
        ground2.anchorPoint = CGPointZero
        ground2.position = CGPointMake(ground2.size.width/2-1, 200)
        ground2.zPosition = 6
        ground2.setScale(0.5)
        
        //Adding a physics body at the bottom of the screen to act like the ground
        ground.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, ground.size.width, 50))
        ground.physicsBody?.categoryBitMask = PlatformCategory
        ground.physicsBody?.collisionBitMask = CharacterCategory
        
        //Adding a physics body at the bottom of the screen to act like the ground
        ground2.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, ground.size.width, 50))
        ground2.physicsBody?.categoryBitMask = PlatformCategory
        ground2.physicsBody?.collisionBitMask = CharacterCategory
        
        //Returning both platforms
        return (ground, ground2)
    }
    
    
    //------------------------------------CHARACTER----------------------------------------------
    
    //Will make robot using the atlas that is passed in by GameScene and will also include physics
    class func robot(runningAtlas : SKTextureAtlas) -> (SKSpriteNode){
        
        //Contstants used determine wich objects are colliding or onces that make contact
        let CharacterCategory   : UInt32 = 0x1 << 1
        let PlatformCategory    : UInt32 = 0x1 << 2
        let WallCategory        : UInt32 = 0x1 << 3
        
        //Robto will hold all the properties before the data is returned
        var robot = SKSpriteNode()
        
        //Will set the images for the sprite from the running atlas
        robot = SKSpriteNode(imageNamed: runningAtlas.textureNames[0])
        
        //Setting the position
        robot.anchorPoint = CGPointMake(0.5, 0.5)
        robot.size = CGSize(width: 140, height: 140)
        robot.position = CGPoint(x: 200, y: 300)
        robot.zPosition = 5
        robot.setScale(0.8)
       
        //Making the physics body around the robot setting it to dynamic and not allowing rotation
        robot.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 100))
        robot.physicsBody?.dynamic = true
        robot.physicsBody?.allowsRotation = false
       
        //Setting resistance and bounce to 0
        robot.physicsBody?.restitution = 0.0
        robot.physicsBody?.friction = 0.0
        robot.physicsBody?.angularDamping = 0.0
        robot.physicsBody?.linearDamping = 0.0
        
        //Assigning constants to determine collisions
        robot.physicsBody?.categoryBitMask = CharacterCategory
        robot.physicsBody?.collisionBitMask = WallCategory | PlatformCategory
        robot.physicsBody?.contactTestBitMask = WallCategory | PlatformCategory
        
        //Will return robot
        return robot
        
    }
    
    
    
}
