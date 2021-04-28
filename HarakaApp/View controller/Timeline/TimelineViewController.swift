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
    var followingsIDs: [String]?
    var followings: [User]?
    var followingsDict: [String:User]?
    let ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        posts = []
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var current = User(id: Auth.auth().currentUser!.uid)
        self.getFollowings(user: current)
    }
    
    func getFollowings(user: User){
        
        DBManager.getFollowing(for: user.userID!){
                users in
                var usersList = users
                usersList.append(user)
                for u in usersList{
                    DBManager.getUser(for: u.userID!){
                        usr in
                        self.getPosts(user: usr)
                    }
                    
                }
            }
        
    }
    
    
    func getPosts(user: User){

        DBManager.getPosts(for: user) { (posts) in
            var temp = [Post]()
            for p in posts{
                self.checkLike(post: p)
                temp.append(p)
                temp.sort{
                    $0.timeAgo! < $1.timeAgo!
                }
            }
            self.posts?.append(contentsOf: temp)
            self.posts?.sort{ $0.timeAgo! < $1.timeAgo!}
            self.tableView.reloadData()
        }
        
}
    
    
     func checkLike(post: Post){
        
        //Get uid to check posts current user has liked
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
   //             destination.post = posts![button.tag]
                destination.setPost(p: posts![button.tag])
            
               }
            }
        }
    }
    
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
        let maxIndex = posts!.count - 1
        let newIndex = maxIndex - indexPath.row
        
        cell.post = posts![newIndex]
        
        cell.commentButton.tag = newIndex
        cell.commentButton.addTarget(self, action: #selector(TimelineViewController.openComments(_:)) , for: UIControl.Event.touchUpInside)
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

