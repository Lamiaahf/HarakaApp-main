//
//  AddPostController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 20/02/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPostController: UIViewController{
   
   // Where the user types their posts
    @IBOutlet weak var postText: UITextView!
    var postCounter: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // method used to add the post to the database
    @IBAction func postButton(_ sender: Any) {
        let t = postText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(t == ""){
            return
        }
        
        let ref = Database.database().reference()
        
        
        let time: Date = Date()

        let user = Auth.auth().currentUser
        let UID = user?.uid
        let name = String(user?.email ?? "")
        let charIndex = name.firstIndex(of: "@")
        let username = String(name[..<charIndex!])

        if(name == ""){
            return
        }
        
        ref.child("posts").childByAutoId().setValue(["uid" : UID!,
                                                    "username": username,
                                                    "caption": postText.text!,
                                                    "numOfLikes": 0,
                                                    "numOfComments":0,
                                                    "timestamp": String(describing: time)]) { (error, snapshot) in if let error = error {
            debugPrint("error adding post: \(String(describing: error))")
        }}
        
     //   self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
}
