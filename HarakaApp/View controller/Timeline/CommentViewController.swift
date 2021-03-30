//
//  CommentViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 21/03/2021.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var comments: [Comment]?
    var post: Post?
    
//    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTable.dataSource = self
        commentsTable.delegate = self
        commentsTable.separatorStyle = .none
        commentsTable.estimatedRowHeight = commentsTable.rowHeight
        commentsTable.rowHeight = UITableView.automaticDimension
        
        comments = []
        fetchComments()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = comments{
            return comments.count
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTable.dequeueReusableCell(withIdentifier:"CommentCell", for: indexPath) as! CommentCell
        cell.comment = comments![indexPath.row]
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
    @IBAction func postComment(_ sender: Any) {
        
        let text = commentField.text!
        if(text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return
        }
        
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser!
        
        
        ref.child("Comments").child((post?.postID)!).childByAutoId().setValue([
                "username":user.email,
                "uid":user.uid,
                "comment":text])
        
        commentField.text = ""
        // after utilities is finished, append this comment to array after retrieving User and creating comment object
     //   fetchComments()
    }
    
    func fetchComments(){
        
        comments = []
        let ref = Database.database().reference()
        ref.child("Comments").child((post?.postID)!).observe(.childAdded){
        (snapshot) in
            if snapshot.exists(){
                if let commentDict = snapshot.value as? [String: Any]{
                    if let usern = commentDict["username"] as? String {
                       //     let uid = commentDict["uid"] as? String ?? ""
                            let comment = commentDict["comment"] as? String ?? ""
                //            let id = String(snapshot.key)
                            
                        let commentUser = User(u: usern, p: UIImage(named: "icons8-user-male-480"))
                        let newComment = Comment(writtenBy: commentUser, commentText:comment)
                            self.comments?.append(newComment)
                            self.commentsTable.reloadData()}
                }
            }

        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

