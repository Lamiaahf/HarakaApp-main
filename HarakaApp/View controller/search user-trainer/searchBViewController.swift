//
//  searchBViewController.swift
//  HarakaApp
//
//  Created by ohoud on 12/08/1442 AH.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class searchBViewController: UIViewController {
    

    @IBOutlet var usersSearch: UIButton!
   @IBOutlet var trainersSearch: UIButton!
    
    @IBOutlet weak var TrainersTable: UIView!
    @IBOutlet weak var usersTable: UIView!
    
    let databaseRef = Database.database().reference()
    //Serch for frinds
    var loggedInUser:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(usersSearch)
       Utilities.styleFilledButton(trainersSearch)
        self.loggedInUser = Auth.auth().currentUser

    }
    @IBAction func ShowUsers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.usersTable.alpha = 1
                    self.TrainersTable.alpha = 0 }
       )}
    @IBAction func ShowTrainers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.usersTable.alpha = 0
                    self.TrainersTable.alpha = 1 }
       )}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "findUser")
        {
            let showFollowingTableViewController = segue.destination as! UsersTableViewController
             

            showFollowingTableViewController.loggedInUser = self.loggedInUser as? CurrentUser
              
        }
       else  if(segue.identifier == "findTrainer")
        {
            let showTrainersTableViewController = segue.destination as! TrainersTableViewController
                           
        }

        
    }

}