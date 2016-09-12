//
//  CustomChatTableCell.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/13/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase

class CustomChatTableCell: UITableViewCell {
    
 //Variables 
    var imgString : String = ""
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var newIndicator: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Creating table view cells  "users\(withUserId)"
    func tableConfig(_ recent : NSDictionary){

        //Setting thread details
        let withUsername = (recent.object(forKey: "withUserUsername") as? String)!
        let listingTitle = (recent.object(forKey: "lastMessage") as? String)!
        let dateString = (recent.object(forKey: "date") as? String)!
        let pImg : String = (recent.object(forKey: "usersProfileImage") as? String)!
        
        userName.text = withUsername
        profileImage.image = decodeString(pImg)
        post.text = listingTitle
        
        //Setting timestamp
        let date = dateFormatter().date(from: dateString)
        let seconds = Date().timeIntervalSince(date!)
        timeStamp.text = elapsedTime(seconds)
        
    }
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
