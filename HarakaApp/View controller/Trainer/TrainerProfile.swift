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

    
   //tab bar
   var tabImage: UIImage? {
     return UIImage(systemName: "person")
   }
   
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    //Serch for frinds
    var loggedInUser:AnyObject?
    var loggedInUserData:NSDictionary?

    
    @IBOutlet weak var Userimg: UIImageView!

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    // V = UIView
    @IBOutlet weak var ActivitiesV: UIView!
    @IBOutlet weak var ChallengesV: UIView!
    @IBOutlet weak var FollowersV: UIView!
   // B = UIButton
    @IBOutlet weak var activitieB: UIButton!
    @IBOutlet weak var challengeB: UIButton!
    @IBOutlet weak var followerB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(activitieB)
        Utilities.styleFilledButton(challengeB)
        Utilities.styleFilledButton(followerB)
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
    
       UIView.animate(withDuration: 0.5, animations:{self.ActivitiesV.alpha = 1
            self.ChallengesV.alpha = 0
                    self.FollowersV.alpha = 0 }
       )}
    
    @IBAction func ShowChallenges(_ sender: Any) {
  
    
            do { UIView.animate(withDuration: 0.5, animations:{self.ActivitiesV.alpha = 0
                            self.ChallengesV.alpha = 1
                            self.FollowersV.alpha = 0
    })
            }}
    
    @IBAction func ShowFollowers(_ sender: Any) {

            do {UIView.animate(withDuration: 0.5, animations:{self.ActivitiesV.alpha = 0
                       self.ChallengesV.alpha = 0
                       self.FollowersV.alpha = 1
            })}}
    
    
    
    
    
  //  Pass contextual data along with the segue
    
    
 
}// End Class
