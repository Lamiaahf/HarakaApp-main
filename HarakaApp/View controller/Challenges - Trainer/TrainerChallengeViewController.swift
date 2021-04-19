//
//  TrainerChallengeViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 02/04/2021.
//

import UIKit
import Firebase

class TrainerChallengeViewController: UIViewController{
    
    var challenge: Challenge?
    var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var challengeCard: ChallengeCard!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchChallenge()
    }
    
    func fetchChallenge(){
        
        let currentDate = Date()
        
        DBManager.getChallenge(){
            challenge in
            if currentDate.compare(challenge.enddate!) == .orderedAscending{
                // if current date < challenge end date -> show challenge
                self.challenge = challenge
                self.challengeCard.trainerChallenge = self.challenge
                
                //PROGRESS BAR: 1 - (Days remaining/7)
            }
            else{
                self.emptyLabel.alpha = 1
               self.emptyImage.alpha = 1
            }
        }
    }
    
    
}
