//
//  Animations.swift
//  JKF
//
//  Created by Ian Dorosh on 3/7/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation
import SpriteKit

class animations {
    class func birdAnimations() -> (SKTextureAtlas, [SKTexture], SKTextureAtlas, [SKTexture], SKTextureAtlas, [SKTexture]){
        //eagle atlas is the set of images in a project folder and eagle array will be an array of those images
        var flyingAtlas = SKTextureAtlas()
        var flyingArray = [SKTexture]()
        
        //Setting eagle atlas to the proper atlas folder
        flyingAtlas = SKTextureAtlas(named: "flying.atlas")
        
        //For loop will run through the images and append them to the eagle array
        for i in 1...flyingAtlas.textureNames.count{
            let Name = "Flying_\(i).png"
            flyingArray.append(SKTexture(imageNamed: Name))
        }
        
        //eagle atlas is the set of images in a project folder and eagle array will be an array of those images
        var boostAtlas = SKTextureAtlas()
        var boostArray = [SKTexture]()
        
        //Setting eagle atlas to the proper atlas folder
        boostAtlas = SKTextureAtlas(named: "boost.atlas")
        
        //For loop will run through the images and append them to the eagle array
        for i in 1...boostAtlas.textureNames.count{
            let Name = "Boost_\(i).png"
            boostArray.append(SKTexture(imageNamed: Name))
        }
        
        //Died atlas is the set of images in a project folder and Died array will be an array of those images
        var diedAtlas = SKTextureAtlas()
        var diedArray = [SKTexture]()
        
        //Setting Died atlas to the proper atlas folder
        diedAtlas = SKTextureAtlas(named: "died.atlas")
        
        //For loop will run through the images and append them to the Died array
        for i in 1...diedAtlas.textureNames.count{
            let Name = "Faint_\(i).png"
            diedArray.append(SKTexture(imageNamed: Name))
        }
        
        return (flyingAtlas, flyingArray, diedAtlas, diedArray, boostAtlas, boostArray)
    }
}
