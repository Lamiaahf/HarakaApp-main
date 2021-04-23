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
    

    @IBOutlet weak var challengeCard: ChallengeCard!
    @IBOutlet weak var emptyCard: EmptyCard!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.challengeCard.alpha = 0
        self.emptyCard.alpha = 0
        
        fetchChallenge()
    }
    
    func fetchChallenge(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
     //   formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = Locale.current
        let currentDate = formatter.string(from: Date())
        
        DBManager.getChallenge(){
            challenge in
            if(challenge.cName == nil){
                self.challengeCard.alpha = 0
                self.emptyCard.alpha = 1
                return
            }
            if currentDate.compare(challenge.enddate!) == .orderedAscending{
                // if current date < challenge end date -> show challenge
                self.challenge = challenge
                self.challenge!.type = 1
                self.challengeCard.challenge = self.challenge
                
                self.challengeCard.alpha = 1
                self.emptyCard.alpha = 0
                //PROGRESS BAR: 1 - (Days remaining/7)
            }
            else{
                self.challengeCard.alpha = 0
                self.emptyCard.alpha = 1
            }
        }
    }
    
    
}
