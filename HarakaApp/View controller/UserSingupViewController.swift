//
//  UserSingupViewController.swift
//  HarakaApp
//
//  Created by lamia on 03/02/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

// The class will take info forom user and save it in the Firebase
class UserSingupViewController: UIViewController  {

    // US = User Singup
    var ref : DatabaseReference!

    @IBOutlet weak var dismis: UIButton!
    
    @IBOutlet weak var AvatarUS: UIImageView!
    var image :UIImage? = nil

    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    @IBOutlet weak var NameUS: UITextField!
    
    @IBOutlet weak var UsernameUS: UITextField!
    
    @IBOutlet weak var EmailUS: UITextField!
    
    @IBOutlet weak var PasswordUS: UITextField!
    
    @IBOutlet weak var ConfPasswordUS: UITextField!
    //US = User Singup
    @IBOutlet weak var DOBUS: UITextField!
    let DatePicker = UIDatePicker()

    
    @IBOutlet weak var Singup: UIButton!
    @IBOutlet weak var ErrorM: UILabel!

    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        dismis.layer.cornerRadius = dismis.frame.size.width / 2

        setUpElements()
        creatDatePicker()
        setupAvatar()
    }
    
  
    
    // ImagePicker
    @IBAction func TapToChange(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
      // to set profile image
    func setupAvatar (){
        AvatarUS.clipsToBounds = true
        AvatarUS.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(TapToChange))
        AvatarUS.addGestureRecognizer(tapGesture)
    }
    
    
    func setUpElements() {
        ErrorM.alpha = 0
        // Style the elements
        Utilities.styleTextField(NameUS)
        Utilities.styleTextField(UsernameUS)
        Utilities.styleTextField(EmailUS)
        Utilities.styleTextField(PasswordUS)
        Utilities.styleTextField(ConfPasswordUS)
        Utilities.styleTextField(DOBUS)
        Utilities.styleFilledButton(Singup)
        Utilities.CircularImageView(AvatarUS)

    }
 
    // Creat the DatePicker
    func creatDatePicker()  {
        DOBUS.textAlignment = .right
        //toolbare
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem (barButtonSystemItem:.done , target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assining toolbare
        DOBUS.inputAccessoryView = toolbar
        //assinge date pickre to text filde
        DOBUS.inputView = DatePicker
        // date picker mode to remove the time
        DatePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        DOBUS.text = formatter.string(from:DatePicker.date)
        self.view.endEditing(true)
    }
 
    // check thev fields and validat data if everything is correct the methode will return nil otherwise its will return error massge
    func validatefields() -> String?{
    // all fields filled in
        if NameUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            UsernameUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfPasswordUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            DOBUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "الرجاء التأكد من أن جميع الحقول ممتلئة ."
        }
        
        // Check if the password is secure
        let cleanedPassword = PasswordUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return " الرجاء التأكد من ان كلمة المرور تتكون من ٨ خانات تحتوي على حروف وارقام ."
        }


        else if PasswordUS.text != ConfPasswordUS.text {

            //Passwords dont match
            return "كلمة المرور غير متطابقة ."}
        
        else if AvatarUS.image == nil {

            return "فضلا يجب اختيار صورة ."}
      
            return nil}
 
    @IBAction func SignUpTapped(_ sender: Any){
        // to save the image to 
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
            let Name = NameUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Username = UsernameUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Email = EmailUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Password = PasswordUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let ConfPassword = ConfPasswordUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let DOB = DOBUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)
 
            Auth.auth().createUser(withEmail: Email, password: Password) { [self] (result, err) in
                let uid = Auth.auth().currentUser?.uid
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("حدث خطأ !")
                }
                else {
               
                   // User was created successfully, now store the first name and last name
                    guard let user = result?.user else {return}
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

                            let db = ["Name":Name, "Username":"@"+Username, "Email":Email,"DOB":DOB ,"ProfilePic": metaImageUrl]
                            ref.child("users").child(uid!).setValue(db){ _,_  in }
                        } })}
                    self.transitionToHome()

                }}}}
                
    
    func showError(_ message : String )  {
        ErrorM.text = message
        ErrorM.alpha = 1
    }
    
    
    // after user singup this method will take him to the home page
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? TabBarViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }

    @IBAction func dismis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
}//End of class

extension UserSingupViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    
