//
//  HomeViewController.swift
//  PantryFi
//
//  Created by david ares on 3/19/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var spotLightView: UIView!
    @IBOutlet var spotlightImage: UIImageView!
    @IBOutlet var spotlightTitle: UILabel!
    @IBOutlet var spotlightDescription: UITextView!
    @IBOutlet var spotlightPageControl: UIPageControl!
    
    var items = [Ingredient]()
    var spotlightItems = [spotlightItem]()
    var spotlightPosition = 0
//    let colorArray = [
//        UIColor.red,
//        UIColor.orange,
//        UIColor.yellow,
//        UIColor.green,
//        UIColor.blue
//    ]
//    var colorPick = 0

    @IBOutlet weak var pantrySearchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    let avarellIdentifier = "addCell"
    let itemIdentifier = "itemCell"
    let ref = FIRDatabase.database().reference(withPath: "ingredients")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pushed view controller up when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //top right button for settings
        
        //table set up
        self.tableView.separatorColor = UIColor.clear
        
        //tableView set up
        tableView.delegate = self
        tableView.dataSource = self
        
        // 1
        if let user = FIRAuth.auth()?.currentUser
        {
        let uid = user.uid
        ref.child(uid).observe(.value, with: { snapshot in
            // 2
            var newItems: [Ingredient] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let groceryItem = Ingredient(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            // 5
            self.items = newItems
            self.tableView.reloadData()
        })
        }
        
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gestureRecognizer:)))
        gestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        gestureRecognizer.delegate = self
        self.spotLightView.addGestureRecognizer(gestureRecognizer)
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(gestureRecognizer:)))
        rightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        rightGestureRecognizer.delegate = self
        self.spotLightView.addGestureRecognizer(rightGestureRecognizer)
        setupSpotlight()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSpotlight()
    {
        let item1 = spotlightItem(title: "Chicken Caesar Salad", description: "What a beautiful salad. Nice and healthy salad. V good."
, image: #imageLiteral(resourceName: "salad"))
        
        let item2 = spotlightItem(title: "African Stir Fry", description: "This is a good dish very good I like this dish because it is cultural", image: #imageLiteral(resourceName: "african_recipes"))
        
        let item3 = spotlightItem(title: "Ugly Pasta", description: "This is some ugly pasta, but I'm sure it is healthy and tastes pretty good", image: #imageLiteral(resourceName: "pasta"))
        
        spotlightItems.append(item1)
        spotlightItems.append(item2)
        spotlightItems.append(item3)
        spotlightPageControl.numberOfPages = spotlightItems.count
        spotlightImage.image = spotlightItems.first?.image
        spotlightTitle.text = spotlightItems.first?.title
        spotlightDescription.text = spotlightItems.first?.description
        adjustUITextViewHeight(arg: self.spotlightDescription)

    }
    
    func nextSpotlightItem()
    {
            spotlightPosition += 1
            if(spotlightPosition >= spotlightItems.count)
            {
                spotlightPosition = 0
            }
            let nextSpotlight = spotlightItems[spotlightPosition]
            self.spotlightImage.pushTransition(0.3)
            self.spotlightImage.image = nextSpotlight.image
            self.spotlightTitle.pushTransition(0.2)
            self.spotlightTitle.text = nextSpotlight.title
            self.spotlightDescription.pushTransition(0.4)
            self.spotlightDescription.text = nextSpotlight.description
            adjustUITextViewHeight(arg: self.spotlightDescription)
            self.spotlightPageControl.currentPage = spotlightPosition
        
        
    }
    
    func prevSpotlightItem()
    {
        spotlightPosition -= 1
        if(spotlightPosition < 0)
        {
            spotlightPosition = spotlightItems.count - 1
        }
        let nextSpotlight = spotlightItems[spotlightPosition]
        self.spotlightImage.pullTransition(0.3)
        self.spotlightImage.image = nextSpotlight.image
        self.spotlightTitle.pullTransition(0.2)
        self.spotlightTitle.text = nextSpotlight.title
        self.spotlightDescription.pullTransition(0.4)
        self.spotlightDescription.text = nextSpotlight.description
        adjustUITextViewHeight(arg: self.spotlightDescription)
        self.spotlightPageControl.currentPage = spotlightPosition


    }
    
    func handleSwipe(gestureRecognizer: UIGestureRecognizer) {
        nextSpotlightItem()
    }
    
    func handleRightSwipe(gestureRecognizer: UIGestureRecognizer) {
        prevSpotlightItem()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = "\(searchBar.text!)"
        
        //set up other view controller
        let vc = (storyboard?.instantiateViewController(withIdentifier: "pantrySearch"))! as! PantrySearchViewController
        
        vc.queryFromHome = query
        vc.searchFromHome = true
        
        //hide keyboard
        view.endEditing(true)
        
        //reset search input
        self.searchBar.text = nil
        
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)
        
        
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(items.count == 0)
        {
            return 1
        }
        else
        {
            return items.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0)
        {
            let addCell = tableView.dequeueReusableCell(withIdentifier: avarellIdentifier) as! AddIngredientTableViewCell
            addCell.backgroundColor = UIColor.clear
            addCell.cellRect.layer.cornerRadius = 5
            addCell.cellRect.layer.borderWidth = 1.25
            addCell.cellRect.layer.borderColor = UIColor(hex: "0x2ECC71").cgColor
            return addCell
        }
        else
        {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier) as! IngredientTableViewCell
            itemCell.backgroundColor = UIColor.clear
            itemCell.cellRect.layer.cornerRadius = 5
            itemCell.cellRect.layer.borderWidth = 1.25
            itemCell.cellRect.layer.borderColor = UIColor(hex: "0x2ECC71").cgColor
            let row = indexPath.row
            let ingredient = items[row-1]
            itemCell.titleLabel.text = ingredient.name
            itemCell.quantityLabel.text = ingredient.quantity
            
            return itemCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let row = indexPath.row
        if(row == 0)
        {
            didTapAddItem()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 80
    }
    
    
    
    func didTapAddItem()
    {
        
        self.performSegue(withIdentifier: "addIngredient", sender: self)
//        let alert = UIAlertController(title: "New Ingredient", message:"Insert name of item and quantity", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: nil)
//        alert.addTextField(configurationHandler: nil)
//        alert.textFields?[0].placeholder = "Item"
//        alert.textFields?[1].placeholder = "Quantity"
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//            if let title = alert.textFields?[0].text
//            {
//                if let itemQuantity = alert.textFields?[1].text
//                {
//                    if(title == "" || itemQuantity == "")
//                    {
//                        
//                    }
//                    else
//                    {
//                        guard let textField = alert.textFields?.first,
//                            let text = textField.text else { return }
//                        
//                        if let user = FIRAuth.auth()?.currentUser
//                        {
//                            let uid = user.uid
//
//                        
//                        // 2
//                        let ingredient = Ingredient(name:text, quantity:itemQuantity)
//                        // 3
//                        let ingredientItemRef = self.ref.child(uid).child(text.lowercased())
//                        
//                        // 4
//                        ingredientItemRef.setValue(ingredient.toAnyObject())
//                        }
//                        
//                    }
//                }
//            }
//        }))
//        self.present(alert, animated: true, completion: nil)

    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            return
        }
        if editingStyle == .delete {
            let ingredientItem = items[indexPath.row-1]
            ingredientItem.ref?.removeValue()
        }
    }
    
    @IBAction func searchPantry(_ sender: Any) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "searchResults", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "pantrySearch") as! PantrySearchViewController

        var ingredientsString = ""
        
        for i in items {
            ingredientsString += i.name + ","
        }
        vc.ingredientsString = ingredientsString
        vc.searchFromHome = false
        
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if (segue.identifier == "pantrySearchSegue") {
//            let destinationVC = segue.destination as! PantrySearchViewController
//            var ingredientsString = ""
//            
//            for i in items {
//                ingredientsString += i.name + ","
//            }
//            destinationVC.ingredientsString = ingredientsString
//        }
//        
//    }
    
    // Keyboard functions
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

class spotlightItem{
    var title:String?
    var description:String?
    var image:UIImage?
    
    init(title:String, description:String, image:UIImage)
    {
        self.title = title
        self.description = description
        self.image = image
    }
}

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromRight
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
    
    func pullTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromLeft
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }

}



