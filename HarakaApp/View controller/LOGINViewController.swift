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
   
    @IBOutlet weak var ForgotPass: UIButton!
    
    @IBOutlet weak var Error: UILabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var Singupform: UIButton!
    var databaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()



    }
    func setUpElements() {
    
        Error.alpha = 0
    
        // Style the elements
        Utilities.styleTextField(EmailL)
        Utilities.styleTextField(PasswordL)
        Utilities.styleFilledButton(login)
    }

    

    @IBAction func loginTapped(_ sender: Any) {
        
        // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let Email = EmailL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Pass = PasswordL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: Email, password: Pass) { (result, error) in
           if error != nil {
               // Couldn't sign in
               self.Error.text = error!.localizedDescription
               self.Error.alpha = 1
           }
            
           else {
            
            let uid = Auth.auth().currentUser?.uid
            self.databaseRef.child("Trainers").child("Approved").observeSingleEvent(of: .value, with: { (snapshot) in

                    if snapshot.hasChild(uid!){

                        let ThomeViewController =
                            self.storyboard?.instantiateViewController(withIdentifier:"THomeVC") as? MyTabBarCtrl
                            
                        
                        self.view.window?.rootViewController = ThomeViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    }else {
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
                        
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()

                        }


                })
            
            
           }
            
            
        } }}

     
           

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

        

