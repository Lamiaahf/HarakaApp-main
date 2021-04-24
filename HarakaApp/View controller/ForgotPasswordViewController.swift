//
//  ForgotPasswordViewController.swift
//  HarakaApp
//
//  Created by lamia on 02/02/2021.
//

import UIKit
import Firebase 

class ForgotPasswordViewController: UIViewController {
// F=Forgot Password
    @IBOutlet weak var EmailF: UITextField!
    @IBOutlet weak var SendF: UIButton!
    @IBOutlet weak var ErrorL: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()


        // Do any additional setup after loading the view.
    }
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(EmailF)
        Utilities.styleFilledButton(SendF)
        ErrorL.alpha = 0

       
    }
    
    @IBAction func SendF(_ sender: UIButton) {

        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: EmailF.text!) { (error) in
            if let error = error {
                self.ErrorM(error.localizedDescription)
            return
            }
            
            let alert = Service.createAlertController(title: "تم بنجاح", message: " ارسال بريد اعادة ضبط كلمة المرور ")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func ErrorM (_ M: String){
        
        
        switch M {
        
        case "An email address must be provided.":
            ErrorL.text = "كلمة المرور او البريد الالكتروني غير صحيح"
            self.ErrorL.alpha = 1

        case "The email address is badly formatted." :
            ErrorL.text =  "صيغة البريد الالكتروني غير صحيحه"
            self.ErrorL.alpha = 1
            
        case "There is no user record corresponding to this identifier. The user may have been deleted." :
            ErrorL.text =  "عذرا ليس لديك حساب "
            self.ErrorL.alpha = 1

        default:
            ErrorL.text =  "حدث خطا !"
            self.ErrorL.alpha = 1        }
        
        
    }

}
