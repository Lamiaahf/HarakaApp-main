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
        
        let uid = Auth.auth().currentUser?.uid
        
        DBManager.getTrainer(for: (challenge.createdBy?.trainerID)!){
            trainer in
            self.challenge.createdBy = trainer
        }

        trainerLabel.text = challenge.createdBy?.name
        
        
    }
}
