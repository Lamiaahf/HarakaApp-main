//
//  SettingsViewController.swift
//  HarakaApp
//
//  Created by lamia on 01/03/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Bio: UITextField!
    
    @IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var Save: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
    
        // Style the elements
        Utilities.styleTextField(Name)
        Utilities.styleTextField(Age)
        Utilities.styleTextField(Email)
        Utilities.styleTextField(Bio)
        Utilities.styleFilledButton(Save)
        Utilities.styleFilledButton(Logout)

    }
 

    @IBAction func Edit(_ sender: Any) {
    }
    @IBAction func Logout(_ sender: Any) {
        let storyboard = UIStoryboard(name : "Main",bundle: nil)
        let LOGINViewController = storyboard.instantiateViewController(identifier: "login")
        present(LOGINViewController, animated: true, completion: nil)
    }
    
}
