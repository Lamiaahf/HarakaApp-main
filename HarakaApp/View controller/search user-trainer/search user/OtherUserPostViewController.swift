//
//  OtherUserPostViewController.swift
//  HarakaApp
//
//  Created by lamia on 06/04/2021.
//
//other User PostsTable 
 
import UIKit
import FirebaseAuth
import FirebaseDatabase
class OtherUserPostViewController: UITableViewController {
    
    var otherUser:NSDictionary!
    var posts:[Post]?
    var databaseRef = Database.database().reference()
    var Userid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        posts = []
        let loggedInUser = Auth.auth().currentUser
        Userid = loggedInUser!.uid
        fetchUserPosts()

        // Do any additional setup after loading the view.
    }
    

    func fetchUserPosts(){

        // retrieve posts from database, may return error or snapshot (snapshot contains data)        let ref = Database.database().reference()
        databaseRef.child("posts").observe(.childAdded){
        (snapshot) in
        if let postDict = snapshot.value as? [String: Any]{
            if let usern = postDict["username"] as? String {
                    let times = postDict["timestamp"] as? String ?? ""
                    let cap = postDict["caption"] as? String ?? ""
                    let nol = postDict["numOfLikes"] as? Int ?? 0
                    let noc = postDict["numOfComments"] as? Int ?? 0
                    let UID = postDict["uid"] as? String ?? ""
                   
                    let id = String(snapshot.key)
                  
                let postUser = User()
                let newPost = Post(createdBy: postUser, timeAgo: times, caption: cap, numOfLikes: nol, numOfComments: noc, postID: id, liked:false, uid: UID)
                self.checkLike(post: newPost)
             //       postArray.insert(newPost, at: indx)
                
                
                let uid = self.otherUser?["uid"] as! String
                
                self.otherUser = snapshot.value as? NSDictionary
                //add the uid to the profile
              //  self.otherUser?.setValue(uid, forKey: "uid")
               
                if uid == newPost.UID{
                    self.posts?.append(newPost)
                  //  postArray.append(newPost)
                //    indx = indx+1
                    self.tableView.reloadData()
                    
                }
              
              
                
            }}
   //     self.posts = postArray
        
        }
    }
        
    
    
    func checkLike(post: Post){
       
        let uid = Auth.auth().currentUser?.uid
       var flag = false
       let ref = Database.database().reference()
       ref.child("PostLikes").child(post.postID!).observe(.childAdded){
           (snapshot) in
           if(snapshot.exists()){
               if let postDict = snapshot.value as? [String: Any]{
                   if(postDict.keys.contains(uid!)){
               //        post.setLiked(flag: true)
                       flag = true
                       print("inside observe: \(flag)")
                       post.setLiked(flag: true)
                       self.tableView.reloadData()
                       
                   }
               }
           }

       }
       print("outside observe: \(flag)")}

}
extension OtherUserPostViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts{
            return posts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell", for: indexPath) as! UserPostCell
        cell.post = posts![indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

