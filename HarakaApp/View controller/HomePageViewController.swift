//
//  HomePageViewController.swift
//  HomePageHaraka
//
//  Created by Noura AlSheikh on 01/02/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AMTabView

class HomePageViewController: UIViewController , TabItem{
    
    // tab bar and UI ohoud
    var tabImage: UIImage? {
      return UIImage(systemName: "homekit")
    }
    
    @IBOutlet var activitiesButton: UIButton!
   
    @IBOutlet var GroupsHSButton: UIButton!
    
    @IBOutlet var challangesHSButton: UIButton!
   
    @IBOutlet var GameHSButton: UIButton!
    
    @IBOutlet var postsHSButton: UIButton!
    
    var databaseRef = Database.database().reference()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let uid = Auth.auth().currentUser?.uid
            self.databaseRef.child("Trainers").child("Approved").observeSingleEvent(of: .value, with: { (snapshot) in

                    if snapshot.hasChild(uid!){

                        self.activitiesButton.applyDesign()
                        self.GroupsHSButton.applyDesign()
                        self.challangesHSButton.applyDesign()
                    }else {
                        self.activitiesButton.applyDesign()
                        self.GroupsHSButton.applyDesign()
                        self.challangesHSButton.applyDesign()
                        self.GameHSButton.applyDesign()
                        self.postsHSButton.applyDesign()

                        }


                })
        }
      
}

extension UIButton {
    func applyDesign() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5   }
}


