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
  //      self.refreshControl = UIRefreshControl()
  //      self.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
   //     tableView.addSubview(self.refreshControl!)
        
        posts = []
        followings = []
        followingsIDs = []
        followingsDict = [:]
        
        var current = User()
        DBManager.getUser(for: Auth.auth().currentUser!.uid){
            user in
            current = user

            print(FollowersTableViewController().listFollowers)
            self.followingsIDs?.append(current.userID!)
            self.followings?.append(current)
            
            DBManager.getFollowing(for: current){
                users in
                for u in users{
                    self.followingsIDs!.append(u.userID!)
                    self.followings!.append(u)
                    // DBManager.getPic(for: u){ pic in}
                }
                self.fetchPosts()
                self.tableView.reloadData()
                self.tableView.scrollsToTop = true
            }
        }
        
        
      
      /*  DBManager.getPosts(for: current) { (posts) in
            for p in posts{
                self.checkLike(post: p)
                self.posts?.append(p)
                DBManager.getUser(for: p.UID!){
                    user in
                    p.createdBy = user
                }
            //    self.tableView.reloadData()
            }
        }*/
        
    //    self.tableView.reloadData()
     //   getPosts()
      //  fetchPosts()
        }
    
    
    func getPosts(user: User){

        
        DBManager.getPosts(for: user) { (posts) in
            for p in posts{
                self.checkLike(post: p)
                self.posts?.append(p)
                self.tableView.reloadData()

            }
        }
        
        DBManager.getFollowing(for: user){
            (users) in
            for u in users{
                DBManager.getPosts(for: u){ (posts) in
                    for p in posts{
                        self.checkLike(post: p)
                        self.posts?.append(p)
                        self.tableView.reloadData()

                    }
                }
            }
        }
        
            }


    func fetchPosts(){

        // retrieve posts from database, may return error or snapshot (snapshot contains data)

        followingsDict = Dictionary.init(keys: followingsIDs!, values: followings!)
        ref.child("posts").observe(.childAdded){
        (snapshot) in
            if snapshot.exists(){
                if let postDict = snapshot.value as? [String: Any]{
                    if let uid = postDict["uid"] as? String{
                        
                        if self.followingsIDs!.contains(uid){
                            
                            let cap = postDict["caption"] as? String ?? ""
                            let times = postDict["timestamp"] as? String ?? ""
                            let nol = postDict["numOfLikes"] as? Int ?? 0
                            let noc = postDict["numOfComments"] as? Int ?? 0
                            let id = String(snapshot.key)
                            
                            let postUser = self.followingsDict![uid]
                        
                            DBManager.getPic(for: postUser!){
                                pic in
                                postUser?.profileImage = pic
                                self.tableView.reloadData()
                            }
                            var post = Post(createdBy: postUser!, timeAgo: times, caption: cap, numOfLikes: nol, numOfComments: noc, postID: id, liked: false, uid: uid)
                            self.checkLike(post: post)
                            self.posts?.append(post)
                            self.tableView.reloadData()
   
                        
                        }
                        
                    }}
                
            }
    

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
        var maxIndex = posts!.count-1
        var newIndex = maxIndex - indexPath.row
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

extension Dictionary {
    public init(keys: [Key], values: [Value]) {
        precondition(keys.count == values.count)

        self.init()

        for (index, key) in keys.enumerated() {
            self[key] = values[index]
        }
    }
}

