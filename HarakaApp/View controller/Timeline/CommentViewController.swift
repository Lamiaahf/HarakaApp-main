//
//  CommentViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 21/03/2021.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate {
    
    var comments: [Comment]?
    var post: Post?
    
//    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        commentsTable.separatorStyle = .none
        commentsTable.estimatedRowHeight = commentsTable.rowHeight
        commentsTable.rowHeight = UITableView.automaticDimension
        commentsTable.delegate = self
        
        self.post = Post(createdBy: User(u: "", p: UIImage(systemName: "figure")), timeAgo: "", captionUI: "", numOfLikesUI: 0, numOfCommentsUI: 0, postID: "", liked:false, uid: " ")
        self.comments = []
   //     fetchComments()
    }
    
    func setPost(post: Post){
        self.post = post
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
        return 45
    }
    
    
    @IBAction func postComment(_ sender: Any) {
        
        let text = commentField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(text == ""){
            return
        }
        
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser!
        
        ref.child("Comments").childByAutoId().setValue([
                "username":user.email,
                "uid":user.uid,
                "comment":text])
        
        commentField.text = ""
        // after utilities is finished, append this comment to array after retrieving User and creating comment object
        fetchComments()
    }
    
    func fetchComments(){
        
        let ref = Database.database().reference()
        ref.child("Comments").observe(.childAdded){
        (snapshot) in
        if let commentDict = snapshot.value as? [String: Any]{
            if let usern = commentDict["username"] as? String {
               let uid = commentDict["uid"] as? String ?? ""
               let comment = commentDict["comment"] as? String ?? ""
               let id = String(snapshot.key)
                var commentUser = self.post!.createdBy
                var newComment = Comment(writtenBy: commentUser, commentText:comment)
                    self.comments?.append(newComment)
                    self.commentsTable.reloadData()
                
            }}

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

