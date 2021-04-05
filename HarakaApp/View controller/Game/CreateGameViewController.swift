//
//  CreateGameViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import UIKit
    
class CreateGameViewController: UIViewController{
    
    
    
    @IBOutlet weak var playerCount: UILabel!
    
    @IBAction func Stepper(_ sender: UIStepper) {
        
        playerCount.text = String(sender.value)
        
    }
}
