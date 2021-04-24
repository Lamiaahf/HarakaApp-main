//
//  OtherTrainerTable.swift
//  HarakaApp
//
//  Created by lamia on 24/04/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class OtherTrainerTable:  UIViewController ,UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var Profilepic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Username: UILabel!
 
   
   var Rating : [Int]?



   
   let loggedInTrainer = Auth.auth().currentUser
   var loggedInTrainerData:NSDictionary?
   var otherTrainers:NSDictionary!
   var TrainerProfileData:NSDictionary?
   var databaseRef = Database.database().reference()
   var storageRef = Storage.storage().reference()
   var uid = ""
  // var imagePicker = UIImagePickerController()
   //hi
   private let rateViewController = CWRateKitViewController()

   
   override func viewDidLoad() {
       super.viewDidLoad()
    //style
    Utilities.CircularImageView(Profilepic)
    Rating = []
    


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
        
        self.uid = self.otherTrainers?["uid"] as! String
        print(self.uid)

        self.otherTrainers = snapshot.value as? NSDictionary
        //add the uid to the profile
        self.otherTrainers?.setValue(self.uid, forKey: "uid")
    
    
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
                                                                                    
                        
       })

    }
       
   }

   override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
   }
   

@IBAction func ShowActivity(_ sender: Any) {
    let act = self.uid
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TActivity") as? OtherTActivitysTableV
         vc?.otherTrainerID = act
        self.navigationController?.pushViewController(vc!, animated: true)
 }
   
   
   @IBAction func ShowFollowers(_ sender: Any) {
  
       let Trainer = self.uid
       let TF = self.storyboard?.instantiateViewController(withIdentifier: "TFollowers") as? OtherTrainerFollowersTable
           TF?.otherTrainerID = Trainer
           self.navigationController?.pushViewController(TF!, animated: true)
      }
    


}
