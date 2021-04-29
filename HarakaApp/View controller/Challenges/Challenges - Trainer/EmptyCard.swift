//
//  EmptyCard.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 20/04/2021.
//

import UIKit

class EmptyCard: UIView {

    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
   
    
    
    

    @IBAction func createChallenge(_ sender: Any) {
        
        createButton.setImage(UIImage(named: "fire-filled-large"), for: .highlighted)
      //  createButton.setImage(UIImage(named: "fire-filled-large"), for: .selected)
        
    }
    
}
