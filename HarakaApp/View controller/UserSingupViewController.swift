//
//  UserSingupViewController.swift
//  HarakaApp
//
//  Created by lamia on 03/02/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserSingupViewController: UIViewController {//Start of class
// US = User Singup
 
    @IBOutlet weak var AvatarUS: UIImageView!
    @IBOutlet weak var NameUS: UITextField!
    
    @IBOutlet weak var UsernameUS: UITextField!
    
    @IBOutlet weak var EmailUS: UITextField!
    
    @IBOutlet weak var PasswordUS: UITextField!
    
    @IBOutlet weak var ConfPasswordUS: UITextField!
    // BOD = DOB
    @IBOutlet weak var BODUS: UITextField!
    let DatePicker = UIDatePicker()

    @IBOutlet weak var Singup: UIButton!
    
    
    @IBOutlet weak var ErrorM: UILabel!
    @IBOutlet  var multiRadioButton: [UIButton]!{
        didSet{
            multiRadioButton.forEach { (button) in
                button.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
                button.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        creatDatePicker()
        
    }
    func setUpElements() {
    
        ErrorM.alpha = 0

    
        // Style the elements
        Utilities.styleTextField(NameUS)
        Utilities.styleTextField(UsernameUS)
        Utilities.styleTextField(EmailUS)
        Utilities.styleTextField(PasswordUS)
        Utilities.styleTextField(ConfPasswordUS)
        Utilities.styleTextField(BODUS)
        Utilities.styleFilledButton(Singup)
    }
    
    
    func setupAvatar() {
        AvatarUS.layer.cornerRadius = 40
        AvatarUS.clipsToBounds = true
        AvatarUS.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        AvatarUS.addGestureRecognizer(tapgesture)}
    
    
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func creatDatePicker()  {
        BODUS.textAlignment = .right
        //toolbare
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem (barButtonSystemItem:.done , target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assining toolbare
        BODUS.inputAccessoryView = toolbar
        //assinge date pickre to text filde
        BODUS.inputView = DatePicker
        // date picker mode to remove the time
        DatePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        BODUS.text = formatter.string(from:DatePicker.date)
        self.view.endEditing(true)
    }
    
  
    
    //Handle with single Action
    @IBAction  func maleFemaleAction(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
        
        // NOTE:- here you can recognize with tag weather it is `Male` or `Female`.
        print(sender.tag)
    }
    
    func uncheck(){
        multiRadioButton.forEach { (button) in
            button.isSelected = false
        }
    }
    // check thev fields and validat data if everything is correct the methode will return nil otherwise its will return error massge
    func validatefields() -> String?{
    // all fields filled in
        if NameUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            UsernameUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfPasswordUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        BODUS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
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

            
        
            return nil}
        
    
    
    @IBAction func SignUpTapped(_ sender: Any) {
    
        
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
            let DOB = BODUS.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Create the user
            Auth.auth().createUser(withEmail: Email, password: Password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("حدث خطأ !")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                     let db = Firestore.firestore()

                    db.collection("users").addDocument(data: ["Name":Name, "Username":Username, "Email":Email,"Password":Password,"ConfPasswordUS":ConfPassword,"DOB":DOB,"uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                         //   self.showError("حدث خطأ ما !!")
                            self.ErrorM.text = error!.localizedDescription

                        }
                    }
                    self.transitionToHome()

                }
                
            }
            
            
            
        }
    }
    func showError(_ message : String )  {
        ErrorM.text = message
        ErrorM.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
  
}//End of class

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
    
}
extension UserSingupViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
     func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info :[UIImagePickerController.InfoKey : Any]){
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {   AvatarUS.image = imageSelected
        }
        if let imageOriginal = info [UIImagePickerController.InfoKey.originalImage] as?
        UIImage {
            AvatarUS.image = imageOriginal}
        
    picker.dismiss (animated :true , completion : nil)
    }}
    
    
    
    
    

