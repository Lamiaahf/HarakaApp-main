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
        
        var ref:  DatabaseReference!
        ref = Database.database().reference()
        
        
        let time: Date = Date()
        postCounter = postCounter+1 //this is supposed to be retrieved from user's data and concatanated with their name as the post ID

        let user = Auth.auth().currentUser
        let name = String(user?.email ?? "")
        let charIndex = name.firstIndex(of: "@")
        let username = String(name[..<charIndex!])

        if(name == ""){
            return
        }
        
        var postid = String(user!.uid)
        postid = postid+"\(postCounter)"
        
        ref.child("posts").child(postid).setValue([
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
