//
//  ChatViewController.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SCLAlertView

class Chat: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//Variables
    //Data
    var recents : [NSDictionary] = []
    var refresh : Timer = Timer()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Strings
    var currentUser : String = ""
    var senderUID : String = ""
    var chatRoomID : String = ""
    var selectedUID : String = ""
    var selectedUsename : String = ""
    var profileImage = String()
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlers
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var noMessages: UILabel!
    @IBOutlet weak var tabletView: UITableView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    
//Actions
    @IBAction func backToChat(_ segue: UIStoryboardSegue){}
    @IBAction func signinButton(_ sender: UIButton) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Load UI
    override func viewWillDisappear(_ animated: Bool) { refresh.invalidate() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewWillLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpViewWillAppear()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Setup UI
        //ViewWillApear
            func setUpViewWillAppear(){
                refresh = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector (timedUpdate), userInfo: nil, repeats: true)
                if (!signUpSkipped){
                    refresh.fire()
                }
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = false
            }
        
            //ViewWillLoad
            func setUpViewWillLoad(){
                if !signUpSkipped {
                    self.navigationController?.isNavigationBarHidden = true
                    self.tabBarController?.tabBar.isHidden = false
                    senderUID = UserDefaults.standard.value(forKey: "uid") as! String
                    DataService.dataService.CURRENT_USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                        self.currentUser = snapshot.value!.object(forKey: "username") as! String
                        
                    })
                    self.updateTableView()
                    UIApplication.shared.statusBarStyle = .default
                    
                } else {
                    signinView.isHidden = false
                    self.navigationController?.isNavigationBarHidden = true
                    self.tabBarController?.tabBar.isHidden = false
                }
            }

            //Get current users uid
            func getUID(){
                DataService.dataService.USER_REF.observe(FIRDataEventType.value, with: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshots {
                            let test = snap.value!.object(forKey: "username") as! String
                            if (test == self.currentUser){
                                self.senderUID = snap.key
                            }
                        }
                    }
                    
                })
            }
    
    
        //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
        //Set Up Table View
            //Number of rows in table
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if recents.count > 0 {
                    noMessages.isHidden = true
                } else {
                    noMessages.isHidden = false
                }
                return recents.count
            }
    
            //Return recent cell
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
                let cell : CustomChatTableCell = tableView.dequeueReusableCell(withIdentifier: "chatCell")! as! CustomChatTableCell
                let recent = recents[(indexPath as NSIndexPath).row]
                cell.tableConfig(recent)
                return cell
            }
    
            //Pass data to chat view controller
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
                let recent = recents[(indexPath as NSIndexPath).row]
                profileImage = (recent.object(forKey: "usersProfileImage") as? String)!
                for userId in recent["members"] as! [String] {
                    
                    if userId != UserDefaults.standard.value(forKey: "uid") as! String {
                        chatRoomID = (recent["chatRoomId"] as! String)
                        selectedUsename = (recent["withUserUsername"] as! String)
                        selectedUID = (recent["withUserUserId"] as! String)
                    }
                    
                }
                checkforBlock(selectedUID, recent: recent)
                tableView.deselectRow(at: indexPath, animated: true)
            }
    
            //Check if current user is block
    func checkforBlock(_ uid : String, recent : NSDictionary) {
                DataService.dataService.USER_REF.child(uid).child("blockedUsers").observeSingleEvent(of: .value, with: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        if snapshots.count > 0 {
                            for snap in snapshots{
                                
                                
                                if (snap.value as? Dictionary<String, AnyObject>) != nil {
                                    let key = snap.key
                                    if key == FIRAuth.auth()?.currentUser!.uid {
                                        self.blocked()
                                    } else {
                                        //Restarts chat if needed
                                        RestartRecentChat(recent)
                                        self.performSegue(withIdentifier: "GoToThread", sender: self)
                                        
                                    }
                                }
                            }
                        }else {
                            
                            //Restarts chat if needed
                            RestartRecentChat(recent)
                            self.performSegue(withIdentifier: "GoToThread", sender: self)
                        }
                    }
                })
                
            }

    
            func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
                
            }
    
            //Delete recents
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                let recent = recents[(indexPath as NSIndexPath).row]
                
                recents.remove(at: (indexPath as NSIndexPath).row)
                
                DeleteRecentItem(recent)
                
                tableView.reloadData()
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
        //Prepare for segue
    
        //Pass data to message view
        override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
          
            super.prepare(for: segue, sender: sender)
            let chatVc : ChatViewController = segue.destination as! ChatViewController
            chatVc.senderId = FIRAuth.auth()?.currentUser?.uid
            chatVc.senderDisplayName = ""
            chatVc.recieverUsername = selectedUsename
            chatVc.chatRoomID = chatRoomID
            chatVc.previous = "TBLV"
            chatVc.selectedImage = profileImage
            chatVc.recieverUID = selectedUID
           
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Get Recents on initial load
    
        func updateTableView(){
            ref.child("Recent").queryOrdered(byChild: "userId").queryEqual(toValue: senderUID).observe(.value, with: {
                snapshot in
                    self.recents.removeAll()
                
                if snapshot.exists() {
                    let sorted = (snapshot.value!.allValues as NSArray).sortedArray(using: [SortDescriptor(key : "date", ascending: false)])
                    
                    for recent in sorted {
                        self.recents.append(recent as! NSDictionary)
                    }
                }
                if self.recents.isEmpty {
                    self.tabletView.isHidden = true
                } else {
                   self.tabletView.isHidden = false
                }
                self.tabletView.reloadData()
            })
        }
        
        //Update recieved time
        func timedUpdate(){
            ref.child("Recent").queryOrdered(byChild: "userId").queryEqual(toValue: senderUID).observeSingleEvent(of: .value, with: {
                snapshot in
                self.recents.removeAll()
                
                if snapshot.exists() {
                    let sorted = (snapshot.value!.allValues as NSArray).sortedArray(using: [SortDescriptor(key : "date", ascending: false)])
                    
                    for recent in sorted {
                        self.recents.append(recent as! NSDictionary)
                    }
                }
                if self.recents.isEmpty {
                    self.tabletView.isHidden = true
                } else {
                    self.tabletView.isHidden = false
                }
                self.tabletView.reloadData()
            })
        }
    
    
        //Blocked alert
        func blocked(){
            let alertView = SCLAlertView
            alertView.addButton("OK"){}
            alertView.showCloseButton = false
            alertView.showWarning("Blocked", subTitle: "You have been blocked from this thread")
        }

//-----------------------------------------------------------------------------------------------------------------------------------------------------//

}
