//
//  LoginViewController.swift
//  HarakaApp
//
//  Created by lamia on 02/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LOGINViewController: UIViewController {
// L= Login
   
 
    @IBOutlet weak var EmailL: UITextField!
    @IBOutlet weak var PasswordL: UITextField!
    
   
    @IBOutlet weak var Error: UILabel!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    var databaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        hideKeyboardWhenTappedAround()

    }
    func setUpElements() {
    
        Error.alpha = 0
    
        // Style the elements
        Utilities.styleTextField(EmailL)
        Utilities.styleTextField(PasswordL)
        Utilities.styleFilledButton(LoginButton)
    }

    

    @IBAction func loginTapped(_ sender: Any) {
        // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let Email = EmailL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Pass = PasswordL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: Email, password: Pass) { (result, error) in
           if error != nil {
               // Couldn't sign in
              // self.Error.text = error!.localizedDescription
            self.ErrorM(error!.localizedDescription)
              // self.Error.alpha = 1
           }
            
           else {
            
            let uid = Auth.auth().currentUser?.uid
            self.databaseRef.child("Trainers").child("Approved").observeSingleEvent(of: .value, with: { (snapshot) in

                    if snapshot.hasChild(uid!){

                        let ThomeViewController =
                            self.storyboard?.instantiateViewController(withIdentifier:"THomeVC") as? TabBarTViewController
                            
                        
                        self.view.window?.rootViewController = ThomeViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    }else {
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? TabBarViewController
                        
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()

                        }


                })
            
            
           }
            
            
        } }
    
    func ErrorM (_ M: String){
        
        
        switch M {
        
        case "The password is invalid or the user does not have a password.":
            Error.text = "كلمة المرور او البريد الالكتروني غير صحيح"
            self.Error.alpha = 1

        case "The email address is badly formatted." :
            Error.text =  "صيغة البريد الالكتروني غير صحيحه"
            self.Error.alpha = 1
            
        case "There is no user record corresponding to this identifier. The user may have been deleted." :
            Error.text =  "عذرا ليس لديك حساب "
            self.Error.alpha = 1

        default:
            Error.text =  "حدث خطا !"
            self.Error.alpha = 1        }
        
        
    }
    
    

}

     
           

               // Get uid
               // Query database to check if uid belongs to user OR trainer
               
               // if normal user continue lamia's code..
           
               
               
           
        
        // Signing in the user
         
    
/*
 let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
 
 self.view.window?.rootViewController = homeViewController
 self.view.window?.makeKeyAndVisible()
 
 // if trainer:
 // query to check if approved or unapproved
 // if approved -> open homepage
 // if unapproved -> open interface telling user they are not approved, or show dialog message
 
}
else if  (Email == "Daad@ahf.com") {

 
 let ThomeViewController =
     self.storyboard?.instantiateViewController(withIdentifier:"THomeVC") as? MyTabBarCtrl
     
 
 self.view.window?.rootViewController = ThomeViewController
 self.view.window?.makeKeyAndVisible()
 

 
 
 //////
 
 
 self.databaseRef.child("Trainers").child("Approved").observeSingleEvent(of: .value, with: { (snapshot) in

      if snapshot.exists(){
         let ThomeViewController =
             self.storyboard?.instantiateViewController(withIdentifier:"THomeVC") as? MyTabBarCtrl
             
         
         self.view.window?.rootViewController = ThomeViewController
         self.view.window?.makeKeyAndVisible()                    }


 )}
*/

        

