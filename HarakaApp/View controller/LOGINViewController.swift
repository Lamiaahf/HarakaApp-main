//
//  LoginViewController.swift
//  HarakaApp
//
//  Created by lamia on 02/02/2021.
//

import UIKit
import FirebaseAuth

class LOGINViewController: UIViewController {
// L= Login
    @IBOutlet weak var EmailL: UITextField!
    @IBOutlet weak var PasswordL: UITextField!
   
    @IBOutlet weak var ForgotPass: UIButton!
    
    @IBOutlet weak var Error: UILabel!
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var Singupform: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
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
        
        // Signing in the user
        Auth.auth().signIn(withEmail: Email, password: Pass) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.Error.text = error!.localizedDescription
                self.Error.alpha = 1
            }
            else {
                // Get uid
                // Query database to check if uid belongs to user OR trainer
                
                // if normal user continue lamia's code..
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
                // if trainer:
                // query to check if approved or unapproved
                // if approved -> open homepage
                // if unapproved -> open interface telling user they are not approved, or show dialog message
                
            }
        }
    }
    
    
}
/*
Auth.auth()?.signIn(withEmail:Email , password: pass, completion: {
    (user, error) in
        // If there's no errors
        if error == nil {
            // Get the type from the database. It's path is users/<userId>/type.
            // Notice "observeSingleEvent", so we don't register for getting an update every time it changes.
            Database.database().reference().child("users/\(user!.uid)/type").observeSingleEvent(of: .value, with: {
                (snapshot) in

                switch snapshot.value as! String {
                // If our user is admin...
                case "Trainer":
                    // ...redirect to the admin page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "adminVC")
                    self.present(vc!, animated: true, completion: nil)
                // If out user is a regular user...
                case "user":
                    // ...redirect to the user page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "userVC")
                    self.present(vc!, animated: true, completion: nil)
                // If the type wasn't found...
                default:
                    // ...print an error
                    print("Error: Couldn't find type for user \(user!.uid)")
                }
           })
       }
   })
*/
