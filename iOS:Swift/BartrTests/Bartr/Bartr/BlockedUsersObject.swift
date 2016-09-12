//
//  BlockedUsersObject.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/26/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class BloackedUsersObject {
    private var _blockedRef: FIRDatabaseReference
    
//Blocked Users Information
    private var _userKey: String!
    private var _blockedUser: String!
    private var _blockedUserImage: String!
    private var _date : String!

//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Blocked Users Getters
    var userKey: String {
        return _userKey
    }
    
    var blockedUser: String {
        return _blockedUser
    }
    
    var blockedUserImage: String {
        return _blockedUserImage
    }
    
    var date: String {
        return _date
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
// Initialize the new blockedUser
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._userKey = key
        
        // Within the post, or Key, the following properties are children
        
        if let blockedU = dictionary["blockedUser"] as? String {
            self._blockedUser = blockedU
        }
        
        if let blockedI = dictionary["blockImage"] as? String {
            self._blockedUserImage = blockedI
        }
        
        if let blockedD = dictionary["date"] as? String {
            self._date = blockedD
        }
   
        // The above properties are assigned to their key.
        self._blockedRef = blockedUserRef
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
}
