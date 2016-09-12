//
//  BlockedUsersTableCell.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/22/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit

class BlockedUsersTableCell: UITableViewCell {

//Variables
     var blocked: BloackedUsersObject!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Creating table view cells
    func tableConfig(_ blocked : BloackedUsersObject){
        //Setting blocked object
        self.blocked = blocked
        
        //Setting image to blocked users image and username to blocked users name
        profileImage.image = decodeString(blocked.blockedUserImage)
        userName.text = blocked.blockedUser
        
        //Seting time stamp from when the user has been blocked
        let date = dateFormatter().date(from: blocked.date)
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
