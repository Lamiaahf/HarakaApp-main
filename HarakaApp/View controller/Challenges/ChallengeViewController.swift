//
//  ChallengeViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 08/03/2021.
//

import UIKit
import Firebase

class ChallengeViewController: UIViewController {
    
    var challenge:Challenge?
    var ref: DatabaseReference!
    
    @IBOutlet weak var notFoundImage: UIImageView!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var challengeCard: ChallengeCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        challengeCard.alpha = 0
        notFoundImage.alpha = 0
        notFoundLabel.alpha = 0
        
        fetchChallenge()


    }
    
    func fetchChallenge(){
        
        let currentDate = Date()
        
        DBManager.getChallenge(){
            challenge in
            if currentDate.compare(challenge.enddate!) == .orderedAscending{
                // if current date < challenge end date -> show challenge
                self.challenge = challenge
                self.challengeCard.userChallenge = self.challenge
                
                //PROGRESS BAR: 1 - (Days remaining/7)
            }
            else{
                self.notFoundLabel.alpha = 1
                self.notFoundImage.alpha = 1
            }
        }
        
    }



}
