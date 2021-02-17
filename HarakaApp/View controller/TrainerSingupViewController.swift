//
//  TrainerSingupViewController.swift
//  HarakaApp
//
//  Created by lamia on 10/02/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TrainerSingupViewController: UIViewController {
// TS = SingupTrainer
    @IBOutlet weak var NameTS: UITextField!
    @IBOutlet weak var UsernameTS: UITextField!
    @IBOutlet weak var EmailTS: UITextField!
    @IBOutlet weak var PasswordTS: UITextField!
    @IBOutlet weak var ConfpasswordTS: UITextField!
    @IBOutlet weak var DOB: UITextField!
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
        Utilities.styleTextField(DOB)
        Utilities.styleTextField(LinkedinTS)
        Utilities.styleFilledButton(Singup)


    }
    func creatDatePicker()  {
        DOB.textAlignment = .right
        //toolbare
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem (barButtonSystemItem:.done , target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assining toolbare
        DOB.inputAccessoryView = toolbar
        //assinge date pickre to text filde
        DOB.inputView = DatePicker
        // date picker mode to remove the time
        DatePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        DOB.text = formatter.string(from:DatePicker.date)
        self.view.endEditing(true)
    }
    func validatefields() -> String?{
    // all fields filled in
        if NameTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            UsernameTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfpasswordTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||       LinkedinTS.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || DOB.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
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
        
    
    
    @IBAction func SingUpTapped(_ sender: Any) {
    
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
           let BOD = DOB.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Linkdein = LinkedinTS.text!.trimmingCharacters(in: .whitespacesAndNewlines)

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

                    db.collection("Trainers").addDocument(data: ["Name":Name, "Username":Username, "Email":Email,"Password":Password,"Linkdein":Linkdein,"DOB":BOD,"uid": result!.user.uid ]) { (error) in
                        
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
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
    
    //Handle with single Action
 /*  @IBAction func maleFemaleAction(_ sender: UIButton) {
        uncheck()
        sender.CBAnimation {
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
    
}


extension UIButton {
    //MARK:- Animate check mark //CBAnimation =checkboxAnimation
    func  CBAnimation(closure: @escaping () -> Void){
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
 */
