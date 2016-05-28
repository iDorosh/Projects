//
//  NewIngredient.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/24/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit

class NewIngredient: UIViewController, UITextFieldDelegate
{
    var units: [String] = ["none","lb","cup","tsp","tbsp"]
    var convertUnits : [String] = [String]()
    var singleIngredient : [String] = [String]()
    var value : Int = 0
    var selected : Int = 0
    var currentPicker : Int = 0
    var finalConversion : String = String()
    
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var measurement: UITextField!
    @IBOutlet weak var conversion: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    //Opens pickers wit the initial units
    @IBAction func openPicker(sender: UIButton)
    {
        units = ["none","lb","cup","tsp","tbsp"]
        picker.reloadAllComponents()
        currentPicker = 0
        picker.hidden = false
        cancel.hidden = false
        done.hidden = false
        selected = 1
    }
    
    //Opens pickers with the convertion units
    @IBAction func openPickerConvert(sender: UIButton)
    {
        units = ["none","kg","ml","g"]
        picker.reloadAllComponents()
        currentPicker = 1
        picker.hidden = false
        cancel.hidden = false
        done.hidden = false
        selected = 0
    }
    //Saves measurements based on if the user wants to convert the initial unit.
    @IBAction func saveMeasurment(sender: UIButton)
    {
        done.hidden = true
        cancel.hidden = true
        
        if (selected == 1)
        {
            measurement.text = units[value]
        }
        else
        {
            conversion.text = units[value]
        }
        
        if (measurement.text == "" || measurement.text == "none")
        {
            conversion.text = "none"
        }
        picker.hidden = true
    }
    
    @IBAction func closePicker(sender: UIButton)
    {
        picker.hidden = true
        cancel.hidden = true
        done.hidden = true
    }
    
    @IBAction func saveIngredient(sender: UIBarButtonItem)
    {
        //Displays alert if the text fields are empty
        //Combines all the ingredient information into a single string and sends that string to the tableview
        if (ingredientName.text == "" || amount.text == "" || measurement.text == "" )
        {
            let alert = UIAlertController(title: "Empty Fields", message: "Please complete all fields before saving", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else
        {
            convertUnits(measurement.text!, convertUnit: conversion.text!)
            
            
        if (conversion.text == "none")
        {
            if (measurement.text == "none")
            {
                singleIngredient.append(amount.text!)
                singleIngredient.append(ingredientName.text!)
            }
            else
            {
            singleIngredient.append(amount.text!)
            singleIngredient.append(measurement.text!)
            singleIngredient.append(ingredientName.text!)
            }
        }
        else
        {
            amount.text = finalConversion
            singleIngredient.append(amount.text!)
            singleIngredient.append(conversion.text!)
            singleIngredient.append(ingredientName.text!)
        
        }
        let combined = singleIngredient.joinWithSeparator(" ")
        ingredientsArray.append(combined)
        self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
    }

    override func viewDidLoad()
    {
        ingredientName.delegate = self
        amount.delegate = self
        super.viewDidLoad()
    }
    
    //Functions for the picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return units.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return units[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        value = row
        print(value)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        ingredientName.resignFirstResponder()
        amount.resignFirstResponder()
        
        return true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func convertUnits(currentUnit: String, convertUnit: String)
    {
        var stringToInt = Int()
        _ = amount.text
        var convertedInt = Double()
        var convertedDouble = Double()
        var adjustedUnits = ""
        
        //If statements for the converstions
        if (currentUnit == "lb" && convertUnit == "kg")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*2.2
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "lb" && convertUnit == "g")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble/0.0022046
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "lb" && convertUnit == "ml")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*453.59
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "cup" && convertUnit == "kg")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*0.2365882375
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "cup" && convertUnit == "g")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*229.92
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "cup" && convertUnit == "ml")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*236.588
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
        }
        if (currentUnit == "tsp" && convertUnit == "kg")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*0.0057
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "tsp" && convertUnit == "g")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*4.92892161458
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "tsp" && convertUnit == "ml")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*4.92892
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "tbsp" && convertUnit == "kg")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*0.017
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "tbsp" && convertUnit == "ml")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*14.7868
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        if (currentUnit == "tbsp" && convertUnit == "g")
        {
            stringToInt = Int(amount.text!)!
            convertedDouble = Double(stringToInt)
            convertedInt = convertedDouble*15
            adjustedUnits = String(stringInterpolationSegment: convertedInt)
            print(adjustedUnits)
            
        }
        finalConversion = adjustedUnits
        
    }
}
