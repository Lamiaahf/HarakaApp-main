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
    var post: Post = Post()
    let ref: DatabaseReference = Database.database().reference()
    
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
        commentsTable.reloadData()

    }
    
    func setPost(p: Post){
        self.post = p
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
        let user = Auth.auth().currentUser?.uid
        
        ref.child("Comments").child(post.postID!).childByAutoId().setValue([
                "uid":user!,
                "comment":text])
        
        post.numOfComments = post.numOfComments!+1
        ref.child("posts").child(post.postID!).updateChildValues([
            "numOfComments":post.numOfComments
        ])

        commentField.text = ""
      //  fetchComments()
    }
    
    func fetchComments(){
        
        comments = []

        ref.child("Comments").child(post.postID!).observe(.childAdded){
        (snapshot) in
            if snapshot.exists(){
                if let commentDict = snapshot.value as? [String: Any]{
                    if let uid = commentDict["uid"] as? String {
                        let comment = commentDict["comment"] as? String ?? ""
                        
                        let commentUser = User(id:uid)
                        let newComment = Comment(writtenBy: commentUser, commentText:comment)
                        DBManager.getUser(for: uid){
                            user in
                            newComment.writtenBy = user
                            self.commentsTable.reloadData()
                            DBManager.getPic(for: user){
                                pic in
                                newComment.writtenBy.profileImage = pic
                                self.commentsTable.reloadData()
                            }
                        }
                       
                        self.comments?.append(newComment)}
                }
            }

        }
        
    }
}

