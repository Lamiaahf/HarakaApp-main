//
//  SettingsViewController.swift
//  HarakaApp
//
//  Created by lamia on 01/03/2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var Userimge: UIImageView!
    @IBOutlet weak var TaapToChange: UIButton!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var Save: UIButton!
    
    override func viewDidLoad() {
        databaseRef = Database.database().reference()
         storageRef = Storage.storage().reference()
        super.viewDidLoad()
        setUpElements()
        loadProfileData()


        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(Name)
        Utilities.styleTextField(Age)
        Utilities.styleTextField(Email)
        Utilities.styleFilledButton(Save)
        Utilities.styleFilledButton(Logout)
    }


    @IBAction func Edit(_ sender: Any) {
               updateUsersProfile()
           
    }
    
    @IBAction func Logout(_ sender: Any) {
        let storyboard = UIStoryboard(name : "Main",bundle: nil)
        let LOGINViewController = storyboard.instantiateViewController(identifier: "login")
        present(LOGINViewController, animated: true, completion: nil)
    }
    
    @IBAction func getPhotoFromLibrary(_ sender: Any) {
            //create instance of Image picker controller
            let picker = UIImagePickerController()
            //set delegate
            picker.delegate = self
            //set details
                //is the picture going to be editable(zoom)?
            picker.allowsEditing = false
                //what is the source type
            picker.sourceType = .photoLibrary
                //set the media type
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            //show photoLibrary
            present(picker, animated: true, completion: nil)
        }

        func updateUsersProfile(){
          //check to see if the user is logged in
            if let userID = Auth.auth().currentUser?.uid{
            //create an access point for the Firebase storage
               
                       
                         
                                guard let newNeme  = self.Name.text else {return}
                               
                                let newValuesForProfile =
                                ["Name ": newNeme]
                                
                                //update the firebase database for that user
                                self.databaseRef.child("users").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                    if error != nil{
                                        print(error!)
                                        return
                                    }
                                })
                                
                            
            }}
      
            
        
        func loadProfileData(){
                //if the user is logged in get the profile data
            if let userID = Auth.auth().currentUser?.uid{
                    databaseRef.child("users").child(userID).observe(.value, with: { (snapshot) in
                        
                        //create a dictionary of users profile data
                        let values = snapshot.value as? NSDictionary
                        
                        //if there is a url image stored in photo
               
                    
                        self.Name.text = values?["Name"] as? String
                        self.Age.text = values?["DOB"] as? String
                        self.Email.text = values?["Email"] as? String

                        
                        
            
                    })
                    
                }//end of if
            }//end of loadProfileData
    
} // End of Class
 
