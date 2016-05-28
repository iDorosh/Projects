//
//  Sprites.swift
//  JKF
//
//  Created by Ian Dorosh on 3/7/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation
import SpriteKit

class sprites{
    
    //Returns the start screen instructions
    class func startInstructions(position : CGPoint) -> (SKSpriteNode, SKSpriteNode){
        var start = SKSpriteNode()
        var boostButton = SKSpriteNode()
        
        //Will set the sprite to the image "start" in assets
        start = SKSpriteNode(imageNamed: "Start")
        start.anchorPoint = CGPointMake(0.5,0.5)
        start.setScale(0.8)
        start.position = position
        start.zPosition = 8
        
        //Will set the sprite to image "Boost" in assets
        boostButton = SKSpriteNode(imageNamed: "Boost")
        boostButton.anchorPoint = CGPointMake(0.5, 0.5)
        boostButton.position = position
        boostButton.zPosition = 9
        boostButton.setScale(0.2)
        boostButton.name = "boost"
        
        return (start, boostButton)
    }
    
    //Returns the main menu
    class func mainMenu(position : CGPoint) -> (SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode){
        var bg = SKSpriteNode()
        var playButton = SKSpriteNode()
        var gcButton = SKSpriteNode()
        var loading = SKSpriteNode()
        
        //Will set the sprite to the image "start" in assets
        bg = SKSpriteNode(imageNamed: "StartScreen")
        bg.anchorPoint = CGPointMake(0.5,0.5)
        bg.setScale(0.48)
        bg.position = position
        bg.zPosition = 8
        
        //Will set the sprite to image "play" in assets
        playButton = SKSpriteNode(imageNamed: "play")
        playButton.anchorPoint = CGPointMake(0.5, 0.5)
        playButton.position = position
        playButton.zPosition = 9
        playButton.setScale(0.17)
        playButton.name = "play"
        
        
        //Will set the sprite to image "gc" in assets
        gcButton = SKSpriteNode(imageNamed: "gc")
        gcButton.anchorPoint = CGPointMake(0.5, 0.5)
        gcButton.position = position
        gcButton.zPosition = 200
        gcButton.setScale(0.17)
        gcButton.name = "gc"
        
        //Will set the sprite to image "play" in assets
        loading = SKSpriteNode(imageNamed: "loading")
        loading.anchorPoint = CGPointMake(0.5, 0.5)
        loading.position = position
        loading.zPosition = 9
        loading.setScale(0.2)
        loading.name = "loading"
        
        
        return (bg, playButton, gcButton, loading)
    }
    
    //Returns the gameover screen
    class func gameOverScreen(position : CGPoint) -> (SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode){
        var results = SKSpriteNode()
        var replayButton = SKSpriteNode()
        var new = SKSpriteNode()
        var secondChanceButton = SKSpriteNode()
        var menuButton = SKSpriteNode()
        
        //Will set the sprite to image "replay" in assets
        results = SKSpriteNode(imageNamed: "Replay")
        results.anchorPoint = CGPointMake(0.5, 0.5)
        results.position = position
        results.zPosition = 7
        results.setScale(0.8)
        
        //Will set the sprite to image "replay" in assets
        replayButton = SKSpriteNode(imageNamed: "ReplayButton")
        //Setting position
        replayButton.anchorPoint = CGPointMake(0.5, 0.5)
        replayButton.position = position
        replayButton.zPosition = 100
        replayButton.name = "replayButton"
        replayButton.setScale(0.17)
        
        //Will set the sprite to image "menu" in assets
        menuButton = SKSpriteNode(imageNamed: "menu")
        //Setting position
        menuButton.anchorPoint = CGPointMake(0.5, 0.5)
        menuButton.position = position
        menuButton.zPosition = 100
        menuButton.name = "menu"
        menuButton.setScale(0.17)
        
        //Will set the sprite to image "secondChance" in assets
        secondChanceButton = SKSpriteNode(imageNamed: "SecondChance")
        secondChanceButton.anchorPoint = CGPointMake(0.5, 0.5)
        secondChanceButton.position = position
        secondChanceButton.zPosition = 9
        secondChanceButton.setScale(0.17)
        secondChanceButton.name = "secondChance"
        
        //Will set the sprite to image "replay" in assets
        new = SKSpriteNode(imageNamed: "New")
        //Setting position
        new.anchorPoint = CGPointZero
        new.position = position
        new.zPosition = 30
        
        
        return (results, replayButton, new, secondChanceButton, menuButton)
    }
    
    //Returns the gameover screen
    class func gameScene(position : CGPoint) -> (SKSpriteNode, SKSpriteNode, SKSpriteNode){
        var background = SKSpriteNode()
        var ground = SKSpriteNode()
        var forground = SKSpriteNode()
        
        background = SKSpriteNode(imageNamed: "lightBG")
        background.anchorPoint = CGPointZero
        background.position = position
        background.zPosition = 1
        if (sprites.test()){
            background.setScale(0.6)
        } else {
        background.setScale(0.35)
        }
        
        
        //Will set the sprites to the image "ground" in assets
        ground = SKSpriteNode(imageNamed: "Ground")
        //Setting the positions of both sprites
        ground.anchorPoint = CGPointZero
        ground.position = position
        ground.zPosition = 4
        if (sprites.test()){
            ground.setScale(0.6)
        } else {
            ground.setScale(0.35)
        }
        
        
        
        //Will set the sprites to the image "ground" in assets
        forground = SKSpriteNode(imageNamed: "lightMid")
        //Setting the positions of both sprites
        forground.anchorPoint = CGPointZero
        forground.position = position
        forground.zPosition = 2
        if (sprites.test()){
            forground.setScale(0.6)
            forground.position.y = 0
        } else {
            forground.setScale(0.35)
        }
        
        
        return (background, ground, forground)
    }
    
    //Returns the eagle character
    class func eagle(atlas : SKTextureAtlas) -> SKSpriteNode{
        //Constants that will be used for determining collistions
        let CharacterCategory   : UInt32 = 0x1 << 1
        let PlatformCategory    : UInt32 = 0x1 << 2
        let ObstacleCategory    : UInt32 = 0x1 << 3
        let CeilingCategory     : UInt32 = 0x1 << 4
        
        var eagle = SKSpriteNode()
        eagle = SKSpriteNode()
    
        //Will set the images for the sprite from the flying atlas
        eagle = SKSpriteNode(imageNamed: atlas.textureNames[0])
        
        //Setting the position
        eagle.size = CGSize(width: 80, height: 100)
        eagle.position = CGPoint(x: 200, y: 400)
        eagle.zPosition = 5
        
        //Making the physics body around the eagle setting it to dynamic and not allowing rotation
        eagle.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        eagle.physicsBody?.dynamic = false
        eagle.physicsBody?.allowsRotation = true
        
        //Setting resistance and bounce to 0
        eagle.physicsBody?.restitution = 0.0
        eagle.physicsBody?.friction = 0.0
        eagle.physicsBody?.angularDamping = 0.0
        eagle.physicsBody?.linearDamping = 0.0
        
        //Assigning constants to determine collisions
        eagle.physicsBody?.categoryBitMask = CharacterCategory
        eagle.physicsBody?.collisionBitMask = ObstacleCategory | PlatformCategory | CeilingCategory
        eagle.physicsBody?.contactTestBitMask = ObstacleCategory | PlatformCategory | CeilingCategory
        return eagle
    }
    

    class func test() -> Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    }
    
    
}