//
//  SingupAsViewController.swift
//  HarakaApp
//
//  Created by lamia on 02/02/2021.
//

import UIKit

class SingupAsViewController: UIViewController {
//But = Button
    @IBOutlet weak var UserBut: UIButton!
    @IBOutlet weak var TrainerBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // Utilities.CircularImageView(TrainerBut)
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
