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
        var current = User(id: Auth.auth().currentUser!.uid)
        DBManager.getUser(for: current.userID!){
            user in
            current = user
            //self.followings?.append(current)
            //self.followingsIDs?.append(current.userID)
            self.getPosts(user: current)
        }
        //fetchPosts()
        
        }
    
    
    func getPosts(user: User){

        
        DBManager.getPosts(for: user) { (posts) in
            for p in posts{
                self.checkLike(post: p)
                self.posts?.append(p)
                self.posts!.sort{
                    $0.timeAgo! < $1.timeAgo!
                }
                self.tableView.reloadData()

            }
        }
        
        DBManager.getFollowing(for: user.userID!){
            (users) in
            for u in users{
                DBManager.getUser(for: u.userID!){
                    user in
                    self.followings?.append(user)
                    self.followingsIDs?.append(user.userID!)
                    
                    DBManager.getPosts(for: user){ (posts) in
                        for p in posts{
                            self.checkLike(post: p)
                            self.posts?.append(p)
                            self.posts!.sort{
                                $0.timeAgo! < $1.timeAgo!
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
}

    
    func fetchPosts(){
        

    
        
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

