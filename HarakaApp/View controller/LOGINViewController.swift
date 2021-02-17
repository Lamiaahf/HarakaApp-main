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
                
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MyTabBarCtrl
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
