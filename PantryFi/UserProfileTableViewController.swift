//
//  UserProfileTableViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 5/1/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    let imagePicker = UIImagePickerController()
    
    var imageView: UIImageView!
    
    var user = ["Allergies", "Diet Restrictions", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        tableView.isScrollEnabled = false;
        tableView.delegate = self
        tableView.dataSource = self


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 100.0;//Choose your custom row height
        }
        else {
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Info", for: indexPath)
        
        if indexPath.row == 0 {
            if let user = FIRAuth.auth()?.currentUser {
                let uid = user.uid
                FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        let name = dictionary["name"] as? String
                        cell.textLabel?.text = "\(name!)"
                    }
                }, withCancel: nil)
            }

            cell.textLabel?.textAlignment = .center
            cell.imageView?.image = #imageLiteral(resourceName: "profile")

        }
        else {
            // Configure the cell...
            cell.textLabel?.text = user[indexPath.row - 1]
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            break
            
        case 1:
            let storyBoard1:UIStoryboard = UIStoryboard(name: "allergies", bundle:nil)
            let vc = storyBoard1.instantiateViewController(withIdentifier: "allergies") as! AllergiesTableViewController
            self.navigationController?.pushViewController(vc, animated:true)
            break
            
        case 2:
            let storyBoard1:UIStoryboard = UIStoryboard(name: "dietaryRestrictions", bundle:nil)
            let vc = storyBoard1.instantiateViewController(withIdentifier: "diet") as! DietViewController
            self.navigationController?.pushViewController(vc, animated:true)
            
            break
            
//        case 4:
//            let storyBoard1:UIStoryboard = UIStoryboard(name: "userProfiles", bundle:nil)
//            let vc = storyBoard1.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
//            present(vc, animated: true, completion: nil)
//            
//            break
            
        case 3:
            do{
                try FIRAuth.auth()?.signOut()
            }
            catch{
                print("Error while signing out!")
            }
            let storyBoard1:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard1.instantiateViewController(withIdentifier: "Navigation")
            self.present(nextViewController, animated:true, completion:nil)
            
            
            break
        default:
            break
        }
        

    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
