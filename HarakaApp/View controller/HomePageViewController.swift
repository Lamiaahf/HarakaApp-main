//
//  HomePageViewController.swift
//  HomePageHaraka
//
//  Created by Noura AlSheikh on 01/02/2021.
//

import UIKit
import AMTabView

class HomePageViewController: UIViewController , TabItem{
    
    // tab bar and UI ohoud
    var tabImage: UIImage? {
      return UIImage(systemName: "homekit")
    }
    
    @IBOutlet var activitiesButton: UIButton!
   
    @IBOutlet var GroupsHSButton: UIButton!
    
    @IBOutlet var challangesHSButton: UIButton!
   
    @IBOutlet var GameHSButton: UIButton!
    
    @IBOutlet var postsHSButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesButton.applyDesign()
        GroupsHSButton.applyDesign()
        challangesHSButton.applyDesign()
      //  GameHSButton.applyDesign()
     //   postsHSButton.applyDesign()
        
        // Do any additional setup after loading the view.
    }
  
}
extension UIButton {
    func applyDesign() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5   }
}


