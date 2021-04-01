//
//  TimelineViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TimelineViewController: UITableViewController {
    
    var posts:[Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        posts = []
        fetchPosts()
        }
    
    func fetchPosts(){

        // retrieve posts from database, may return error or snapshot (snapshot contains data)
        let ref = Database.database().reference()
        ref.child("posts").observe(.childAdded){
        (snapshot) in
        if let postDict = snapshot.value as? [String: Any]{
            if let usern = postDict["username"] as? String {
                    let times = postDict["timestamp"] as? String ?? ""
                    let cap = postDict["caption"] as? String ?? ""
                    let nol = postDict["numOfLikes"] as? Int ?? 0
                    let noc = postDict["numOfComments"] as? Int ?? 0
                    let id = String(snapshot.key)
                  
                let postUser = User(u: usern, p: UIImage(systemName: "figure"))
                let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc, postID: id, liked:false)
                self.checkLike(post: newPost)
             //       postArray.insert(newPost, at: indx)
                    self.posts?.append(newPost)
                  //  postArray.append(newPost)
                //    indx = indx+1
                    self.tableView.reloadData()
                
            }}
   //     self.posts = postArray
        
        }
    }
    
     func checkLike(post: Post){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("PostLikes").child(post.postID!).observe(.childAdded){
            (snapshot) in
            if(snapshot.exists()){
                if let postDict = snapshot.value as? [String: Any]{
                    if(postDict.keys.contains(uid!)){
                        post.setLiked(flag: true)
                        self.tableView.reloadData()
                        }
                }
            }

        }
        
     }
    
    @IBAction func openComments(_ sender: UIButton) {
        self.performSegue(withIdentifier: "commentSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "commentSegue") {
            if let destination = segue.destination as? CommentViewController {

               if let button:UIButton = sender as! UIButton? {
                   print(button.tag) //optional
                destination.post = posts![button.tag]
            
               }
            }
        }
    }

        /*
        let popover = storyboard!.instantiateViewController(withIdentifier: Constants.Storyboard.CommentViewController) as? CommentViewController

        let cellIndex = tableView.indexPathForSelectedRow
        let selectedPost = posts![cellIndex!.row]

        popover!.setPost(post: selectedPost)
 */
    
    

    
}

extension TimelineViewController{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts{
            return posts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell", for: indexPath) as! PostCell
        cell.post = posts![indexPath.row]
        
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(TimelineViewController.openComments(_:)), for: UIControl.Event.touchUpInside)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts![indexPath.row]
        let destinationVC = CommentViewController()
        destinationVC.post = selectedPost
        destinationVC.fetchComments()
    //    destinationVC.performSegue(withIdentifier: "commentSegue", sender: self)
        TimelineViewController().performSegue(withIdentifier: "commentSegue", sender: self)
        
    }*/
    
}

