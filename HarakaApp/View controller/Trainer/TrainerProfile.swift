//
//  TrainerProfile.swift
//  HarakaApp
//
//  Created by lamia on 31/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class TrainerProfile: UIViewController {

    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    //Serch for frinds
    var loggedInUser:AnyObject?
    var loggedInUserData:NSDictionary?

    
    @IBOutlet weak var Userimg: UIImageView!

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Activities: UIView!
    @IBOutlet weak var Challenges: UIView!
    @IBOutlet weak var Followers: UIView!

    @IBOutlet weak var activitie: UIButton!
    @IBOutlet weak var challenge: UIButton!
    @IBOutlet weak var follower: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(activitie)
        Utilities.styleFilledButton(challenge)
        Utilities.styleFilledButton(follower)
        getUserInfo()
        self.loggedInUser = Auth.auth().currentUser

    //    setupUserimg()

    }
    
    
    func setupUserimg(){
        Userimg.layer.cornerRadius = 40/2
        Userimg.clipsToBounds = true
        Userimg.isUserInteractionEnabled = true
    }
    
    /*
    func getUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else {print ("nil"); return}
       
        databaseRef.child("users").child(uid).observe(.value, with: { snapshot in
      print(snapshot.value)
    })
        
         
    }*/

    
     func getUserInfo() {
    
    //func getUserInfo() {
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else {print ("nil"); return}

            databaseRef.child("Trainers").child("Approved").child(uid).observe(.value , with : {snapshot
                in
                guard let dict = snapshot.value as? [String:Any] else {return}
              
                let user = CurrentUser( uid : uid , dictionary : dict )
                self.Name.text = user.name
                self.Username.text = user.username
                
               
                Storage.storage().reference(forURL: user.userimg).getData(maxSize: 1048576, completion: { (data, error) in

                    guard let imageData = data, error == nil else {
                        return
                    }
                    self.Userimg.image = UIImage(data: imageData)
                    self.setupUserimg()

                })
                
            })}}

   
    @IBAction func showActivities(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{self.Activities.alpha = 1
            self.Challenges.alpha = 0
                    self.Followers.alpha = 0 }
       )}
    
    @IBAction func ShowChallenges(_ sender: Any) {
  
    
            do { UIView.animate(withDuration: 0.5, animations:{self.Activities.alpha = 0
                            self.Challenges.alpha = 1
                            self.Followers.alpha = 0
    })
            }}
    
    @IBAction func ShowFollowers(_ sender: Any) {

            do {UIView.animate(withDuration: 0.5, animations:{self.Activities.alpha = 0
                       self.Challenges.alpha = 0
                       self.Followers.alpha = 1
            })}}
    
    
    
    
    
  //  Pass contextual data along with the segue
    
    
 
}// End Class
