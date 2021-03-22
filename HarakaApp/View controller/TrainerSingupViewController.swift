//
//  TrainerSingupViewController.swift
//  HarakaApp
//
//  Created by lamia on 10/02/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TrainerSingupViewController: UIViewController {
// TS = SingupTrainer
    @IBOutlet weak var AvatarUS: UIImageView!
    var image :UIImage? = nil
    @IBOutlet weak var tapToChangeProfileButton: UIButton!

    @IBOutlet weak var NameTS: UITextField!
    @IBOutlet weak var UsernameTS: UITextField!
    @IBOutlet weak var EmailTS: UITextField!
    @IBOutlet weak var PasswordTS: UITextField!
    @IBOutlet weak var ConfpasswordTS: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var LinkedinTS: UITextField!
   private  var ref : DatabaseReference!

    
   
    @IBOutlet weak var ErrorM: UILabel!
    
    @IBOutlet weak var Singup: UIButton!
    /* @IBOutlet  var multiRadioButton:[ UIButton]!{
        didSet{
            multiRadioButton.forEach { (button) in
                button.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
                button.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
            }
        }
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        ref = Database.database().reference()

    }
    
    func setUpElements() {
    
        ErrorM.alpha = 0

    
        // Style the elements
        Utilities.styleFilledButton(Singup)
        Utilities.styleTextField(NameTS)
        Utilities.styleTextField(UsernameTS)
        Utilities.styleTextField(EmailTS)
        Utilities.styleTextField(PasswordTS)
        Utilities.styleTextField(ConfpasswordTS)
        Utilities.styleTextField(Age)
        Utilities.styleTextField(LinkedinTS)
        Utilities.styleFilledButton(Singup)


    }
    
    func setupAvatar (){
        AvatarUS.layer.cornerRadius = 40
        AvatarUS.clipsToBounds = true
        AvatarUS.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(TapToChange))
        AvatarUS.addGestureRecognizer(tapGesture)
    }
    
    // ImagePicker
     
    @IBAction func TapToChange(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
        
    }
  
    func validatefields() -> String?{
    // all fields filled in
        if NameTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            UsernameTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfpasswordTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||       LinkedinTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Age.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "الرجاء التأكد من أن جميع الحقول ممتلئة ."
        }
        
        // Check if the password is secure
        let cleanedPassword = PasswordTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return " الرجاء التأكد من ان كلمة المرور تتكون من ٨ خانات تحتوي على حروف وارقام ."
        }

            
        else if PasswordTS.text != ConfpasswordTS.text {

                    //Passwords dont match
            return "كلمة المرور غير متطابقة ."}
        
        let age = Int(Age.text!)
           if (age! < 18 || age! > 60 )  {

                    // the age should be  18-60
            return "عذرا ، لكن يجب ان يكون عمرك ما بين ١٨-٦٠"}

            
        
            return nil}
    
  
    //
    @IBAction func SingUpTapped(_ sender: Any) {
        guard let imageSelected = self.image else {return}
        guard let  imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
    
        // Validate the fields
        let error = validatefields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let Name = NameTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Username = UsernameTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Email = EmailTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Password = PasswordTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = Age.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Linkdein = LinkedinTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Create the user
            Auth.auth().createUser(withEmail: Email, password: Password) { [self] (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("حدث خطأ !")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                   
                    
                    guard let user = result?.user else {return}

                       let db = ["Name":Name, "Username":Username, "Email":Email,"Password":Password,"Linkdein":Linkdein,"Age":age,"uid": result!.user.uid ]
                    // save the image to firbase Storage and user
                    let storageRef = Storage.storage().reference(forURL: "gs://haraka-73619.appspot.com")
                     let StorageProfilrRef  = storageRef.child("Profile").child(user.uid)
                     let metaData = StorageMetadata()
                    
                    metaData.contentType = "image/jpg"
                    StorageProfilrRef.putData( imageData ,metadata: metaData) { (StorageMetadata, error) in
                        if error != nil {return}
                        // save image url as string
                        StorageProfilrRef.downloadURL(completion: {(url , error ) in
                        if let metaImageUrl = url?.absoluteString {

                    let db = ["Name":Name, "Username":Username, "Email":Email,"Password":Password,"Age":age ,"ProfilePic": metaImageUrl,"uid":user.uid ]
                            ref.child("Trainers").childByAutoId().setValue(db){_,_ in }
                        } })}
                    
                    self.transitionToHome()

                        
                        if error != nil {
                            // Show error message
                            self.showError("حدث خطأ ما !!")}
                        
                        }}}}
                        

    func showError(_ message : String )  {
        ErrorM.text = message
        ErrorM.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
    
extension TrainerSingupViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any ]) {
        if let imageSelected = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {          image = imageSelected
                      AvatarUS.image = imageSelected }
        if let imageOrignal = info[UIImagePickerController.InfoKey.originalImage] as?
        UIImage {
            image = imageOrignal

            AvatarUS.image = imageOrignal
        }
        picker.dismiss(animated: true , completion: nil)
    }}
    
    
