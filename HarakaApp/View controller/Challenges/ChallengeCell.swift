//
//  ChallengeCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 07/03/2021.
//

import UIKit
import FirebaseAuth

class ChallengeCell: UITableViewCell{
    
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var trainerLabel: UILabel!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    
    var challenge: Challenge!{
        didSet{
            updateChallenges()
        }
    }
    
    func updateChallenges(){
        
        challengeLabel.text = challenge.cName
        deadlineLabel.text = "\(challenge.enddate)"
        trainerLabel.text = challenge.createdBy?.name
        
        let uid = Auth.auth().currentUser?.uid
        
        if(DBManager().getType(id: uid!) == 0){
            leaderboardButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            print(leaderboardButton.tintColor.accessibilityName)
        }
        else{
            leaderboardButton.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
            print(leaderboardButton.tintColor.accessibilityName)
        }

        
    }
}
