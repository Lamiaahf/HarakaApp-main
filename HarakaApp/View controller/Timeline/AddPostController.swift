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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // method used to add the post to the database
    @IBAction func postButton(_ sender: Any) {
        
        let ref = Database.database().reference()
        
        let text = postText.text!
        if(text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return
        }
        
        
        
        
        let time: Date = Date()
        let timestamp = time.description
        let user = Auth.auth().currentUser?.uid

        
        ref.child("posts").childByAutoId().setValue([
                                                    "uid": user!,
                                                    "caption": postText.text!,
                                                    "numOfLikes": 0,
                                                    "numOfComments":0,
                                                    "timestamp": timestamp])
        { (error, snapshot) in
            if let error = error {
            debugPrint("error adding post: \(String(describing: error))")}
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
