//
//  Post.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Offers {
    private var _offerRef: FIRDatabaseReference
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Offer Information
    
    private var _offerKey: String!
    private var _offerUser: String!
    private var _offerTitle: String!
    private var _offerText: String!
    private var _offerChecked: String!
    private var _offerProfileImage: String!
    private var _offerUID: String!
    private var _offerAccepted: String!
    private var _offerDeclined: String!
    private var _offerRating: String!
    private var _offerDate: String!
    private var _offerStatus: String!
    private var _listingKey: String!
    private var _archieved: String!
    
    private var _recieverUsername: String!
    private var _recieverUID: String!
    private var _feedbackLeft: String!
    private var _recieverImage: String!
  
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Offer Getters
    
    var offerKey: String {
        return _offerKey
    }
    
    var offerUser: String {
        return _offerUser
    }
    
    var offerTitle: String {
        return _offerTitle
    }
    
    var offerText: String {
        return _offerText
    }
    
    var offerChecked: String {
        return _offerChecked
    }
    
    var offerProfileImage: String {
        return _offerProfileImage
    }
    
    var offerUID: String {
        return _offerUID
    }
    
    var offerAccepted: String {
        return _offerAccepted
    }
    
    var offerDeclined: String {
        return _offerDeclined
    }
    
    var offerRating: String {
        return _offerRating
    }
    
    var offerDate: String {
        return _offerDate
    }
    
    var offerStatus: String {
        return _offerStatus
    }
    
    var recieverUsername: String {
        return _recieverUsername
    }
    
    var recieverImage: String {
        return _recieverImage
    }
    var listingKey: String {
        return _listingKey
    }
    var recieverUID: String {
        return _recieverUID
    }
    
    var feedbackLeft: String {
        return _feedbackLeft
    }
    
    var archieved: String {
        return _archieved
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
// Initialize the new offer
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._offerKey = key
        
        // Within the post, or Key, the following properties are children
        
        if let offerU = dictionary["senderUsername"] as? String {
            self._offerUser = offerU
        }
        
        if let offerT = dictionary["listingTitle"] as? String {
            self._offerTitle = offerT
        }
        
        if let offerD = dictionary["offerText"] as? String {
            self._offerText = offerD
        }
        
        if let offerC = dictionary["offerChecked"] as? String {
            self._offerChecked = offerC
        }
        
        if let offerP = dictionary["currentProfileImage"] as? String {
            self._offerProfileImage = offerP
        }
        
        if let offerU = dictionary["senderUID"] as? String {
            self._offerUID = offerU
        }
        
        if let offerA = dictionary["offerAccepted"] as? String {
            self._offerAccepted = offerA
        }
        
        if let offerD = dictionary["offerDeclined"] as? String {
            self._offerDeclined = offerD
        }
        
        if let offerRA = dictionary["senderRating"] as? String {
            self._offerRating = offerRA
        }
        
        if let offerDA = dictionary["offerDate"] as? String {
            self._offerDate = offerDA
        }
        
        if let offerST = dictionary["offerStatus"] as? String {
            self._offerStatus = offerST
        }
        
        if let recieverIM = dictionary["recieverImage"] as? String {
            self._recieverImage = recieverIM
        }
        
        if let recieverUN = dictionary["recieverUsername"] as? String {
            self._recieverUsername = recieverUN
        }
        
        if let listingK = dictionary["listingKey"] as? String {
            self._listingKey = listingK
        }
        
        if let recieverK = dictionary["recieverUID"] as? String {
            self._recieverUID = recieverK
        }
        
        if let feedbackL = dictionary["feedbackLeft"] as? String {
            self._feedbackLeft = feedbackL
        }
        
        if let archievedO = dictionary["archieved"] as? String {
            self._archieved = archievedO
        }
        
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
        
    // The above properties are assigned to their key.
        self._offerRef = sendOfferRef
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}