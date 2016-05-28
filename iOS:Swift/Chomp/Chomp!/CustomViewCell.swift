//
//  CustomViewCell.swift
//  MDF2_Dorosh_Ian_Week2
//
//  Created by Ian Dorosh on 5/11/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit

class CustomViewCell: UICollectionViewCell
{
    
    //Custom cells for the collection view on the main screen
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
  
    
    func refreshCell(cellText: String, recipeImg: UIImage)
    {
        myLabel!.text = cellText
        picture!.image =  recipeImg as UIImage
        
        
    }
    
}
