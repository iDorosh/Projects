//
//  DataService.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DataService {
    static let dataService = DataService()
    
//References for Databases, Users and Posts
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _USER_REF = FIRDatabase.database().reference().child("users")
    private var _POST_REF = FIRDatabase.database().reference().child("posts")
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
//Reference Getters
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }

    var POST_REF: FIRDatabaseReference {
        return _POST_REF
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Gets current user
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let currentUser = _USER_REF.child(userID!)
        return currentUser
    }
    
    //Creates new user account triggered by register screen
    func createNewAccount(_ uid: String, user: Dictionary<String, AnyObject>) {
        USER_REF.child(uid).setValue(user)
    }
    
    //Creates a new post from information in the Summary.swift file
    func createNewPost(_ post: Dictionary<String, AnyObject>) {
        let firebaseNewPost = POST_REF.childByAutoId()
        firebaseNewPost.setValue(post)
    }
    
    //Creating a new offer
    func createNewOffer(_ offer: Dictionary<String, AnyObject>) {
        let firebaseNewPost = sendOfferRef
        firebaseNewPost.setValue(offer)
    }
    
    //Block user
    func newBlocked(_ blocked: Dictionary<String, AnyObject>) {
        let firebaseNewPost = blockedUserRef
        firebaseNewPost.setValue(blocked)
    }
    
    //Create new feedback
    func createNewFeedback(_ feedback: Dictionary<String, AnyObject>, id : String) {
        let firebaseNewPost = sendFeedbackRef
        firebaseNewPost.setValue(feedback)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
