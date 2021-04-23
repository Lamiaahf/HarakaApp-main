//
//  searchBViewController.swift
//  HarakaApp
//
//  Created by ohoud on 12/08/1442 AH.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AMTabView

class searchBViewController: UIViewController , TabItem {
    
    //tab bar
    var tabImage: UIImage? {
      return UIImage(systemName: "magnifyingglass")
    }
    

   // @IBOutlet var usersSearch: UIButton!
  // @IBOutlet var trainersSearch: UIButton!
    @IBOutlet var users: UIView!
    @IBOutlet var Trainers: UIView!

    
    
    let databaseRef = Database.database().reference()
    //Serch for frinds
    var loggedInUser:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Utilities.styleFilledButton(usersSearch)
       // Utilities.styleFilledButton(trainersSearch)
        self.loggedInUser = Auth.auth().currentUser

    }
    
    
    @IBAction func showusers(_ sender : Any) {
        
        
            UIView.animate(withDuration: 0.5, animations: {
                
                self.users.alpha = 1
                self.Trainers.alpha = 0
           })
        }
@IBAction func showTrainers(_ sender : Any) {

            UIView.animate(withDuration: 0.5, animations: {
                
                self.Trainers.alpha = 1
                self.users.alpha = 0
                
            })
        }
            }
    
    
    
    
    
    /*
    @IBAction func ShowUsers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.usersTable.alpha = 1
                    self.TrainersTable.alpha = 0 }
       )}
    @IBAction func ShowTrainers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.usersTable.alpha = 0
                    self.TrainersTable.alpha = 1 }
       )} */

  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "findUser")
        {
            let showFollowingTableViewController = segue.destination as! UsersTableViewController
             

            showFollowingTableViewController.loggedInUser = self.loggedInUser as? CurrentUser
              
        }
       else  if(segue.identifier == "findTrainer")
        {
            let showTrainersTableViewController = segue.destination as! TrainersTableViewController
                           
        }

        
    }*/


