//
//  TrainerSettings.swift
//  HarakaApp
//
//  Created by lamia on 31/03/2021.
//

import UIKit
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class TrainerSettings: UIViewController, UINavigationControllerDelegate{
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var Timge: UIImageView!
    
    @IBOutlet weak var NameSett: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var LogoutB: UIButton!
    @IBOutlet weak var SaveB: UIButton!
    
    override func viewDidLoad() {
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        super.viewDidLoad()
        setUpElements()
        loadProfileData()
        saveChanges()


        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(NameSett)
        Utilities.styleTextField(Age)
        Utilities.styleTextField(Email)
        Utilities.styleFilledButton(SaveB)
        Utilities.styleFilledButton(LogoutB)
    }


    @IBAction func Edit(_ sender: Any) {
               updateUsersProfile()
    }
    
    @IBAction func Logout(_ sender: Any) {
        let storyboard = UIStoryboard(name : "Main",bundle: nil)
        let LOGINViewController = storyboard.instantiateViewController(identifier: "login")
        present(LOGINViewController, animated: true, completion: nil)
    }
    

        func updateUsersProfile(){
          //check to see if the user is logged in
            if let userID = Auth.auth().currentUser?.uid{
            //create an access point for the Firebase storage
               
                       
                         
                guard let newNeme  = self.NameSett.text else {return}
                              //  let newValuesForProfile =
                                  //  [NameSett : newNeme]
                                
                                //update the firebase database for that user
                self.databaseRef.child("Trainers").child("Approved").child(userID).updateChildValues(["Name": newNeme], withCompletionBlock: { (error, ref) in
                                    if error != nil{
                                        print(error!)
                                        return
                                    }
                                })//updateChildValues
                                
                            
            } }
        
      
            
        
        func loadProfileData(){
                //if the user is logged in get the profile data
            if let userID = Auth.auth().currentUser?.uid {
                databaseRef.child("Trainers").child("Approved").child(userID).observe(.value, with: { (snapshot) in
                        
                        //create a dictionary of users profile data
                        let values = snapshot.value as? NSDictionary
                        
                        //if there is a url image stored in photo
               
                    
                        self.NameSett.text = values?["Name"] as? String
                        self.Age.text = values?["DOB"] as? String
                        self.Email.text = values?["Email"] as? String

                        
                        
            
                    })
                    
                }//end of if
            }//end of loadProfileData
    
    func saveChanges(){
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("profile").child(imageName)
        
        if let uploadData = self.Timge.image!.pngData()
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["profilepic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
    
} // End of Class
 
