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

    
      // @IBOutlet weak var bodyTextView: UITextView!
       
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var DOB: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var link: UILabel!
    
    @IBOutlet weak var reject: UIButton!
    @IBOutlet weak var Accept: UIButton!
    
       var approveSubject: Trainner?
       var ref: DatabaseReference!
       var databaseHandle: DatabaseHandle?
       var name: String?
       var age: String?
       var username: String?
       var Linkedin: String?
       var Email: String?
       var Pass: String?
       var Tpic : String?

   // var autoKey: String?

       override func viewDidLoad() {
           super.viewDidLoad()
      
        Utilities.styleFilledButton(Accept)
        Utilities.styleFilledButton(reject)


           ref = Database.database().reference()
        let path = ref?.child("Trainers").child("Unapproved")
        
        databaseHandle = path?.observe(.childAdded, with: { [self] (snapshot) in
            
            let dict = snapshot.value as! NSDictionary
           // let key = snapshot.key
            self.name = dict["Name"] as? String
            self.age = dict["DOB"] as? String
            self.username = dict["Username"] as? String
            self.Linkedin = dict["Linkedin"] as? String
            self.Email = dict["Email"] as? String
            self.Pass = dict["Password"] as? String
            self.Tpic = dict["ProfilePic"] as? String
            
            self.Name.text = name
            self.Username.text = username
            self.DOB.text = age
            self.email.text = Email
            self.link.text = Linkedin

            
            
                                        })
   
        }
       
      
       
       @IBAction func accept(_ sender: Any) {
           
           //creat specialist
            /*Auth.auth().createUser(withEmail: approveSubject!.TEmail! , password: approveSubject!.TPassword!)*/
        Auth.auth().createUser(withEmail: self.Email! , password: self.Pass! ){ (result, err) in
       
              if err != nil {
                print(err?.localizedDescription as Any)
            } else
               {
               // add specialist to database
                self.ref.child("Trainers").child("Approved").child(result!.user.uid).setValue(["Name":self.name, "DOB":self.age,"Username":self.username,"linkedin":self.Linkedin ,"Email" : self.Email,"ProfilePic": self.Tpic])
               

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
       
    
       
       @IBAction func regect(_ sender: Any) {
           // remove specialist from unapproved
           self.ref?.child("Trainers").child("Unapproved").child(self.approveSubject!.autoKey!).removeValue()
           
           let alert = UIAlertController(title: "تم الرفض", message: nil, preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: doSomething))
           self.present(alert, animated: true, completion: nil)
       }
       
       
   }



    
