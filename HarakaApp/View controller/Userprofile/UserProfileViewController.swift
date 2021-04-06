//
//  UserProfileViewController.swift
//  HarakaApp
//
//  Created by lamia on 17/02/2021.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
 
class UserProfileViewController:  UIViewController {
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    //Serch for frinds
    var loggedInUser:AnyObject?
    var loggedInUserData:NSDictionary?

    
    @IBOutlet weak var Userimg: UIImageView!

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Posts: UIView!
    @IBOutlet weak var Trainers: UIView!
    @IBOutlet weak var Users: UIView!

    @IBOutlet weak var post: UIButton!
    
    @IBOutlet weak var friends: UIButton!
    @IBOutlet weak var trainer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(post)
        Utilities.styleFilledButton(friends)
        Utilities.styleFilledButton(trainer)
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

            databaseRef.child("users").child(uid).observe(.value , with : {snapshot
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

   
    @IBAction func showPosts(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 1
            self.Users.alpha = 0
                    self.Trainers.alpha = 0 }
       )}
    
    @IBAction func ShowFriends(_ sender: Any) {
  
    
            do { UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                            self.Users.alpha = 1
                            self.Trainers.alpha = 0
    })
            }}
    
    /*
            do {UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                       self.Users.alpha = 0
                       self.Trainers.alpha = 1
})}
    }}
    
    */
    
    
  //  Pass contextual data along with the segue
    
    
 
}// End Class
