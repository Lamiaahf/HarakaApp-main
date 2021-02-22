//
//  AddPostController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 20/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddPostController: UIViewController{
   
   // Where the user types their posts
    @IBOutlet weak var postText: UITextView!
    var postCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // method used to add the post to the database
    @IBAction func postButton(_ sender: Any) {
        let t = postText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(t == ""){
            return
        }
        let db = Firestore.firestore()
        let posts = db.collection("Posts")
        let time: Date = Date()
        postCounter = postCounter+1
     //   let user = LOGINViewController().EmailL.text!.trimmingCharacters(in: //.whitespacesAndNewlines)
        let user = "Njood"
        if(user == ""){
            return
        }
        
        posts.addDocument(data:[
            "caption": postText.text!,
            "username": user,
            "numOfLikes": 0,
            "numOfComments":0,
            "timestamp": time
        ]) { (err) in
            if let err = err {
                debugPrint("error adding document: \(err)")
            }
        }
     //   self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
}
