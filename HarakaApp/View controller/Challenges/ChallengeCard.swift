//
//  ChallengeCard.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 19/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth


class ChallengeCard: UIView{

    
    //Variables
    var challenge: Challenge!{
        didSet{
            updateChallenge()
        }
    }
    
    weak var delegate: ScoreboardDelegate?
    
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
            self.startButton.alpha = 0
            self.endButton.alpha = 1
        }
        else{
            self.startButton.alpha = 1
            self.endButton.alpha = 0
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
    func calculatScore(currentDate: String, startDate: String) -> Float {
            
        var days = 0
        var hours:Float = 0.0
        var mins:Float = 0.0
        var score:Float = 0.0
        
        let currentMonth = currentDate[3..<5]
        let startMonth = startDate[3..<5]

        let currentDay = Int(currentDate[0..<2])!
        let startDay = Int(startDate[0..<2])!
        
        let currentHour = Int(currentDate[6..<8])!
        let startHour = Int(startDate[6..<8])!
        let currentMin = Int(currentDate[currentDate.firstIndex(of:":")!...])!
        let startMin = Int(startDate[startDate.firstIndex(of:":")!...])!
        
        if(currentMonth == startMonth){
            days = currentDay - startDay
        }
        else{
            days = 30-startDay
            days = days+currentDay
        }
        if(currentHour>=startHour){
            hours = Float(days*24+(currentHour-startHour))
        }
        else{
            hours = Float(days*24-(startHour-currentHour))
        }
        if(currentMin>=startMin){
            mins = Float(currentMin-startMin)
        }
        else{
            mins = Float(startMin-currentMin)
        }
        score = hours + (mins/60)
        return score
    
    }

    
    @IBAction func startChallenge(_ sender: Any) {
        let userStartTime = dateFormatter.string(from: Date())
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("ChallengeParticipants").child(challenge.chalID!).child(uid!).setValue([
            "StartTime": userStartTime,
            "Score":0
        ])
        
        self.startButton.alpha = 0
        self.endButton.alpha = 1
        
    }
    
    @IBAction func endChallenge(_ sender: Any) {
        
        let userEndTime = dateFormatter.string(from:Date())
        let uid = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("ChallengeParticipants").queryOrderedByKey().queryEqual(toValue: uid).observe(.childAdded, with:{
            snapshot in
            guard let dict = snapshot.value as? [String:Any] else {return}
            let userStartTime = dict["StartTime"] as? String
            
            let score = self.calculatScore(currentDate: userEndTime, startDate: userStartTime!)
            
            Database.database().reference().child("ChallengeParticipants").queryOrderedByKey().queryEqual(toValue: uid).setValuesForKeys(["Score":score])
        })
        
        self.endButton.alpha = 0
        self.startButton.alpha = 1
        
        
        
    }
    
    @IBAction func viewScoreboard(_ sender: Any) {
        
        // Call delegate to perform segue
        self.delegate?.showScoreboard(ch: challenge)
       
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

protocol ScoreboardDelegate: class {
    
    func showScoreboard(ch: Challenge)
}
