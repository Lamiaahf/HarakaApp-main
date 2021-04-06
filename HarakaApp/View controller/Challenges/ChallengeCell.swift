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
        
        DBManager.getType(for: uid!){
            type in
            if type == 0{
                self.leaderboardButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                print(self.leaderboardButton.tintColor.accessibilityName)
            }
            else if type == 1{
                self.leaderboardButton.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
                print(self.leaderboardButton.tintColor.accessibilityName)
            }
            else{ return }
        }

        
    }
}
