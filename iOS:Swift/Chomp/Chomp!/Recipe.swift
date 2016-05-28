//
//  Recipe.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/17/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit
import UIKit
import MessageUI
import CoreData


class Recipe: UIViewController, MFMailComposeViewControllerDelegate
{
    
    var index: Int? = 0
    var existingItem : NSManagedObject!
    var imageData: NSData = NSData()
    

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeCat: UILabel!
    @IBOutlet weak var recipePic: UIImageView!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var ingredients: UITextView!
    
    @IBAction func homeButton(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func removeRecipe(sender: AnyObject)
    {
        
        // Alert to verify the deletion of a recipe
        let alertController = UIAlertController(title: "Remove Recipe", message: "Are you sure that you want to remove this recipe?", preferredStyle: .Alert)
        
        // Create the actions ok will delete the recipe and return to the main screen the cancel button will just close the alert view.
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext!
            context.deleteObject(allRecipes[self.index!] as NSManagedObject)
            allRecipes.removeAtIndex(self.index!)
            self.navigationController?.popToRootViewControllerAnimated(true)
            do {
                try context.save()
            } catch _ {
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //IBAction to display the email view when the compose button is selected.
    @IBAction func sendEmail(sender: UIBarButtonItem)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else
        {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem)
    {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        //Sets all the information for the labels textviews and the image under the recipe screen.
        let recipe = allRecipes[index!]
        recipeTitle.text = (recipe.valueForKey("name") as? String)!
        recipeCat.text = (recipe.valueForKey("category") as? String)!
        
        imageData = (recipe.valueForKey("photo") as? NSData)!
        let decodedimage = UIImage(data: imageData)!
        
        recipePic.image = decodedimage as UIImage
        ingredients.text = (recipe.valueForKey("ingredients") as? String)!
        directions.text = (recipe.valueForKey("directions") as? String)!
        
        
    }
    
    //Shows the email viewcontroller and sets the proper subject line and content under the email
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject(recipeTitle.text!+" Recipe")
        mailComposerVC.setMessageBody(ingredients.text+"\n\n"+directions.text, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        //Alert that will display if the email cannot be sent.
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
        
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //Sends all information to the edit screen.
        if (segue.identifier == "editSegue")
        {
            let editView : EditViewViewController  = segue.destinationViewController as! EditViewViewController
            editView.currentName = recipeTitle.text!
            editView.currentCat = recipeCat.text!
            editView.currentImage = imageData
            editView.currentIngredients = ingredients.text!
            editView.currentDirections = directions.text!
            editView.existingItem = existingItem
            
        }
    }

}
