//
//  StartScene.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/22/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation

import SpriteKit

class StartScene: SKScene {
    
    //Sprites for the start menu playbutton and credits button
    var start = SKSpriteNode()
    var  playButton = SKSpriteNode()
    var  creditsButton = SKSpriteNode()
        
    override func didMoveToView(view: SKView) {
        //Setting sprites
        start = UIObjects.startScreen()
        playButton = UIObjects.playButton()
        creditsButton = UIObjects.creditsButton()
        
        //Setting button position on the main menu
        playButton.position = CGPointMake(self.frame.midX - 125, self.frame.midY - 60)
        creditsButton.position = CGPointMake(self.frame.midX + 125, self.frame.midY - 60)
       
        //Adding children to the main screen
        self.addChild(start)
        self.addChild(playButton)
        self.addChild(creditsButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if let name = touchedNode.name
            {
                //Will open the game scene when the play button is clicked
                if name == "playButton" {
                    let gameScene = GameScene(size: self.size)
                    gameScene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
                    self.view?.presentScene(gameScene, transition:  transition)

                }
                
                //Will open the credits scene whe the credits button is clicked
                if name == "creditsButton" {
                    let creditsScene = CreditsScene(size: self.size)
                    creditsScene.scaleMode = SKSceneScaleMode.AspectFill
                    let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
                    self.view?.presentScene(creditsScene, transition: transition)
                    
                }

            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}