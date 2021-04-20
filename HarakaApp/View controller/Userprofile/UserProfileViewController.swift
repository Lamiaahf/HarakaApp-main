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
import AMTabView

class UserProfileViewController:  UIViewController , TabItem {
     
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
    
    @IBOutlet weak var PostsV: UIView!
    @IBOutlet weak var FollowersV: UIView!
    @IBOutlet weak var FollowingV: UIView!

    @IBOutlet weak var post: UIButton!
    @IBOutlet weak var Following: UIButton!
    @IBOutlet weak var Followers: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(post)
        Utilities.styleFilledButton(Following)
        Utilities.styleFilledButton(Followers)
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
    
        guard let uid = Auth.auth().currentUser?.uid else {print ("nil"); return}
        if uid != nil {
         

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
                  //  self.setupUserimg()

                })
                
            })}}

   
    @IBAction func showPosts(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{self.PostsV.alpha = 1
                 self.FollowingV.alpha = 0
                    self.FollowersV.alpha = 0 }
       )}
    
    @IBAction func ShowFollowing(_ sender: Any) {
  
    
            do { UIView.animate(withDuration: 0.5, animations:{self.PostsV.alpha = 0
                            self.FollowingV.alpha = 1
                            self.FollowersV.alpha = 0
    })
            }}
    @IBAction func showFollowers(_ sender: Any) {

    
            do {UIView.animate(withDuration: 0.5, animations:{self.PostsV.alpha = 0
                       self.FollowingV.alpha = 0
                       self.FollowersV.alpha = 1
})}
    }
    
    
    
    
  //  Pass contextual data along with the segue
    
    
 
}// End Class
 



