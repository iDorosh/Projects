//
//  TImer.swift
//  Simple Addition

//
//  Created by Ian Dorosh on 2/19/16.
//  Copyright © 2016 Vulcan Studio. All rights reserved.

import CoreFoundation

class Timer {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        
        let num = duration!
        let rounded = round(num * multiplier) / multiplier
        
        return rounded
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
