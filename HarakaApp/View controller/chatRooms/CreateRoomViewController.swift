//
//  CreateRoomViewController.swift
//  HarakaApp
//
//  Created by ohoud on 16/08/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateRoomViewController: UIViewController {

    @IBOutlet weak var newRoomTextField: UITextField!
        @IBOutlet weak var dismissButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()

           dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        }

        @IBAction func dismissSecondVC(_ sender: AnyObject) {
            
            self.dismiss(animated: true, completion: nil)
        
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

    
@IBAction func didPressCreateNewRoom(_ sender: UIButton) {
    guard let userId = Auth.auth().currentUser?.uid, let roomName = self.newRoomTextField.text, roomName.isEmpty == false else {
        return    }
    self.newRoomTextField.resignFirstResponder()
    
    let databaseRef = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()

    let roomRef = databaseRef.child("rooms").childByAutoId()
    let roomData:[String: Any] = ["creatorId" : userId, "name": roomName]
    
    roomRef.setValue(roomData) { (err, ref) in
        if(err == nil){
            self.newRoomTextField.text = ""
          
        }
    }
    
}

    }
