//
//  searchBViewController.swift
//  HarakaApp
//
//  Created by ohoud on 12/08/1442 AH.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class searchBViewController: UIViewController , UINavigationControllerDelegate {
    

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
    
    

    
    
    
    
    

    @IBAction func ShowUsers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
        self.Trainers.alpha = 0
        self.users.alpha = 1

       }
       )}
    
    
    @IBAction func ShowTrainers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.users.alpha = 0
            self.Trainers.alpha = 1 }
       )}

    
        
    }


