//
//  BackgroundMusic.swift
//  MGD1602
//
//  Created by Ian Dorosh on 2/4/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import Foundation
import AVFoundation

//Will play background music
class BackgroundMusic{
    
     class func setupAudioPlayerWithFile() -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource("background", ofType: "mp3")
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {

        }
        
        return audioPlayer
    }
    
}
