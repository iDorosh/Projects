//
//  BlockedUsers.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/22/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SCLAlertView

class BlockedUsers: UIViewController, UITableViewDataSource {
    
//Variables
    //Data
    var blockedUsers = [BloackedUsersObject]()
    var selectedBlock : BloackedUsersObject!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Outlets
    //Table View
    @IBOutlet weak var tabletView: UITableView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Actions
    //Back to Chat Action
    @IBAction func backToChat(_ segue: UIStoryboardSegue){}
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    override func viewWillAppear(_ animated: Bool) { self.tabBarController?.tabBar.isHidden = false }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        observeBlocked()
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Table View
        //Set Up Table View
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return blockedUsers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let blocked = blockedUsers[(indexPath as NSIndexPath).row]
            let cell : BlockedUsersTableCell = tableView.dequeueReusableCell(withIdentifier: "blockCell")! as! BlockedUsersTableCell
            
            cell.tableConfig(blocked)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            selectedBlock = blockedUsers[(indexPath as NSIndexPath).row]
            unblockuserAlert("Unblock User", subTitle: "Are your sure that you want to unblock this user?");    tableView.deselectRow(at: indexPath, animated: true)
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Alerts
    
        //Confirm unblock user
        func unblockuserAlert(_ title : String, subTitle : String){
            let alertView = SCLAlertView
            alertView.addButton("Unblock", target:self, selector:#selector(unBlockUser))
            alertView.addButton("Cancel"){alertView.dismiss(animated: true, completion: nil)}
            alertView.showCloseButton = false
            alertView.showWarning(title, subTitle: subTitle)
        }
    
        //User unblocked alert
        func unblocked(){
            let alertView = SCLAlertView
            alertView.addButton("OK"){}
            alertView.showCloseButton = false
            alertView.showWarning("Unblocked", subTitle: "This user has been unblocked")
        }
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Unblock user
        func unBlockUser(){
            let deleteRef = DataService.dataService.CURRENT_USER_REF.child("blockedUsers").child(selectedBlock.userKey)
            deleteRef.removeValue()
            unblocked()
        }
        
        //Get blocked users
        func observeBlocked() {
            DataService.dataService.CURRENT_USER_REF.child("blockedUsers").observe(.value, with: { snapshot in
                // 3
                self.blockedUsers = []
              
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots{
                        
                        
                        if let blockedDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let blocked = BloackedUsersObject(key: key, dictionary: blockedDictionary)
                            self.blockedUsers.insert(blocked, at: 0)
                        }
                    }
                    
                                }
                self.tabletView.reloadData()
            })
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

}
