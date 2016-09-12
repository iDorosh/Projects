//
//  CustomTableCell.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CustomTableCell: UITableViewCell {
    

//Variables
    //Data
    var post: Post!
    var voteRef: FIRDatabaseReference!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bartrCompleteImg: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    
    //Confirgue cell
    func configureCell(_ post: Post) {
        //Set post to current post being created
        self.post = post
        self.price.text = post.postPrice
    
        // Set the labels and textView.
        self.user.text = post.username
        self.title.text = post.postTitle
        self.location.text = "\(post.postLocation)"
        self.type.text = post.postType
        
        //Get total view for the listing
        let totalViews : Int = post.postviews
        var viewsOrView : String = "View"
        if (totalViews > 1){
            viewsOrView = "Views"
            self.views.text = "\(totalViews) \(viewsOrView)"
        } else if totalViews == 0 {
            self.views.text = "No Views"
        } else {
            self.views.text = "\(totalViews) \(viewsOrView)"
        }
        
        print("\(post.postComplete) \(post.postTitle)")
        //Show complete or accepted label
        if post.postComplete {
            if !post.postFL {
                expirationDate.text = "Offer Accepted"
            } else {
                expirationDate.text = "Bartr Complete"
            }
        } else {
            expirationDate.text = getExperationDate(post.expireDate)
        }
        
        //Show complete or accepted view
        if post.postComplete{
            if post.postFL {
                bartrCompleteImg.text = "Bartr Complete"
            } else {
                bartrCompleteImg.text = "Offer Accepted"
            }
            bartrCompleteImg.isHidden = false
        } else {
            bartrCompleteImg.isHidden = true
        }

        
        //Set time stamp
        let dateString : String = post.postDate
        let date = dateFormatter().date(from: dateString)
        let seconds = Date().timeIntervalSince(date!)
        timeStamp.text = elapsedTime(seconds)
        
        //Images for user profile and listing image
        mainImage.image = decodeString(post.postImage)
        profileImg.image = decodeString(post.postUserImage)
      
        //Gets current rating
        updateFeedback(post.postUID)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Get current rating from firebase
    func updateFeedback(_ userName : String){
        DataService.dataService.USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if (snap.key == userName){
                        self.ratingView.rating = Float(snap.value!.object(forKey: "rating") as! String)!
                    }
                }
            }
            
        })
        
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}


