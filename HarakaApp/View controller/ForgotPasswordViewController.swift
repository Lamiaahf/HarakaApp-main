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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()


        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(EmailF)
        Utilities.styleFilledButton(SendF)

       
    }
    
    @IBAction func SendF(_ sender: UIButton) {

        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: EmailF.text!) { (error) in
            if let error = error {
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alert = Service.createAlertController(title: "Hurray", message: "A password reset email has been sent!")
            self.present(alert, animated: true, completion: nil)
        }
    }

}
