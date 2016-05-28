//
//  EditViewViewController.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/25/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit
import CoreData

class EditViewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var existingItem : NSManagedObject!
    var categories = ["Burgers","Cakes","Pies","Salads", "Sandwiches", "Soups" ]
    var value : Int = 0
    var source : Bool = true
    var myImage : UIImage = UIImage()
    var current : Int = Int()
    
    var currentName: String = String()
    var currentCat : String = String()
    var currentIngredients : String = String()
    var currentDirections : String = String()
    var currentImage : NSData = NSData()
    var decodedimage: UIImage = UIImage()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editCategoryLabel: UILabel!
    
    @IBOutlet weak var editIngredients: UITextView!
    @IBOutlet weak var editDirections: UITextView!
    
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var done: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
   
    //IBAction to display the camera
    @IBAction func camera(sender: UIButton)
    {
        let controller : UIImagePickerController = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        source = false
        
        self.presentViewController(controller, animated:true, completion:nil)
    }
    
    //IBAction to display the gallery
    @IBAction func gallery(sender: UIButton)
    {
        let controller : UIImagePickerController = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        self.presentViewController(controller, animated:true, completion:nil)
        
    }
    
    @IBAction func done(sender: UIButton)
    {
        //Hides all contents of the image picker
        //Also sets the category label to the value of the image picker
        done.hidden = true
        cancel.hidden = true
        editCategoryLabel.text = categories[value]
        
        picker.hidden = true
    }
    
    @IBAction func cancel(sender: UIButton)
    {
        //Hides all contents of the image picker
        picker.hidden = true
        cancel.hidden = true
        done.hidden = true
    }
    
    
    @IBAction func showPicker(sender: UIButton)
    {
        //Shows the image picker
        picker.hidden = false
        cancel.hidden = false
        done.hidden = false
    }
    @IBAction func saveEdit(sender: UIBarButtonItem)
    {
        //Calls the save edit function to set all the new information to the recipe
        saveEdit(editName.text!, ingredients: editIngredients.text, directions: editDirections.text, category: editCategoryLabel.text!, photo: currentImage)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //Sets all the labels, textfields, textviews and the image to the existing recipes information
        self.editName.text = currentName
        self.editCategoryLabel.text = currentCat
        decodedimage = UIImage(data: currentImage)!
        self.editImage.image = decodedimage as UIImage
        self.editIngredients.text = currentIngredients
        self.editDirections.text = currentDirections
    }

    override func viewDidLoad()
    {
        self.editDirections.delegate = self
        self.editName.delegate = self
        self.editIngredients.delegate = self
        self.navigationController?.navigationBarHidden = false
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    func saveEdit(name: String, ingredients: String, directions: String, category: String, photo: NSData)
    {
        //fetches current recipe information and sets the values of the edit screen as the new values for the recipe.
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        _ = NSEntityDescription.entityForName("Recipes", inManagedObjectContext: context)
        existingItem.setValue(name, forKey: "name")
        existingItem.setValue(ingredients, forKey: "ingredients")
        existingItem.setValue(directions, forKey: "directions")
        existingItem.setValue(category, forKey: "category")
        existingItem.setValue(photo, forKey: "photo")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        //sets titles for the picker values
        return categories[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        value = row
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //sets the image to the new image taken in the edit screen.
        let mediaDictionary : NSDictionary = info as NSDictionary
        myImage = mediaDictionary.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        current = 1
        currentImage = UIImageJPEGRepresentation(myImage, 0)!
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Moves the UI Up for the keyboar
    func textViewDidBeginEditing(textView: UITextView)
    {
        if (textView == editIngredients)
        {
            scrollView.setContentOffset(CGPoint(x: 0,y: 100),animated: true)
        }
        else
        {
        scrollView.setContentOffset(CGPoint(x: 0,y: 250),animated: true)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0),animated: true)
    }
    
    //Sets the textfields and views as firstresponders
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            editDirections.resignFirstResponder()
            editIngredients.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        editName.resignFirstResponder()
        
        return true
    }
}
