//
//  AddPostController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 20/02/2021.
//

import UIKit
import FirebaseFirestore

class AddPostController: UIViewController{
   
   // Where the user types their posts
    @IBOutlet weak var postText: UITextView!
    var postCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // method used to add the post to the database
    @IBAction func postButton(_ sender: Any) {
        
        if(postText.text!.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return
        }
        let db = Firestore.firestore()
        let posts = db.collection("Posts")
        let time: Date = Date()
        postCounter = postCounter+1
        guard let user = LOGINViewController().EmailL
        else { return }
        
        var ref = posts.addDocument(data:[
            "caption": postText.text!,
            "username": user,
            "numOfLikes": 0,
            "numOfComments":0,
            "timestamp": time
        ])
        
        TimelineViewController().fetchPosts()
    }
}
