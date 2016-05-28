//
//  CreditsScene.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/24/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation

import SpriteKit

class CreditsScene: SKScene {
    
    //Sprites for the credits and the back button to go back to the main menu
    var credits = SKSpriteNode()
    var  backButton = SKSpriteNode()
   
    
    override func didMoveToView(view: SKView) {
        //Setting Sprites
        backButton = UIObjects.back()
        credits = UIObjects.creditScreen()
        
        //Setting backbutton position and scale
        if checkDevice() {
            backButton.position = CGPointMake(self.frame.minX + 100, self.frame.maxY - 80)
        } else {
            backButton.position = CGPointMake(self.frame.minX + 100, self.frame.maxY - 170)
        }
        backButton.setScale(0.15)
        
        //Adding children
        self.addChild(credits)
        self.addChild(backButton)
    }
    
    //Touches began for the back button
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if let name = touchedNode.name
            {
                //Will open the Start scene
                if name == "back" {
                    let startScene = StartScene(size: self.size)
                    startScene.scaleMode = SKSceneScaleMode.AspectFill
                    let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                    self.view?.presentScene(startScene, transition:  transition)
                    
                }
                

            }
        }
        
    }
    
    //Will check if the device is an ipad
    func checkDevice() -> Bool{
        return (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
}