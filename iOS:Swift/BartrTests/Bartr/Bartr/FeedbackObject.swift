//
//  FeedbackObject.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/20/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FeedbackObject {
    private var _feedbackRef: FIRDatabaseReference
    
//Feedback Information
    private var _feedbackKey: String!
    private var _feedbackUser: String!
    private var _feedbackTitle: String!
    private var _feedbackImage: String!
    private var _feedbackRating: String!
    private var _feedbackDate: String!
  
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Information Getters
    var feedbackKey: String {
        return _feedbackKey
    }
    
    var feedbackUser: String {
        return _feedbackUser
    }
    
    var feedbackTitle: String {
        return _feedbackTitle
    }
    
    var feedbackImage: String {
        return _feedbackImage
    }
    
    var feedbackRating: String {
        return _feedbackRating
    }
    
    var feedbackDate: String {
        return _feedbackDate
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
// Initialize new feedback
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._feedbackKey = key
        
        // Within the post, or Key, the following properties are children
        
        if let feedbackU = dictionary["feedbackUser"] as? String {
            self._feedbackUser = feedbackU
        }
        
        if let feedbackT = dictionary["feedbackTitle"] as? String {
            self._feedbackTitle = feedbackT
        }
        
        if let feedbackI = dictionary["feedbackImage"] as? String {
            self._feedbackImage = feedbackI
        }
        
        if let feedbackR = dictionary["feedbackRating"] as? String {
            self._feedbackRating = feedbackR
        }
        
        if let feedbackD = dictionary["feedbackDate"] as? String {
            self._feedbackDate = feedbackD
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        
    // The above properties are assigned to their key.
        self._feedbackRef = sendFeedbackRef
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
