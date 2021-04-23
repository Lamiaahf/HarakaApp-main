//
//  ChallengeCard.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 19/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth


class ChallengeCard: UIView {

    
    //Variables
    var challenge: Challenge!{
        didSet{
            updateChallenge()
        }
    }
    
    let secsInAWeek:Float = 604800.0
    let dateFormatter = DateFormatter()

    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak  var startButton: UIButton!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var cDescriptionLabel: UILabel!
    @IBOutlet weak var cTimeline: UIProgressView!
    
    
    // Methods
    func updateTrainerChallenge(){
        // make join button alpha = 0
        
    }
    func updateChallenge(){

        challengeLabel.text = challenge.cName
        deadlineLabel.text =  challenge.enddate!
        cDescriptionLabel.text = challenge.cDesc

        DBManager.getTrainer(for: (challenge.createdBy?.trainerID)!){
            trainer in
            self.challenge.createdBy = trainer
            self.trainerLabel.text = self.challenge.createdBy?.name
        }

        dateFormatter.dateFormat = "dd/MM HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        let challDate = challenge.enddate!

        let interval = calculateInterval(currentDate: currentDate, challDate: challDate)
        cTimeline.progress = Float(interval)
        
        if(challenge.type == 1){
            self.startButton.alpha = 0
            self.endButton.alpha = 0
        }
        
        if(challenge.isUserStarted()){
            self.startButton.alpha = 1
            self.endButton.alpha = 0
        }
        else{
            self.startButton.alpha = 0
            self.endButton.alpha = 1
        }
        
    }
    
    func calculateInterval(currentDate: String, challDate: String) -> Float {
        //    var currentDate = "20/03 13:30"
        //    var challDate = "27/03 13:30"
            
        var days = 0
        var seconds:Float = 0.0
        var interval:Float = 0.0
        
        let currentMonth = currentDate[3..<5]
        let chalMonth = challDate[3..<5]

        let currentDay = Int(currentDate[0..<2])!
        let chalDay = Int(challDate[0..<2])!
        /*
        let currentHour = Int(currentDate[6..<8])!
        let chalHour = Int(challDate[6..<8])!
        let currentMin = Int(currentDate[currentDate.firstIndex(of:":")!...])!
        let chalMin = Int(challDate[challDate.firstIndex(of:":")!...])!
        */

            
        if(currentMonth == chalMonth){
           days = chalDay - currentDay
        }else{
            days = 30-currentDay
            days = days+chalDay
        }
        
        seconds = Float(days*24*60*60)
        interval = 1-(seconds/secsInAWeek)
        
        return interval
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        var userStartTime = Date()
        var uid = Auth.auth().currentUser?.uid
        
        
        Database.database().reference().child("ChallengeParticipants").child(challenge.chalID!).child(uid!).setValue([
            "StartTime": userStartTime,
            "Score":0
        ])
        
        
    }
    
    @IBAction func viewScoreboard(_ sender: Any) {
    }
    
}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

}
