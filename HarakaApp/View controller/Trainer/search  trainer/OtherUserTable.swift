//
//  OtherUserTable.swift
//  HarakaApp
//
//  Created by lamia on 24/04/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class OtherUserTable: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
        
        @IBOutlet weak var Profilepic: UIImageView!
        @IBOutlet weak var name: UILabel!
        @IBOutlet weak var Username: UILabel!

        @IBOutlet weak var Followers: UIView!

       
       let loggedInUsers = Auth.auth().currentUser
       var loggedInUserData:NSDictionary?
       var otherUser:NSDictionary!
       var UserProfileData:NSDictionary?
       var databaseRef = Database.database().reference()
       var storageRef = Storage.storage().reference()
       var uid : String?
      // var imagePicker = UIImagePickerController()
       //hi
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
        //style
        Utilities.CircularImageView(Profilepic)

        databaseRef.child("users").child(self.loggedInUsers!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            self.loggedInUserData?.setValue(self.loggedInUsers!.uid, forKey: "uid")
            }) { (error) in
                print(error.localizedDescription)
        }
        
        
        
        //add an observer for the user who's profile is being viewed
        //When the followers count is changed, it is updated here!
        //need to add the uid to the user's data
        databaseRef.child("users").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            self.uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            //add the uid to the profile
            self.otherUser?.setValue(self.uid, forKey: "uid")
        
        
        }) { (error) in
                print(error.localizedDescription)
        }
        
           
        if (name != nil){
             self.name.text = otherUser!["Name"] as? String
            self.Username.text = otherUser!["Username"] as? String}
        
        if (otherUser!["ProfilePic"] != nil){
         let image =  otherUser!["ProfilePic"] as? String
            Storage.storage().reference(forURL: image!).getData(maxSize: 1048576, completion: { [self] (data, error) in

                guard let imageData = data, error == nil else {
                    return
                }

                Profilepic.image = UIImage(data: imageData)
                                                                                        
                            
           })

          
        } }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
       

     
       
        @IBAction func ShowFollowers(_ sender: Any) {
            
            let Trainer = self.uid
            let TF = self.storyboard?.instantiateViewController(withIdentifier: "TFollowers") as? OtherTrainerFollowersTable
                TF?.otherTrainerID = Trainer
                self.navigationController?.pushViewController(TF!, animated: true)
            

           }
        @IBAction func ShowPosts(_ sender: Any) {
            
            let user = self.uid
            let UP = self.storyboard?.instantiateViewController(withIdentifier: "OtherPosts") as? OtherUserPostViewController
                  UP?.otherUserID = user
                self.navigationController?.pushViewController(UP!, animated: true)
            

           }
        
        
        
        @IBAction func ShowFollowing(_ sender: Any) {
            
            let ID = self.uid
            let UF = self.storyboard?.instantiateViewController(withIdentifier: "UFollowing") as? OtherUserFollowingTable
                UF?.userID = ID
                self.navigationController?.pushViewController(UF!, animated: true)
            

           }


    }

