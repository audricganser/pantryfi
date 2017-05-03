//
//  AddShoppingItemViewController.swift
//  PantryFi
//
//  Created by RAZA on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddShoppingItemViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource {
    
    @IBOutlet var ingredientField: UITextField!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var unitField: UITextField!

    var unitArray = ["", "lbs", "ml", "mg", "Units"]
    var unitPicker:UIPickerView!
    var ref = FIRDatabase.database().reference(withPath: "shoppingList")
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        unitPicker = UIPickerView()
        unitPicker.delegate = self
        unitField.inputView = unitPicker
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     
            return unitArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            self.unitField.text = unitArray[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return unitArray.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func addPressed(_ sender: Any) {
        if let title = self.ingredientField.text
        {
            if let amount = self.amountField.text
            {
                if let unit = self.unitField.text
                {
                    if(title == "")
                    {
                        let alert = UIAlertController(title: "Fields Blank", message:"Insert name!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(alert, animated: true, completion:nil)
                    }
                    else if(amount != "" && unit == "")
                    {
                        let alert = UIAlertController(title: "Fields Blank", message:"Insert unit type if inserting amount", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(alert, animated: true, completion:nil)
                    }
                    else
                    {
                        if let user = FIRAuth.auth()?.currentUser
                        {
                            let uid = user.uid
                            let ingredient = Ingredient(name:title, quantity:amount, unit:unit)
                            
                            let shoppingItemRef = self.ref.child(uid).child(title.lowercased())
                            
                            shoppingItemRef.setValue(ingredient.toAnyObject())
                            
                            let alert = UIAlertController(title: "Success", message:"The item was added to your shopping cart", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion:nil)
                        }
                        
                    }
                }
                
                
            }
        }
        
    }

    @IBAction func outsidePress(_ sender: Any) {
                        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
