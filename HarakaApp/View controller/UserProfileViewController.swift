//
//  UserProfileViewController.swift
//  HarakaApp
//
//  Created by lamia on 17/02/2021.
//
import UIKit
import FirebaseAuth





 


class UserProfileViewController:  UIViewController {

  
    @IBOutlet weak var Userimg: UIImageView!
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Posts: UIView!
    @IBOutlet weak var Trainers: UIView!
    @IBOutlet weak var Users: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad() }
   
    @IBAction func showComponents(_ sender: Any) {
        if ((sender as AnyObject).selectedSegmentIndex == 0){ UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 1
            self.Users.alpha = 0
            self.Trainers.alpha = 0
        })}
          if  ((sender as AnyObject).selectedSegmentIndex == 1 ) {
            do { UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                            self.Users.alpha = 1
                            self.Trainers.alpha = 0
    })}}
    
    
    
         else if ((sender as AnyObject).selectedSegmentIndex == 1 ) {
            do {UIView.animate(withDuration: 0.5, animations:{self.Posts.alpha = 0
                       self.Users.alpha = 0
                       self.Trainers.alpha = 1
})}
    }}
    
    
    
   /* internal func setPic (imageView : UIImage, imageToSet: UIImage){
        imageView.layar.cornerRadius = 10.0
        imageView.layar.comasksToBounds = true
        imageView.image = imageToSet }
            
    */
}
