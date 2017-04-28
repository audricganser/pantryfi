//
//  AddIngredientViewController.swift
//  PantryFi
//
//  Created by RAZA on 4/27/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddIngredientViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var ingredientExpiration: UITextField!
    @IBOutlet var expirationAlertSwitch: UISwitch!
    @IBOutlet var ingredientName: UITextField!
    @IBOutlet var ingredientAmount: UITextField!
    @IBOutlet var unitPicker: UISegmentedControl!
    
    let ref = FIRDatabase.database().reference(withPath: "ingredients")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dobEditingDidBegin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.dobPickerValueChanged), for: .valueChanged)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        
        let dobString = self.ingredientExpiration.text
        
        if dobString?.isEmpty == false {
            let dob = formatter.date(from: dobString!)
            datePickerView.setDate(dob!, animated: true)
        }

    }
    
    func dobPickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        ingredientExpiration.text = formatter.string(from: sender.date)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addPressed(_ sender: Any) {
        
        if let title = self.ingredientName.text{
            
            if let expiration = self.ingredientExpiration.text {
                    if let amount = self.ingredientAmount.text
                    {
                        if(title == "" || amount == "")
                        {
                            let alert = UIAlertController(title: "Fields Blank", message:"Insert name of item and quantity", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            self.present(alert, animated: true, completion:nil)
                        }
                        else
                        {
                            if let user = FIRAuth.auth()?.currentUser
                                
                            {
                                
                                let uid = user.uid
                                // 2
                                let ingredient = Ingredient(name:title, quantity:amount)
                                // 3
                                let ingredientItemRef = self.ref.child(uid).child(title.lowercased())
                                // 4
                                ingredientItemRef.setValue(ingredient.toAnyObject())
                                
                                let alert = UIAlertController(title: "Ingredient Added", message:"Thanks", preferredStyle: .alert)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
