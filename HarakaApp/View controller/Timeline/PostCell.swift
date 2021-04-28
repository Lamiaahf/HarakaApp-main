//
//  PostCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase
class PostCell: UITableViewCell{
    
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    let ref = Database.database().reference()
    
    
    var post: Post!{
        didSet{
            updateTimeline()
        }
    }
   
    override func didMoveToWindow() {
        if(post == nil){
            return
        }
        updateTimeline()
    }
    
    func updateTimeline(){

        timeAgoLabel.text = post.timeAgo
        captionLabel.text = post.caption
        likesLabel.text = "\(post.numOfLikes!)"
        commentsLabel.text = "\(post.numOfComments!)"
        
        profileImageView.image = post.createdBy.profileImage
        print(profileImageView.frame.size.width)
        profileImageView.frame.size.width = 25
        profileImageView.layer.cornerRadius = 25/2
        profileImageView.clipsToBounds = true

        usernameLabel.text = post.createdBy.username
        
        if (!post.liked!){
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        else{
            likeButton.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
    }

    
    @IBAction func like(_ sender: Any) {
        
        guard let id = post.postID else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if(!post.liked!){
            ref.child("PostLikes").child(id).childByAutoId().setValue([uid:true])
            post.liked = true
            post.numOfLikes = post.numOfLikes!+1

        }else{
            ref.child("PostLikes").child(id).queryOrdered(byChild:uid).queryEqual(toValue:true).ref.removeValue()
            post.liked = false
            post.numOfLikes = post.numOfLikes!-1
        }
        updatePost()
        updateTimeline()
        }
    
    
    func updatePost(){
        ref.child("posts").child(post.postID!).updateChildValues([
                    "numOfLikes":post.numOfLikes!,
                    "numOfComments":post.numOfComments!])
    }
        
    
    
}
