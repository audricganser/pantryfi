//
//  FavoritesCollectionViewController.swift
//  PantryFi
//
//  Created by RAZA on 5/3/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire

private let reuseIdentifier = "Cell"


let ref = FIRDatabase.database().reference(withPath: "recipes")

var items = [RecipeWithIngredients]()
var images = [UIImage]()

class FavoritesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // 1
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            ref.child(uid).observe(.value, with: { snapshot in
                // 2
                var newItems: [RecipeWithIngredients] = []
                
                // 3
                for item in snapshot.children {
                    // 4
                    let recipeItem = RecipeWithIngredients(snapshot: item as! FIRDataSnapshot)
                    newItems.append(recipeItem)
                }
                
                // 5
                items = newItems
                self.collectionView?.reloadData()
            })
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCollection", for: indexPath) as! FavoriteCollectionViewCell
    
    
        let row = indexPath.row
        let recipe = items[row]
        Alamofire.request(recipe.image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                cell.imageView.image = image

            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
        cell.titleLabel.text = recipe.title
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let id = items[row].id
        //Open storyboard
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
