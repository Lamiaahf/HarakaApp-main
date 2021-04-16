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
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    var image :UIImage? = nil
    private  var ref : DatabaseReference!


    @IBOutlet weak var NameTS: UITextField!
    @IBOutlet weak var UsernameTS: UITextField!
    @IBOutlet weak var EmailTS: UITextField!
    @IBOutlet weak var PasswordTS: UITextField!
    @IBOutlet weak var ConfpasswordTS: UITextField!
    @IBOutlet weak var Age: UITextField!
    let DatePicker = UIDatePicker()
    @IBOutlet weak var LinkedinTS: UITextField!

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
        creatDatePicker()


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
    
    // creatDatePicker inside TextFilde
    func creatDatePicker()  {
        Age.textAlignment = .right
        //toolbare
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem (barButtonSystemItem:.done , target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assining toolbare
        Age.inputAccessoryView = toolbar
        //assinge date pickre to text filde
        Age.inputView = DatePicker
        // date picker mode to remove the time
        DatePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        Age.text = formatter.string(from:DatePicker.date)
        self.view.endEditing(true)
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
            
                    // User was created successfully, now store the user info
                   
                  // guard let user = result?.user else {return}


                    // save the image to firbase Storage and user
                    let storageRef = Storage.storage().reference(forURL: "gs://haraka-73619.appspot.com")
                  let StorageProfilrRef  = storageRef.child("Profile")
                    //.child(currentUser.uid)
                     let metaData = StorageMetadata()
                    
                    metaData.contentType = "image/jpg"
                    StorageProfilrRef.putData( imageData ,metadata: metaData) { (StorageMetadata, error) in
                        if error != nil {print (error?.localizedDescription)}
                        // save image url as string
                        StorageProfilrRef.downloadURL(completion: {(url , error ) in
                        if let metaImageUrl = url?.absoluteString {
                            
                            let db = ["Name":Name, "Username":"@"+Username, "Email":Email,"Linkedin":Linkdein,"ProfilePic": metaImageUrl,"Age":age,"Password":Password ]

                            self.ref?.child("Trainers").child("Unapproved").childByAutoId().setValue(db)
                            let alert = UIAlertController(title: " رفع طلبك بنجاح  ", message: nil, preferredStyle: UIAlertController.Style.alert)
                            
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.transitionLogIn))
                            self.present(alert, animated: true, completion: nil)

                        } })

                    }
                    
                   // self.transitionToHome()

                        
                        if error != nil {
                            // Show error message
                            self.showError("حدث خطأ ما !!")}
                        
                        }}
                        

    func showError(_ message : String )  {
        ErrorM.text = message
        ErrorM.alpha = 1
    }
    
    func transitionLogIn(action:UIAlertAction) {
                 
         /// present the next VC
         let vc = self.storyboard?.instantiateViewController(withIdentifier:"login") as? LOGINViewController
         
         self.view.window?.rootViewController = vc
         self.view.window?.makeKeyAndVisible()
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
    
    
