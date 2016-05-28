//
//  StartScreen.swift
//  JKF
//
//  Created by Ian Dorosh on 3/16/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation

import SpriteKit
import GameKit

class StartScene: SKScene, GKGameCenterControllerDelegate {
    
    //Sprites for the start menu playbutton and credits button
    var bg = SKSpriteNode()
    var background = SKSpriteNode()
    var background2 = SKSpriteNode()
    var ground = SKSpriteNode()
    var ground2 = SKSpriteNode()
    var forground = SKSpriteNode()
    var forground2 = SKSpriteNode()
    
    var  playButton = SKSpriteNode()
    var  gcButton = SKSpriteNode()
    var  loading = SKSpriteNode()
    var loadScene = SKAction()
    var clickSound : SKAction!
    
    override func didMoveToView(view: SKView) {
        //Setting sprites
        bg = sprites.mainMenu(CGPointMake(frame.midX, frame.midY)).0
        playButton = sprites.mainMenu(CGPointMake(frame.midX - 120, frame.midY - 120)).1
        gcButton = sprites.mainMenu(CGPointMake(frame.midX + 120, frame.midY - 120)).2
        loading = sprites.mainMenu(CGPointMake(frame.midX, frame.midY)).3
        background = sprites.gameScene(CGPointMake(0, 140)).0
        background2 = sprites.gameScene(CGPointMake(background.size.width-1, 140)).0
        ground = sprites.gameScene(CGPointMake(0, 90)).1
        ground2 = sprites.gameScene(CGPointMake(ground.size.width-1, 90)).1
        forground = sprites.gameScene(CGPointMake(0, 65)).2
        forground2 = sprites.gameScene(CGPointMake(forground.size.width-1, 65)).2
        
        clickSound = (SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false))
        
        
        
        //Adding children to the main screen
        self.addChild(bg)
        self.addChild(background)
        self.addChild(background2)
        self.addChild(ground)
        self.addChild(ground2)
        self.addChild(forground)
        self.addChild(forground2)
        
        playButton.setScale(0.2)
        gcButton.setScale(0.2)
        self.addChild(playButton)
        self.addChild(gcButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if let name = touchedNode.name
            {
                //Will open the game scene when the play button is clicked
                if name == "play" {
                    
                    
                    runAction(clickSound)
                    loadScene = (SKAction.sequence([SKAction.runBlock(self.removeObjects), SKAction.waitForDuration(0.1)]))
                    
                    runAction(loadScene, completion: { 
                        self.showScene() 
                    })    
                }
                
                //Will open the game center
                if name == "gc" {
                    runAction(clickSound)
                    showLeader()
                }
                
            }
        }
        
    }
    
    func removeObjects(){
        self.addChild(loading)
        playButton.removeFromParent()
        gcButton.removeFromParent()
        bg.removeFromParent()
    }
    
    func showScene(){
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        
        let transition = SKTransition.doorsOpenHorizontalWithDuration(1.5)
        self.view?.presentScene(gameScene, transition:  transition)
    }
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        //Will set background and background 2 positions
        background.position = CGPoint(x: background.position.x - 0.5, y: background.position.y)
        background2.position = CGPoint(x: background2.position.x - 0.5, y: background2.position.y)
        
        //Will repostion the background back to the just off of the right side of the screen when it goes off the left side
        if (background.position.x < -background.size.width){
            background.position = CGPointMake(background2.position.x + background2.size.width, background.position.y)
        }
        
        // Will repsition the background 2 when it goes off of the left side of the screen
        if (background2.position.x < -background2.size.width){
            background2.position = CGPointMake(background.position.x + background.size.width, background2.position.y)
        }
        
        //Setting the ground postions
        ground.position = CGPoint(x: ground.position.x - 3, y: ground.position.y)
        ground2.position = CGPoint(x: ground2.position.x - 3, y: ground2.position.y)
        
        //Will reposition the ground when it goes off of the screen
        if (ground.position.x < -ground.size.width){
            ground.position = CGPointMake(ground2.position.x + ground2.size.width, ground.position.y)
        }
        
        //Will reposition the ground2 when if goes off of the screen
        if (ground2.position.x < -ground2.size.width){
            ground2.position = CGPointMake(ground.position.x + ground.size.width, ground2.position.y)
        }
        
        //Setting the forground postions
        forground.position = CGPoint(x: forground.position.x - 1, y: forground.position.y)
        forground2.position = CGPoint(x: forground2.position.x - 1, y: forground2.position.y)
        
        //Will reposition the forground when it goes off of the screen
        if (forground.position.x < -forground.size.width){
            forground.position = CGPointMake(forground2.position.x + forground2.size.width, forground.position.y)
        }
        
        //Will reposition the forground2 when if goes off of the screen
        if (forground2.position.x < -forground2.size.width){
            forground2.position = CGPointMake(forground.position.x + forground.size.width, forground2.position.y)
        }
    }
}
