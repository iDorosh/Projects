//
//  Objects.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/3/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation
import SpriteKit

//Class that will load all my textures
class Animation{
    
    //getRobot is a set of images that will make the default running robot
    class func getRobot() -> ([SKTexture], SKTextureAtlas ){
        
        //Robot atlas is the set of images in a project folder and Robot array will be an array of those images
        var robotAtlas = SKTextureAtlas()
        var robotArray = [SKTexture]()
        
        //Setting robot atlas to the proper atlas folder
        robotAtlas = SKTextureAtlas(named: "robot")
        
        //For loop will run through the images and append them to the robot array
        for i in 1...robotAtlas.textureNames.count{
            let Name = "Run_\(i).png"
            robotArray.append(SKTexture(imageNamed: Name))
        }
        
        //Will return the atlas and array back to GameScene
        return (robotArray, robotAtlas)
        
    }
  
    //getJump is a set of images that will make the robot jump
    class func getJump() -> ([SKTexture], SKTextureAtlas ){
        
        //Jump atlas is the set of images in a project folder and Jump array will be an array of those images
        var jumpAtlas = SKTextureAtlas()
        var jumpArray = [SKTexture]()
        
        //Setting Jump atlas to the proper atlas folder
        jumpAtlas = SKTextureAtlas(named: "jump")
    
        //For loop will run through the images and append them to the jump array
        for i in 1...jumpAtlas.textureNames.count{
            let Name = "Jump_\(i).png"
            jumpArray.append(SKTexture(imageNamed: Name))
    
        }
        
        //Will return the atlas and array back to GameScene
        return (jumpArray, jumpAtlas)
    }
    
    
    //getSlide is a set of images that will make the robot slide
    class func getSlide() -> ([SKTexture], SKTextureAtlas ){
        
        //Slide atlas is the set of images in a project folder and Slide array will be an array of those images
        var slideAtlas = SKTextureAtlas()
        var slideArray = [SKTexture]()
        
        //Setting Slide atlas to the proper atlas folder
        slideAtlas = SKTextureAtlas(named: "slide")
        
        //For loop will run through the images and append them to the Slide array
        for i in 1...slideAtlas.textureNames.count{
            let Name = "Slide_\(i).png"
            slideArray.append(SKTexture(imageNamed: Name))
        }
        
        //Will return the atlas and array back to GameScene
        return (slideArray, slideAtlas)
    }
    
    
    //getDied is a set of images that will make the robot fall down
    class func getDied() -> ([SKTexture], SKTextureAtlas ){
        
        //Died atlas is the set of images in a project folder and Died array will be an array of those images
        var diedAtlas = SKTextureAtlas()
        var diedArray = [SKTexture]()
        
        //Setting Died atlas to the proper atlas folder
        diedAtlas = SKTextureAtlas(named: "died.atlas")
        
        //For loop will run through the images and append them to the Died array
        for i in 1...diedAtlas.textureNames.count{
            let Name = "Dead_\(i).png"
            diedArray.append(SKTexture(imageNamed: Name))
        }
        
        //Will return the atlas and array back to GameScene
        return (diedArray, diedAtlas)
    }
    
    
    
    
    
}