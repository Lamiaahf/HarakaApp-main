//
//  OtherUsersViewController.swift
//  HarakaApp
//
//  Created by lamia on 07/04/2021.
//

import UIKit
import Firebase
import FirebaseStorage
class OtherUsersViewController: UIViewController ,UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var Profilepic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var postB: UIButton!
    @IBOutlet weak var FollowingB: UIButton!
    @IBOutlet weak var FollowersB: UIButton!


    @IBOutlet weak var PostsV: UIView!
    @IBOutlet weak var FollowersV: UIView!
    @IBOutlet weak var FollowingV: UIView!

   
//   @IBOutlet weak var numberFollowing: UIButton!
// @IBOutlet weak var numberFollowers: UIButton!
   
   let loggedInUser = Auth.auth().currentUser
   var loggedInUserData:NSDictionary?
   var otherUser:NSDictionary!
   var userProfileData:NSDictionary?
   var databaseRef = Database.database().reference()
   var storageRef = Storage.storage().reference()
   
   var imagePicker = UIImagePickerController()
   //hi
   
   
override func viewDidLoad() {
    super.viewDidLoad()
 //style
 Utilities.styleFilledButton(followButton)
 
    databaseRef.child("Trainers").child("Approved").child(self.loggedInUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
     
     self.loggedInUserData = snapshot.value as? NSDictionary
     self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
     }) { (error) in
         print(error.localizedDescription)
 }
 
 
 
 //add an observer for the user who's profile is being viewed
 //When the followers count is changed, it is updated here!
 //need to add the uid to the user's data
    func getusersprof() {
        
 databaseRef.child("users").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in

     
     let uid = self.otherUser?["uid"] as! String
     self.otherUser = snapshot.value as? NSDictionary
     //add the uid to the profile
     self.otherUser?.setValue(uid, forKey: "uid")
 
 
 }) { (error) in
         print(error.localizedDescription)
 }}
    
 //check if the current user is being followed
 //if yes, Enable the UNfollow button
 //if no, Enable the Follow button
    func getfollowing(){
databaseRef.child("following").child(self.loggedInUser!.uid).child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in

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
 
    
    }
    
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
}

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
   

   internal func setProfilePicture(_ imageView:UIImageView,imageToSet:UIImage)
   {
       imageView.layer.cornerRadius = 10.0
       imageView.layer.borderColor = UIColor.white.cgColor
       imageView.layer.masksToBounds = true
       imageView.image = imageToSet
   }
   
@IBAction func didTapFollow(_ sender: AnyObject) {
    
    
    
    //use ternary operator to check if the profile_picture exists
    //if not set it as nil - firebase will not create a entry for the profile_pic
    let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
    let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
    
    
    if(self.followButton.titleLabel?.text == "متابعة")
    {
        print("follow user")
        
        let loggedInUserProfilePic = self.loggedInUserData?["ProfilePic"] != nil ? self.loggedInUserData?["ProfilePic"]! : nil
        let otherUserProfilePic = self.otherUser?["ProfilePic"] != nil ? self.otherUser?["ProfilePic"]! : nil
        
        let followersData = ["name":self.loggedInUserData?["Name"] as! String,
                    "Username":self.loggedInUserData?["Username"] as! String,
            "ProfilePic": loggedInUserProfilePic]
        
        let followingData = ["Name":self.otherUser?["Name"] as! String,
                             "Username":self.otherUser?["Username"] as! String,
                             "ProfilePic":otherUserProfilePic]
        
        //"profile_pic":self.otherUser?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"] as! String : ""
        let childUpdates = [followersRef:followersData,
                            followingRef:followingData]
        
        
        databaseRef.updateChildValues(childUpdates)
        
        print("data updated")
        
                    
        
        
        //update following count under the logged in user
        //update followers count in the user that is being followed
        let followersCount:Int?
        let followingCount:Int?
        if(self.otherUser?["followersCount"] == nil)
        {
            //set the follower count to 1
            followersCount=1
        }
        else
        {
            followersCount = self.otherUser?["followersCount"] as! Int + 1
        }
        
        //check if logged in user  is following anyone
        //if not following anyone then set the value of followingCount to 1
        if(self.loggedInUserData?["followingCount"] == nil)
        {
            followingCount = 1
        }
            //else just add one to the current following count
        else
        {
        
            followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
        }
    
        databaseRef.child("users").child(self.loggedInUser!.uid).child("followingCount").setValue(followingCount!)
        databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
        
        
    }
    else
    {
       /* databaseRef.child("users").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
        databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(self.otherUser!["followersCount"] as! Int - 1)
        */
      let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
      let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        
        let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
        databaseRef.updateChildValues(childUpdates)
        
        
    }
    
}

}
