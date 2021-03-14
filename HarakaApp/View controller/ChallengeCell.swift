//
//  ChallengeCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 07/03/2021.
//

import UIKit

class ChallengeCell: UITableViewCell{
    
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBOutlet weak var progressButton: UIButton!
    var challenge: Challenge!{
        didSet{
            updateChallenges()
        }
    }
    
    func updateChallenges(){
        
        
        
    }
}
