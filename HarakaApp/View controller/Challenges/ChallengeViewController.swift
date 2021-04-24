//
//  ChallengeViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 08/03/2021.
//

import UIKit
import Firebase

class ChallengeViewController: UIViewController, ScoreboardDelegate {
    
    
    var challenge:Challenge?
    var ref: DatabaseReference!
    
    @IBOutlet weak var notFoundImage: UIImageView!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var challengeCard: ChallengeCard!
    // var cardView: ChallengeCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        challengeCard.alpha = 0
        notFoundImage.alpha = 0
        notFoundLabel.alpha = 0
        
        challengeCard.delegate = self
        challengeCard.reDesign()
        
        fetchChallenge()


    }
    
    func fetchChallenge(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
        let currentDate = formatter.string(from:Date())
        
        DBManager.getChallenge(){
            challenge in
            if(challenge.cName == nil){
                self.challengeCard.alpha = 0
                self.notFoundLabel.alpha = 1
                self.notFoundImage.alpha = 1
                return
            }
            if self.compareDate(currentDate: currentDate, challDate: challenge.enddate!){
                // if current date < challenge end date -> show challenge
                self.challenge = challenge
                self.challenge?.type = 0
                self.challengeCard.challenge = self.challenge
                
                self.notFoundLabel.alpha = 0
                self.notFoundImage.alpha = 0
                self.challengeCard.alpha = 1
                //
                //PROGRESS BAR: 1 - (Days remaining/7)
            }
            else{
                self.challengeCard.alpha = 0
                self.notFoundLabel.alpha = 1
                self.notFoundImage.alpha = 1
            }
        }
        
    }
    func compareDate(currentDate: String, challDate: String) -> Bool{

        let currentMonth = currentDate[3..<5]
        let challMonth = challDate[3..<5]
        
        let currentDay = Int(currentDate[0..<2])!
        let challDay = Int(challDate[0..<2])!
            
        let currentHour = Int(currentDate[6..<8])!
        let challHour = Int(challDate[6..<8])!

        var currentIndex = currentDate.index(currentDate.firstIndex(of: ":")!, offsetBy:1)
        var challIndex = challDate.index(challDate.firstIndex(of: ":")!, offsetBy: 1)
        let currentMin = Int(String(currentDate[currentIndex...]))!
        let challMin = Int(String(challDate[challIndex...]))!

    // if deadline is next month
    if (Int(challMonth)! - Int(currentMonth)!) == 1 {return true}
    // if deadline is this month -> check days
    else if currentMonth == challMonth{
        // if deadline is not today
        if currentDay < challDay {return true}
        // if deadline is today -> check hour
        else if currentDay == challDay {
            // if deadline is not this hour
            if currentHour < challHour {return true}
            // if deadline is this hour -> check minute
            if currentHour == challHour {
                // if deadline minute hasnt passed
                if currentMin < challMin {return true}
                // if deadline passed
                else {return false}
            }
            // if deadline passed
            else {return false}
        }
        // if deadline is passed
        else {return false}
        
    }
    else {return false}
    }


    // Delegate "ScoreboardDelegate" methods
    func showScoreboard(ch: Challenge){
        let scoreboard = self.storyboard?.instantiateViewController(identifier: "ChallengeBoardViewController") as! ChallengeBoardViewController
        scoreboard.currentChallenge = ch
        
        self.navigationController?.pushViewController(scoreboard, animated: true)
        
    }

}

extension UIView{
    func reDesign() {
        
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 25
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.75
    }

}
