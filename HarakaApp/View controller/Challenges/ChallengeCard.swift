//
//  ChallengeCard.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 19/04/2021.
//

import UIKit

class ChallengeCard: UIView {

    
    //Variables
    var challenge: Challenge!{
        didSet{
            updateChallenge()
        }
    }
    
    let secsInAWeek = 604800.0
    let dateFormatter = DateFormatter()

    @IBOutlet weak  var startButton: UIButton!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var cDescriptionLabel: UILabel!
    @IBOutlet weak var cTimeline: UIProgressView!
    var userStartTime: Date?
    
    
    // Methods
    func updateTrainerChallenge(){
        // make join button alpha = 0
        
    }
    func updateChallenge(){
        
        dateFormatter.dateFormat = "dd/MM HH:mm"
        
        challengeLabel.text = challenge.cName
        deadlineLabel.text = dateFormatter.string(from: challenge.enddate!)
        cDescriptionLabel.text = challenge.description

        DBManager.getTrainer(for: (challenge.createdBy?.trainerID)!){
            trainer in
            self.challenge.createdBy = trainer
            self.trainerLabel.text = self.challenge.createdBy?.name
        }

        
        
        var current = Date()
        var chDate = challenge.enddate
        var interval = current.distance(to: challenge.enddate!)
        var percent = 1-(interval/secsInAWeek)
        cTimeline.progress = Float(percent)
        // Continue later
        
        
        if(challenge.type == 1){
            self.startButton.alpha = 0
        }
        
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        self.userStartTime = Date()
        
    }
    
    @IBAction func viewScoreboard(_ sender: Any) {
    }
    
}
