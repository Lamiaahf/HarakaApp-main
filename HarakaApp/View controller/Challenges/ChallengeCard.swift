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
        
        challengeLabel.text = challenge.cName
        deadlineLabel.text = DateFormatter().string(from: challenge.enddate!)
        trainerLabel.text = challenge.createdBy?.username
        cDescriptionLabel.text = challenge.description

        var current = Date()
        var chDate = challenge.enddate
        var interval = current.distance(to: challenge.enddate!)
        print(interval)
        print("Time")
        // Continue later
        
        
        if(challenge.type == 1){
            updateTrainerChallenge()
        }
        
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        self.userStartTime = Date()
        
    }
    
    @IBAction func viewScoreboard(_ sender: Any) {
    }
    
}
