//
//  UsersRecentFeedBackCell.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/23/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
class UsersRecentFeedBackCell: UITableViewCell {
    
    
//Variables
    //Data
    var feedback : FeedbackObject!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Creating table view cells
    func tableConfig(_ selectedFeedback : FeedbackObject){
        //Setting feedback object
        feedback = selectedFeedback
        
        //Setting images
        profileImage.image = decodeString(feedback.feedbackImage)
        userName.text = feedback.feedbackUser
        post.text = feedback.feedbackTitle
        
        //Setting timeStamp for recent Feedback
        let dateString : String = feedback.feedbackDate
        let date = dateFormatter().date(from: dateString)
        let seconds = Date().timeIntervalSince(date!)
        timeStamp.text = elapsedTime(seconds)
        
        //Set label for rating and set stars according to rating
        if Float(feedback.feedbackRating) > 1 {
            ratinglabel.text = "\(feedback.feedbackRating) stars"
        } else {
            ratinglabel.text = "\(feedback.feedbackRating) star"
        }
        rating.rating = Float(feedback.feedbackRating)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}
