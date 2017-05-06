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
import BarcodeScanner
import Alamofire

class AddIngredientViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var ingredientExpiration: UITextField!
    @IBOutlet var expirationAlertSwitch: UISwitch!
    @IBOutlet var ingredientName: UITextField!
    @IBOutlet var ingredientAmount: UITextField!
    @IBOutlet var unitPicker: UISegmentedControl!
    
    var editMode = false
    var ingredient: Ingredient?
    var key: String?
    var ref = FIRDatabase.database().reference(withPath: "ingredients")
    var unitArray = ["lbs", "ml", "mg", "Units"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if(ingredient != nil)
        {
            editMode = true
            self.key = ingredient?.key
            self.ingredientName.text = ingredient?.name
            self.ingredientAmount.text = ingredient?.quantity
            //self.unitPicker.selectedSegmentIndex =
            let unit:String = (ingredient?.unit)!
            self.unitPicker.selectedSegmentIndex = unitArray.index(of: unit)!
            self.ingredientExpiration.text = ingredient?.expirationDate
            self.expirationAlertSwitch.isOn = (ingredient?.expirationAlert)!
            self.ref = (ingredient?.ref)!
        }
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
        if(editMode == true)
        {
            if let title = self.ingredientName.text{
                
                if let expiration = self.ingredientExpiration.text
                {
                    if let amount = self.ingredientAmount.text
                    {
                        let units = unitArray[self.unitPicker.selectedSegmentIndex]
                        let alertOn = expirationAlertSwitch.isOn
                        if(title == "" || amount == "")
                        {
                            let alert = UIAlertController(title: "Fields Blank", message:"Insert name of item and quantity", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            self.present(alert, animated: true, completion:nil)
                        }
                        if(expirationAlertSwitch.isOn == true && ingredientExpiration.text == "")
                        {
                            let alert = UIAlertController(title: "Expiration Alert", message:"You must select an expiration date for an expiration alarm", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            self.present(alert, animated: true, completion:nil)
                        }
                        else
                        {
                            if let user = FIRAuth.auth()?.currentUser
                                
                            {
                                
                                // 2
                                let ingredient = Ingredient(name: title, quantity: amount, unit: units, expirationDate: expiration, expirationAlert: alertOn)
                                // 3
                                let ingredientItemRef = self.ref
                                // 4
                                ingredientItemRef.setValue(ingredient.toAnyObject())
                                
                                let alert = UIAlertController(title: "Success", message:"This ingredient was updated", preferredStyle: .alert)
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
        else
        {
        if let title = self.ingredientName.text{
            
            if let expiration = self.ingredientExpiration.text {
                    if let amount = self.ingredientAmount.text
                    {
                        let units = unitArray[self.unitPicker.selectedSegmentIndex]
                        let alertOn = expirationAlertSwitch.isOn
                        if(title == "" || amount == "")
                        {
                            let alert = UIAlertController(title: "Fields Blank", message:"Insert name of item and quantity", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            self.present(alert, animated: true, completion:nil)
                        }
                        if(expirationAlertSwitch.isOn == true && ingredientExpiration.text == "")
                        {
                            let alert = UIAlertController(title: "Expiration Alert", message:"You must select an expiration date for an expiration alarm", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            self.present(alert, animated: true, completion:nil)
                        }
                        else
                        {
                            if let user = FIRAuth.auth()?.currentUser
                                
                            {
                                
                                let uid = user.uid
                                // 2
                                let ingredient = Ingredient(name: title, quantity: amount, unit: units, expirationDate: expiration, expirationAlert: alertOn)
                                
                                // 3
                                let ingredientItemRef = self.ref.child(uid).child(title.lowercased())
                                // 4
                                ingredientItemRef.setValue(ingredient.toAnyObject())
                                
                                let alert = UIAlertController(title: "Success", message:"The ingredient was added to your pantry", preferredStyle: .alert)
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
        
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self

        
        present(controller, animated: true, completion: nil)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddIngredientViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        
        //CODE TO DO STUFF WITH UPC
        getGroceryItem(code: code)
        
        
        controller.reset()
    }
}

/*curl --get --include 'https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/products/upc/041631000564' \
 -H 'X-Mashape-Key: oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg' \
 -H 'Accept: application/json'*/

func getGroceryItem(code: String) {
    let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/products/upc/\(code)"
    let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
    
    Alamofire.request(baseUrl, headers: headers).responseJSON { response in
        
        if let JSON = response.result.value {
            let jsonDict = JSON as! Dictionary<String, Any>
            var id = 0
            if let idVal = jsonDict["id"] { id = idVal as! Int }
            var title = ""
            if let titleVal = jsonDict["title"] { title = "\(titleVal)" }
            var numberOfServings = 0
            if let nsVal = jsonDict["number_of_servings"] { numberOfServings = nsVal as! Int }
            
            let item = Ingredient.init(name: title, quantity: "\(numberOfServings)", key: "\(id)")
            
            // Set View Controller Fields here:
            
            
        }
    }
    
    
}

extension AddIngredientViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension AddIngredientViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
