//
//  IncomingMessage.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/25/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import FirebaseAuth


class IncomingMessage {
    
//Variables
//JSQMessagesVollectionView
    var collectionView : JSQMessagesCollectionView
   
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Collection view to display all the outgoing and incoming messages
    init(collectionView_: JSQMessagesCollectionView) {
        collectionView = collectionView_
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    
    //Creat a message to display in collection view
    func createMessage(_ dictionary : NSDictionary) -> JSQMessage? {
        var message: JSQMessage?
        let type = dictionary["type"] as? String
        
        //Checks if message is a text or an image
        if type == "text" {
            message = createTextMessage(dictionary)
        }
       
        if type == "picture" {
            message = createPictureMessage(dictionary)
        }
        
        if let mes = message {
            return mes
        }
        
        return nil
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //If messsage is text it will create a simple text bubble
        func createTextMessage(_ item: NSDictionary) -> JSQMessage {
            let name = item["senderName"] as? String
            let userId = item["senderId"] as? String
            let date = dateFormatter().date(from: (item["date"] as? String)!)
            let text = item["message"] as? String
            
            return JSQMessage(senderId: userId, senderDisplayName: name, date: date, text: text)
            
        }
    
    //Check if message is outgoing
        func returnOutgoingStatusFromUser(_ senderId: String) -> Bool {
            if senderId == FIRAuth.auth()?.currentUser!.uid {
                return true
            } else {
                return false
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //If message is a image it will create a image bubble
        func createPictureMessage(_ item : NSDictionary) -> JSQMessage {
            let name = item["senderName"] as? String
            let userId = item["senderId"] as? String
            let date = dateFormatter().date(from: (item["date"] as? String)!)
            let mediaItem = JSQPhotoMediaItem(image : nil)
            
            mediaItem?.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusFromUser(userId!)
            imageFromData(item) { (image: UIImage?) -> Void in
                mediaItem?.image = image
                self.collectionView.reloadData()
            }
            
            return JSQMessage(senderId: userId, senderDisplayName: name, date: date, media: mediaItem)
            
        }
    
    //Will decode the string into a image
        func imageFromData(_ item : NSDictionary, result : (image : UIImage?) -> Void) {
            var image : UIImage?
            let imageString = item["picture"] as? String
            
            image = decodeString(imageString!)
            
            result(image : image)
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
