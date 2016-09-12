//
//  MessageThread.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/17/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SCLAlertView
import ALCameraViewController

class ChatViewController: JSQMessagesViewController {

    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Variables
    //Data
    var messageDictionary: NSMutableDictionary = [:]
    var objects : [NSDictionary] = []
    var loaded : [NSDictionary] = []
    var recent : NSDictionary?
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Refrences 
    let ref2 = ref.child("messages")
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var recieverUsername : String = ""
    var recieverUID : String = ""
    var senderUID : String = ""
    var selectedTitle : String = ""
    var selectedImage : String = ""
    var selectedUser : String = ""
    var currentUser : String = ""
    var previousScreen: String?
    var avatar : String = String()
    var currentAvatar : String = String()
    var currentAvatarImage : UIImage?
    var chatRoomID : String = ""
    var previous : String = ""
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Booleans
    var isBlocked : Bool = false
    var otherBlocked : Bool = false
    var initialLoadComplete : Bool = false
    var accepted = false
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    var previousProfile: Bool = false
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //UIImages
    var sendImage : UIImage?
    var avatarImage : UIImage?
    var capturedImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //JSQMessage
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var messages = [JSQMessage]()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var blockOrunBlock: UIBarButtonItem!

    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        acceptedMessageSent()
    }
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Load UI
        override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
    
    }
        override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated) }
        override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setUpViewDidLoad()
        }
        
        func setUpViewDidLoad(){
            if previousScreen == "accepted"{
                //Set status and navigation bar
                UIApplication.shared.statusBarStyle = .default
            
                //Set up back button
                let myBackButton:UIButton =
                    UIButton(type: UIButtonType.custom) as UIButton
                myBackButton.addTarget(self, action: #selector(acceptedMessageSent), for: UIControlEvents.touchUpInside)
                myBackButton.setTitle("Back", for: UIControlState())
                myBackButton.setTitleColor(hexStringToUIColor("#2b3146"), for: UIControlState())
                myBackButton.sizeToFit()
                let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
                self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
            }
            
            //Set navigation title to reciever name
            title = recieverUsername
            
            //Set up bubble color
            setupBubbles()
            //Check if you are blocked
            checkforBlock()
            //Check if you blocked the other user
            otherIsBlocked()
            
            //creating a collection view for the messages
            collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 30, height: 30)
            collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 30,height: 30)
            
            //Create a new chat room when coming from the details screen
            if previousScreen != "TBLV"{
                chatRoomID = startChat((FIRAuth.auth()?.currentUser?.uid)!, user2: recieverUID)
            }
            
            UpdateCount(chatRoomID)
            
            //Check for messages
            observeMessages()
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Messages
    
        //Check if the message has been accepted and bring them back to the details screen
        func acceptedMessageSent(){
            if accepted {
                if previousProfile {
                    performSegue(withIdentifier: "BackToProfileSegue", sender: self)
                } else {
                    performSegue(withIdentifier: "BackToPost", sender: self)
                }
                
            } else {
                navigationController?.popViewController(animated: true)
            }

        }

        //Add messages to collection view
        override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                     messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
        }
    
        //Get messages count for the collection view
        override func collectionView(_ collectionView: UICollectionView,
                                     numberOfItemsInSection section: Int) -> Int {
            return messages.count
        }
    
        //Setup bubble collor for incoming and out going text
        private func setupBubbles() {
            let factory = JSQMessagesBubbleImageFactory()
            outgoingBubbleImageView = factory!.outgoingMessagesBubbleImage(
                with: hexStringToUIColor("#f27163"))
            incomingBubbleImageView = factory!.incomingMessagesBubbleImage(
                with: hexStringToUIColor("#2b3146"))
        }
    
        //Decide if the message is incoming or out going
        override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                     messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = messages[indexPath.item]
            if message.senderId == senderId {
                return outgoingBubbleImageView
            } else { // 3
                return incomingBubbleImageView
            }
        }
    
        //Set proper image depending on if the message is incoming or outgoing
        override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                     avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
            
            let message = messages[indexPath.item]
            if message.senderId == senderId {
                return JSQMessagesAvatarImageFactory.avatarImage(with: decodeString(currentUserImageString), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault));
            } else {
                return JSQMessagesAvatarImageFactory.avatarImage(with: decodeString(selectedImage), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault));
            }
            
        }
    
        //Decode avatar images
        func decodeString(_ img : String) -> UIImage{
            let decodedData = Data(base64Encoded: img, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            
            let decodedimage = UIImage(data: decodedData!)
            
            return decodedimage! as UIImage
        }
        
        //Add message to collection view
        func addMessage(_ id: String, text: String) {
            let message = JSQMessage(senderId: id, displayName: "User", text: text)
            messages.append(message!)
        }
    
        //Open camera when the attachment button is clicked
        override func didPressAccessoryButton(_ sender: UIButton!) {
            openCamera()
        }
    
        //Send button will check for blocked and then create a new message and update recents with the text and date
        //Will give the user an alert if they blocked the other user or if they have been blocked
        override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!,
                   senderDisplayName: String!, date: Date!) {
            if !isBlocked{
                if !otherBlocked {
                    if text != "" {
                        sendMessage(text, date: date, picture: nil, location: nil)
                        UpdateRecents(self.chatRoomID, lastMessage: text)
                    }
                } else {
                    self.view.endEditing(true)
                    otherUserIsBlocked()
                }
            } else {
                self.view.endEditing(true)
                blocked()
            }
        }
    
        //Send message
        func sendMessage(_ text : String?, date : Date, picture: UIImage?, location: String?){
            var outgoingMessage = OutgoingMessage?()
            
            //If out going message is text
            if let text = text {
                outgoingMessage = OutgoingMessage(message: text, senderId: senderId, senderName: currentUsernameString, date: date, status: "Delivered", type: "text")
            }
            
            //If out going message is a picture
            if let pic = picture {
                let imageData = UIImageJPEGRepresentation(pic, 0.1)
                
                outgoingMessage = OutgoingMessage(message: "Picture", pictureData: imageData!, senderId: senderId, senderName: currentUsernameString, date: date, status: "Delivered", type: "picture")
            }
            
            //Finished sending
            finishSendingMessage()
            outgoingMessage!.sendMessage(chatRoomID, item: outgoingMessage!.messageDictionary)
        }
    
        //Add message to collection
        func insertMessages(){
            for item in loaded {
                insertMessage(item)
            }
        }
    
        //return incoming message
        func insertMessage(_ item : NSDictionary) -> Bool {
            let incomingMessage = IncomingMessage(collectionView_: self.collectionView)
            let message = incomingMessage.createMessage(item)
            objects.append(item)
            messages.append(message!)
            return incoming(item)
        }
    
        //Check if the message is incoming
        func incoming(_ item : NSDictionary) -> Bool {
            if self.senderId == item["senderId"] as! String {
                return false
            } else {
                return true
            }
        }
    
        //Check if message is outgoing
        func outgoing(_ item : NSDictionary) -> Bool {
            if self.senderId == item["senderId"] as! String {
                return true
            } else {
                return false
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Observer
    
        //Check recents for messages and load all of them into collectionview
        func observeMessages() {
            ref2.child(chatRoomID).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot!) in
                self.insertMessages()
                self.finishReceivingMessage(animated: true)
                self.initialLoadComplete = true
            }
            
            //Observe new messages after initial load
            ref2.child(chatRoomID).observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
                if snapshot.exists() {
                    let item = (snapshot.value as? NSDictionary)!
                    if self.initialLoadComplete {
                        let incoming = self.insertMessage(item)
                        if incoming {
                        }
                        self.finishReceivingMessage(animated: true)
                    } else {
                        self.loaded.append(item)
                    }
                }
            }
            
            
        }
    
        //Update recents
        func UpdateCount(_ chatRoomID : String){
            ref.child("Recent").queryOrdered(byChild: "chatRoomId").queryEqual(toValue: chatRoomID).observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.exists() {
                    for recent in snapshot.value!.allValues{
                        //Will update the recent for other user to display last text and update the time
                        if recent["userId"] as? String == FIRAuth.auth()?.currentUser!.uid {
                            let values = ["counter" : 0]
                            ref.child("Recent").child((recent["recentId"] as? String)!).updateChildValues(values as [NSObject : AnyObject])
                        }
                    }
                }
            })
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Creating Chatroom
        //Uses UIDs of both users to create a chat room. A reference will be create for both users which will allow one to restart the chat if the other has deleted their thread
        func startChat (_ user1 : String, user2: String) -> String {
            let userId1 = user1
            let userId2 = user2
            
            var chatRoomId : String = ""
            let value = userId1.compare(userId2).rawValue
            
            if value < 0 {
                chatRoomId = userId1 + userId2
            }else {
                chatRoomId = userId2 + userId1
            }
            
            let members = [userId1, userId2]
            createRecent(userId1, chatRoomId: chatRoomId, members: members, withUserUsername: selectedUser, withUseruserId: userId2, withTitle : selectedTitle, withPImage : selectedImage)
            
            createRecent(userId2, chatRoomId: chatRoomId, members: members, withUserUsername: currentUsernameString, withUseruserId: userId1, withTitle : selectedTitle, withPImage : currentUserImageString)
            
            return chatRoomId
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Opening custom CameraViewController
        func openCamera()
        {
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                if (image != nil){
                    //If user is not blocked or they havent blocked the other user then the picture message will be sent
                    //An alert will show if they have be blocked
                    if !self!.isBlocked {
                        if !self!.otherBlocked {
                            self?.sendMessage(nil, date: Date(), picture: image, location: nil)
                            UpdateRecents(self!.chatRoomID, lastMessage: "Image")
                        } else {
                            self!.view.endEditing(true)
                            self!.otherUserIsBlocked()
                        }
                    } else {
                        self!.view.endEditing(true)
                        self!.blocked()
                    }
                }
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
        
        //Opeing Library
        func openLibrary(){
            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled) { image, asset in
                //If user is not blocked or they havent blocked the other user then the picture message will be sent
                //An alert will show if they have be blocked
                if !self.isBlocked {
                    if !self.otherBlocked {
                        self.sendMessage(nil, date: Date(), picture: image, location: nil)
                        UpdateRecents(self.chatRoomID, lastMessage: "Image")
                    } else {
                        self.view.endEditing(true)
                        self.otherUserIsBlocked()
                       
                    }
                } else {
                    self.view.endEditing(true)
                    self.blocked()
                }
                self.dismiss(animated: true, completion: nil)
            }
            present(libraryViewController, animated: true, completion: nil)
        }
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Block User
        //Block user action
        @IBAction func blockUser(_ sender: UIBarButtonItem) {
            self.view.endEditing(true)
            if blockOrunBlock.title == "Block" {
                blockAlert("Block User", subTitle: "Are you sure that you would like to block this user?")
            } else {
                unblockAlert("Unblock User?", subTitle: "Are you sure you want to unblock this user?")
            }
        }

        //Check if current user is block
        func checkforBlock() {
            DataService.dataService.USER_REF.child(recieverUID).child("blockedUsers").observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    if snapshots.count > 0 {
                        for snap in snapshots{
                            
                            
                            if (snap.value as? Dictionary<String, AnyObject>) != nil {
                                let key = snap.key
                                if key == FIRAuth.auth()?.currentUser!.uid {
                                    self.isBlocked = true
                                    
                                } else {
                                    self.isBlocked = false
                                     
                                }
                            }
                        }
                    }else {
                        self.isBlocked = false
                    }
                }
            })

        }
    
        //Check if other user is blocked
        func otherIsBlocked() {
            DataService.dataService.CURRENT_USER_REF.child("blockedUsers").observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    if snapshots.count > 0 {
                        for snap in snapshots{
                            
                            
                            if (snap.value as? Dictionary<String, AnyObject>) != nil {
                                let key = snap.key
                                if key == self.recieverUID {
                                    self.otherBlocked = true
                                    self.blockOrunBlock.title = "Unblock"
                                } else {
                                    self.otherBlocked = false
                                    self.blockOrunBlock.title = "Block"
                                }
                            }
                        }
                        
                    }else {
                        self.blockOrunBlock.title = "Block"
                        self.otherBlocked = false
                    }
                }
            })
            
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts

        //Block User
        func blockAlert(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.addButton("Block", target:self, selector:#selector(blockUserPush))
            alertView.addButton("Cancel"){alertView.dismiss(animated: true, completion: nil)}
            alertView.showCloseButton = false
            alertView.showWarning(title, subTitle: subTitle)
        }
        
        //Unblock User
        func unblockAlert(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.addButton("Unblock", target:self, selector:#selector(unblockUserPush))
            alertView.addButton("Cancel"){alertView.dismiss(animated: true, completion: nil)}
            alertView.showCloseButton = false
            alertView.showWarning(title, subTitle: subTitle)
        }
        
        
        
        //Unblocked alert
        func unblocked(){
            let alertView = SCLAlertView
            alertView.addButton("OK"){}
            alertView.showCloseButton = false
            alertView.showWarning("Unblocked", subTitle: "This user has been unblocked")
        }

        //Blocked alert
        func blocked(){
            let alertView = SCLAlertView
            alertView.addButton("OK"){}
            alertView.showCloseButton = false
            alertView.showWarning("Blocked", subTitle: "You have been blocked from this thread")
        }
    
        //Blocked alert
        func otherUserIsBlocked(){
            let alertView = SCLAlertView
            alertView.addButton("Unblock") {self.unblockUserPush()
            self.unblocked()
            }
            alertView.addButton("Cancel"){}
            alertView.showCloseButton = false
            alertView.showWarning("User Blocked", subTitle: "Would you like to unblock this user?")
        }
    
        //User blocked from thread
        func blockUserfromThread(){
            let alertView = SCLAlertView
            alertView.addButton("Done"){}
            alertView.showCloseButton = false
            alertView.showWarning("User Blocked", subTitle: "You can unblock this user from the Block Users option in Profile")
        }
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase push
        //Unblock push
        func unblockUserPush(){
            let deleteRef = DataService.dataService.CURRENT_USER_REF.child("blockedUsers").child(recieverUID)
            deleteRef.removeValue()
            unblocked()
        }
        
        //Block user push
        func blockUserPush(){
            let itemRef = DataService.dataService.CURRENT_USER_REF.child("blockedUsers").child(recieverUID)
            let date = dateFormatter().string(from: Date())
            blockedUserRef = itemRef
            
            let blocked = [ // 2
                "blockedUser": recieverUsername,
                "blockImage" : avatar,
                "date" : date
            ]
            
            DataService.dataService.newBlocked(blocked)
            blockUserfromThread()
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

}
