//
//  AdminLogin.swift
//  HarakaApp
//
//  Created by lamia on 17/03/2021.
//

import UIKit
import FirebaseAuth

class AdminLogin: UIViewController {

    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    
    @IBOutlet weak var LoginButton: UIButton!
        
    @IBOutlet weak var Error: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    
    func setUpElements() {
        Error.alpha = 0 // to hide the error label
        Utilities.styleTextField(Email)
        Utilities.styleTextField(Password)
        Utilities.styleFilledButton(LoginButton)
        
    }
    @IBAction func LoginTapped(_ sender: Any) {
        
    
        //create cleaned user data
        let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //signing in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            
            if email != "Harakaappsa@gmail.com"{
                //couldn't signin
                self.Error.text = "ليس لديك صلاحية للدخول"
                self.Error.alpha = 1
            } else
            if error != nil{
                //couldn't signin
                self.Error.text = "الرجاء ادخال البريد الالكتروني وكلمة المرور الصحيحة"
                self.Error.alpha = 1
            }
                
           else {
                
                
                
                //transition to next screen
                let adminViewController =
                    self.storyboard?.instantiateViewController(withIdentifier:"ApproveVC") as? ShowTrainner
                    
                
                self.view.window?.rootViewController = adminViewController
                self.view.window?.makeKeyAndVisible()
                
                
            }
 
        }
  
    }
  

}

