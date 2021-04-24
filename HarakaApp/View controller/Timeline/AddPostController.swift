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
        hideKeyboardWhenTappedAround()
    }
    
    // Method used to add the post to the database
    @IBAction func postButton(_ sender: Any) {
        
        // Create a reference to the database
        let ref = Database.database().reference()
        
        // Retrieve post test and making sure its not empty
        let text = postText.text!
        if(text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return
        }
        
        // Create timestamp
        let time: Date = Date()
        let timestamp = time.description
        
        // Retrieve current user's id
        let user = Auth.auth().currentUser?.uid

        // Add the post to the database under the "posts" child, with a generated id
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
        
        // Dismiss page
        self.dismiss(animated: true, completion: nil)
        
    }
}
