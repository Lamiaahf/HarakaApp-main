//
//  OtherTrainersViewController.swift
//  HarakaApp
//
//  Created by ohoud on 15/08/1442 AH.
//lamia



import UIKit
import Firebase
import FirebaseStorage

class OtherTrainersViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

        @IBOutlet weak var Profilepic: UIImageView!
        @IBOutlet weak var name: UILabel!
        @IBOutlet weak var Username: UILabel!
        @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var Followers: UIView!

       
       let loggedInTrainer = Auth.auth().currentUser
       var loggedInTrainerData:NSDictionary?
       var otherTrainers:NSDictionary!
       var TrainerProfileData:NSDictionary?
       var databaseRef = Database.database().reference()
       var storageRef = Storage.storage().reference()
       
       var imagePicker = UIImagePickerController()
       //hi
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
        //style
        Utilities.styleFilledButton(followButton)
        Utilities.CircularImageView(Profilepic)

        databaseRef.child("users").child(self.loggedInTrainer!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loggedInTrainerData = snapshot.value as? NSDictionary
            self.loggedInTrainerData?.setValue(self.loggedInTrainer!.uid, forKey: "uid")
            }) { (error) in
                print(error.localizedDescription)
        }
        
        
        
        //add an observer for the user who's profile is being viewed
        //When the followers count is changed, it is updated here!
        //need to add the uid to the user's data
        databaseRef.child("Trainers").child("Approved").child(self.otherTrainers?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.otherTrainers?["uid"] as! String
            self.otherTrainers = snapshot.value as? NSDictionary
            //add the uid to the profile
            self.otherTrainers?.setValue(uid, forKey: "uid")
        
        
        }) { (error) in
                print(error.localizedDescription)
        }
        
        //check if the current user is being followed
        //if yes, Enable the UNfollow button
        //if no, Enable the Follow button
        
    databaseRef.child("following").child(self.loggedInTrainer!.uid).child(self.otherTrainers?["uid"] as! String).observe(.value, with: { (snapshot) in
    
            if(snapshot.exists())
            {
                self.followButton.setTitle("الغاء المتابعة", for: .normal)
                print("You are following the trainer")

            }
            else
            {
                self.followButton.setTitle("متابعة", for: .normal)
                print("You are not following the trainer")
            }

        
        }) { (error) in
        
            print(error.localizedDescription)
        }
        
           
        if (name != nil){
             self.name.text = otherTrainers!["Name"] as? String
            self.Username.text = otherTrainers!["Username"] as? String}
        
        if (otherTrainers!["ProfilePic"] != nil){
         let image =  otherTrainers!["ProfilePic"] as? String
            Storage.storage().reference(forURL: image!).getData(maxSize: 1048576, completion: { [self] (data, error) in

                guard let imageData = data, error == nil else {
                    return
                }

                Profilepic.image = UIImage(data: imageData)
                              //  self.setupUserimg()
                                                                                        
                            
           })

          /* if(otherTrainers["followersCount"] != nil)
           {
               print("Followers Count")
               
               let followersCount = ("\(otherTrainers["followersCount"]!)")
               
               self.numberFollowers.setTitle(followersCount, for: .normal)
           }
       
           if(otherTrainers?["followingCount"] != nil)
           {
               let followingCount = ("\(otherTrainers["followersCount"]!)")
               self.numberFollowing.setTitle(followingCount, for: .normal)
           }*/
        } }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
       

       internal func setProfilePicture(_ imageView:UIImageView,imageToSet:UIImage)
       {
           //imageView.layer.cornerRadius = 10.0
           imageView.layer.borderColor = UIColor.white.cgColor
           imageView.layer.masksToBounds = true
           imageView.image = imageToSet
       }
       
    @IBAction func didTapFollow(_ sender: AnyObject) {
        
        
        
        //use ternary operator to check if the profile_picture exists
        //if not set it as nil - firebase will not create a entry for the profile_pic
        let followersRef = "followers/\(self.otherTrainers?["uid"] as! String)/\(self.loggedInTrainerData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInTrainerData?["uid"] as! String) + "/" + (self.otherTrainers?["uid"] as! String)
        
        
        if(self.followButton.titleLabel?.text == "متابعة")
        {
            print("follow Trainer")
            
            let loggedInTrainersProfilePic = self.loggedInTrainerData?["profilePic"] != nil ? self.loggedInTrainerData?["profilePic"]! : nil
            let otherTrainersProfilePic = self.otherTrainers?["profilePic"] != nil ? self.otherTrainers?["profilePic"]! : nil
            
            let followersData = ["Name":self.loggedInTrainerData?["Name"] as! String,
                        "Username":self.loggedInTrainerData?["Username"] as! String,
                "profilePic": loggedInTrainersProfilePic]
            
            let followingData = ["Name":self.otherTrainers?["Name"] as! String,
                                 "Username":self.otherTrainers?["Username"] as! String,
                                 "profilePic":otherTrainersProfilePic]
            
            //"profile_pic":self.otherUser?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"] as! String : ""
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            
            databaseRef.updateChildValues(childUpdates)
            
            print("data updated")
            
                        
            
            
            //update following count under the logged in user
            //update followers count in the user that is being followed
          /*  let followersCount:Int?
            let followingCount:Int?
            if(self.otherTrainers?["followersCount"] == nil)
            {
                //set the follower count to 1
                followersCount=1
            }
            else
            {
                followersCount = self.otherTrainers?["followersCount"] as! Int + 1
            }
            
            //check if logged in user  is following anyone
            //if not following anyone then set the value of followingCount to 1
            if(self.loggedInTrainerData?["followingCount"] == nil)
            {
                followingCount = 1
            }
                //else just add one to the current following count
            else
            {
            
                followingCount = self.loggedInTrainerData?["followingCount"] as! Int + 1
            }
        
            databaseRef.child("Approved").child(self.loggedInTrainer!.uid).child("followingCount").setValue(followingCount!)
            databaseRef.child("Approved").child(self.otherTrainers?["uid"] as! String).child("followersCount").setValue(followersCount!)
            
            
        }
        else
        {
            databaseRef.child("Trainers").child("Approved").child(self.loggedInTrainerData?["uid"] as! String).child("followingCount").setValue(self.loggedInTrainerData!["followingCount"] as! Int - 1)
            
            databaseRef.child("Trainers").child("Approved").child(self.otherTrainers?["uid"] as! String).child("followersCount").setValue(self.otherTrainers!["followersCount"] as! Int - 1)
            
          let followersRef = "followers/\(self.otherTrainers?["uid"] as! String)/\(self.loggedInTrainerData?["uid"] as! String)"
          let followingRef = "following/" + (self.loggedInTrainerData?["uid"] as! String) + "/" + (self.otherTrainers?["uid"] as! String)
            
            
            let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
            databaseRef.updateChildValues(childUpdates)
            
            
        }*/
        
        }}

    @IBAction func ShowFollowers(_ sender: Any) {
    
       UIView.animate(withDuration: 0.5, animations:{
            self.Followers.alpha = 1
            }
       )}

}
