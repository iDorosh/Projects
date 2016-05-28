//
//  CreateVC.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/18/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit
import CoreData
var allRecipes = [NSManagedObject]()
var ingredientsArray : [String] = [String]()

class CreateVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    
    var myImage : UIImage = UIImage()
    var source : Bool = true
    var value : Int = 0
    var categories = ["Burgers","Cakes","Pies","Salads", "Sandwiches", "Soups" ]
    var photoPicked = 0
   
    var combined : [String] = [String]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newDirections: UITextView!
    @IBOutlet weak var newCategory: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func backToCreate(segue: UIStoryboardSegue)
    {
    }
    
    @IBAction func cancelSave(sender: UIBarButtonItem)
    {
        //Cancels saving the recipe
        ingredientsArray = []
        myTableView.reloadData()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func editButton(sender: UIButton)
    {
       //allows editing of the tableview
       myTableView.editing = !myTableView.editing
    }
    
   
    
    @IBAction func showPicker(sender: UIButton)
    {
        //Shows the picker
        picker.hidden = false
        cancelButton.hidden = false
        doneButton.hidden = false
        
    }
    @IBAction func hidePicker(sender: UIButton)
    {
        //Hides the picker
        picker.hidden = true
        cancelButton.hidden = true
        doneButton.hidden = true
    }
    
    
    @IBAction func addToCat(sender: UIButton)
    {
        //sets the current value to the category text field
        doneButton.hidden = true
        cancelButton.hidden = true
        newCategory.text = categories[value]
        
        picker.hidden = true
    }
    
    //Brings up the camera ui
    @IBAction func gallery(sender: AnyObject)
    {
        let controller : UIImagePickerController = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        self.presentViewController(controller, animated:true, completion:nil)
    }
    
    //brings up the gallery ui
    @IBAction func camera(sender: AnyObject)
    {
        let controller : UIImagePickerController = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        source = false
        self.presentViewController(controller, animated:true, completion:nil)
    }
    
    
    @IBAction func done(sender: UIBarButtonItem)
    {
        //Shows alert if any fields are empty
        if (newName.text == "" || newCategory.text == "" || newDirections.text == "")
        {
            let alert = UIAlertController(title: "Empty Fields", message: "Please complete all fields before saving", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            
        //Sets image to default Chomp image if no image is selected
        if (photoPicked == 0)
        {
            myImage = UIImage(named: "stockIcon.png")!
        }
            
        photoPicked = 0
        let imageData = UIImageJPEGRepresentation(myImage, 0)
            
        
        self.saveName(newName.text!, img: imageData!, category: newCategory.text!, directions: newDirections.text)
            ingredientsArray = []
        navigationController?.popToRootViewControllerAnimated(true)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //Sets image based on whats been selected from the camera or gallery
        let mediaDictionary : NSDictionary = info as NSDictionary
        myImage = mediaDictionary.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        foodImage.image = myImage
        photoPicked = 1
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Function to save all the values to core data.
    func saveName(name: String, img: NSData, category: String, directions: String) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Recipes",
            inManagedObjectContext:
            managedContext)
        
        let recipe = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        let combinedStrings = ingredientsArray.joinWithSeparator("\n")
        print(combinedStrings)
        recipe.setValue(name, forKey: "name")
        recipe.setValue(img, forKey: "photo")
        recipe.setValue(category, forKey: "category")
        recipe.setValue(directions, forKey: "directions")
        recipe.setValue(combinedStrings, forKey: "ingredients")
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
        
        allRecipes.append(recipe)
        
    }
    
    @IBAction func addRecipe(sender: UIBarButtonItem)
    {
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //Fetches all information from core data
        self.myTableView.reloadData()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Recipes")
        
     
        
        do{
            let fetchedResults =
                try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if let results = fetchedResults
        {
            allRecipes = results
        } else
        {
                    }
        }catch{
            
        }
    }

    
    override func viewDidLoad()
    {
        //Setss textfield and text view delegates
        self.newName.delegate = self
        self.newDirections.delegate = self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Functions to set up the picker
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
        return categories[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        value = row
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredientsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: ingredientTableCell = tableView.dequeueReusableCellWithIdentifier("ingredientCell") as! ingredientTableCell
        
        
        cell.ingredientLabel.text = ingredientsArray[indexPath.row]

        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            //removes the ingredients from the ingredient table view
            ingredientsArray.removeAtIndex(indexPath.row)
            
            myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    //Moves UI up for the keyboard
    func textViewDidBeginEditing(textView: UITextView)
    {
        scrollView.setContentOffset(CGPoint(x: 0,y: 250),animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0),animated: true)
    }
    
    //Sets the ui textfields and textviews to as the firstresponders.
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            newDirections.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        newName.resignFirstResponder()
        
        return true
    }
}
