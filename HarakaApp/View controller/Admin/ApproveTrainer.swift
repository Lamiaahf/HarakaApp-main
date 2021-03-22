//
//  ApproveTrainer.swift
//  HarakaApp
//
//  Created by lamia on 22/03/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ApproveTrainer: UIViewController {
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var approveTextView: UITextView!
    
    var approveSubject: Trainner?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        approveTextView.text = "Specialist Infromation: \n\n\nName:" + approveSubject!.TName! + "\n\n\nUsername:" + approveSubject!.Tusername! + "\n\n\nAge:" + approveSubject!.TAge! + "\n\n\nLinked In Account:" + approveSubject!.TLinkedin! + "\n\n\nEmail:" + approveSubject!.TEmail!
        
        approveTextView.isEditable = false
    }
    
    
    
    @IBAction func accept(_ sender: Any) {
        
        //creat specialist
        Auth.auth().createUser(withEmail: approveSubject!.TEmail! , password: approveSubject!.TPassword!) { (result, err) in
    
            if err != nil {
                print("Error creating Specialist")
            } else{
            // add specialist to database
  self.ref?.child("Trainers").child("Approved").child(result!.user.uid).setValue(["name":self.approveSubject?.TName, "age":self.approveSubject?.TAge,"Username":self.approveSubject?.Tusername,"linkedin":self.approveSubject?.TLinkedin])
            

        //send approval to specialist
        Auth.auth().currentUser?.sendEmailVerification { (error) in
        }
         
        // remove specialist from unapproved
        self.ref?.child("Trainers").child("Unapproved").child(self.approveSubject!.autoKey!).removeValue()
        
        
        let alert = UIAlertController(title: "تم القبول", message: nil, preferredStyle: UIAlertController.Style.alert)
        
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.doSomething))
        self.present(alert, animated: true, completion: nil)
        }
            
        }//result
        
    }
    
    func doSomething(action:UIAlertAction) {
        
        /// present the next VC
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ApproveVC") as? ShowTrainner
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func regect(_ sender: Any) {
        // remove specialist from unapproved
        self.ref?.child("Trainers").child("Unapproved").child(self.approveSubject!.autoKey!).removeValue()
        
        let alert = UIAlertController(title: "تم الرفض", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: doSomething))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


