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
import LBTAComponents
 
class UserProfileViewController:  UIViewController {
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()
  
    @IBOutlet weak var Userimg: UIImageView!

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Posts: UIView!
    @IBOutlet weak var Trainers: UIView!
    @IBOutlet weak var Users: UIView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    //    setupUserimg()

    }
    
    
    func setupUserimg(){
        Userimg.layer.cornerRadius = 40
        Userimg.clipsToBounds = true
        Userimg.isUserInteractionEnabled = true
    }
     func getUserInfo() {
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            databaseRef.child("users").child(uid).getData(completion: { (error, snapshot)
                in
                    guard let dict = snapshot.value as? [String : Any ] else {return}
                  
                    let user = CurrentUser( uid : uid , dictionary : dict)
                    self.Name.text = user.name
                    self.Username.text = user.username
                
                
               // self.Userimg.loadImage(urlString : user.userimg)
              //  }
                
            })
        }

     }

    
    
    

   
    @IBAction func showComponents(_ sender: Any) {
        if ((sender as AnyObject).selectedSegmentIndex == 0){ UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 1
            self.Users.alpha = 0
            self.Trainers.alpha = 0
        })}
          if  ((sender as AnyObject).selectedSegmentIndex == 1 ) {
            do { UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                            self.Users.alpha = 1
                            self.Trainers.alpha = 0
    })}}
    
    
    
         else if ((sender as AnyObject).selectedSegmentIndex == 1 ) {
            do {UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                       self.Users.alpha = 0
                       self.Trainers.alpha = 1
})}
    }}
    
    
    
   /* internal func setPic (imageView : UIImage, imageToSet: UIImage){
        imageView.layar.cornerRadius = 10.0
        imageView.layar.comasksToBounds = true
        imageView.image = imageToSet }
            
    */
}





/*
 
 //func getUserInfo() {
     if Auth.auth().currentUser != nil {
         guard let uid = Auth.auth().currentUser?.uid else {return}
         databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot)
             in
             guard let dict = snapshot.value as? [String : Any ] else {return}
           
             let user = CurrentUser( uid : uid , dictionary : dict)
             self.Name.text = user.name
             self.Username.text = user.username
            // self.Userimg.loadImage(urlString : user.userimg)
           //  }
             
         }, withCancel: {(err) in
             print (err)
         })
     }
 */
