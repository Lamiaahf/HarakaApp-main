//
//  OtherTrainersViewController.swift
//  HarakaApp
//
//  Created by ohoud on 15/08/1442 AH.
//lamia



import UIKit
import Firebase
import FirebaseStorage
// master
class OtherTrainersViewController: UIViewController ,UINavigationControllerDelegate, UITextFieldDelegate {
     @IBOutlet weak var Profilepic: UIImageView!
     @IBOutlet weak var name: UILabel!
     @IBOutlet weak var Username: UILabel!
     @IBOutlet weak var followButton: UIButton!
  
    
    @IBOutlet weak var RateLable: UILabel!
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
     Utilities.styleFilledButton(followButton)
     Utilities.CircularImageView(Profilepic)
     Rating = []
     getRatings()
     


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
                //self.getRate()

                self.otherTrainers = snapshot.value as? NSDictionary
                //add the uid to the profile
                self.otherTrainers?.setValue(self.uid, forKey: "uid")
            
            
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
            }
               
               rateViewController.delegate = self
               rateViewController.modalPresentationStyle = .overFullScreen
               
               rateViewController.confirmRateEnabled = true
               
               rateViewController.showHeaderImage = true
               rateViewController.headerImage = UIImage(named: "initial_smile")
               rateViewController.headerImageIsStatic = false
               rateViewController.headerImages = [
                   UIImage(named: "smile_1"),
                   UIImage(named: "smile_2"),
                   UIImage(named: "smile_3"),
                   UIImage(named: "smile_4"),
                   UIImage(named: "smile_5")
               ]
               
               rateViewController.submitTextColor = .gray
               rateViewController.submitText = "ارسال "

        getRatings()
           }
    
    func getRatings(){
        
        let tid = self.otherTrainers?["uid"] as! String
        self.RateLable.text = "-"
        
        Database.database().reference().child("Rating").queryOrderedByKey().queryEqual(toValue: tid).observe(.childAdded, with:{
            snapshot in
            
            if(snapshot.exists()){
                var sum = 0
                var count = Int(snapshot.childrenCount)
                
                for snapsh in snapshot.children.allObjects as! [DataSnapshot]{
                    let dict = snapsh.value as? [String:Any]
                  //  var k = dict?.keys.first as! String
                   // var val = dict![k] as? [String:Any]
                  //  var val = dict?.values.first as? [String:Any]
                    let rt = dict!["Rate"] as? Int
                    sum = sum+rt!
                }
                
                var rating = Double(sum)/Double(count)
                self.RateLable.text = (String(format: "%.2f", rating))
            }
          
        } )
        
    }

           override func didReceiveMemoryWarning() {
               super.didReceiveMemoryWarning()
               // Dispose of any resources that can be recreated.
           }
           

        
           
           
           @IBAction func openRateView(_ sender: Any) {
               present(rateViewController, animated: true, completion: nil)
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
                
            }
                
            else{
              let followersRef = "followers/\(self.otherTrainers?["uid"] as! String)/\(self.loggedInTrainerData?["uid"] as! String)"
              let followingRef = "following/" + (self.loggedInTrainerData?["uid"] as! String) + "/" + (self.otherTrainers?["uid"] as! String)
                
                
                let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
                databaseRef.updateChildValues(childUpdates)
                
                
            }
            
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
    
    @IBAction func ShowChallenges(_ sender: Any) {
   
        let Trainer = self.uid
        let TF = self.storyboard?.instantiateViewController(withIdentifier: "TChallenges") as? OtherTrainerChallengesTable
            TF?.otherTrainerID = Trainer
            self.navigationController?.pushViewController(TF!, animated: true)
       }
            
        func getRatings(){
            
            let tid = self.otherTrainers?["uid"] as! String
            self.RateLable.text = "-"
            
            Database.database().reference().child("Rating").queryOrderedByKey().queryEqual(toValue: tid).observe(.childAdded, with:{
                snapshot in
                
                if(snapshot.exists()){
                    var sum = 0
                    var count = Int(snapshot.childrenCount)
                    
                    for snapsh in snapshot.children.allObjects as! [DataSnapshot]{
                        let dict = snapsh.value as? [String:Any]
                      //  var k = dict?.keys.first as! String
                       // var val = dict![k] as? [String:Any]
                      //  var val = dict?.values.first as? [String:Any]
                        let rt = dict!["Rate"] as? Int
                        sum = sum+rt!
                    }
                    
                    var rating = Double(sum)/Double(count)
                    self.RateLable.text = (String(format: "%.2f", rating))
                }
              
            } )
        
        }}

    extension OtherTrainersViewController: CWRateKitViewControllerDelegate {

           func didChange(rate: Int) {
               print("Current rate is \(rate)")
           }

           func didSubmit(rate: Int) {
               print("Submit with rate \(rate)")

               databaseRef.child("Rating").child(uid).child(loggedInTrainer!.uid).setValue(["Rate": rate])
               
           }
           
           func didDismiss() {
               print("Dismiss the rate view")
           }
           
       }
