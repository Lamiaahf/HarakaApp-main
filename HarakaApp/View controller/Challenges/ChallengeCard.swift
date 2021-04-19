//
//  ChallengeCard.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 19/04/2021.
//

import UIKit

class ChallengeCard: UIView {

    
    //Variables
    var userChallenge: Challenge!{
        didSet{
            updateUserChallenge()
        }
    }
    
    var trainerChallenge: Challenge!{
        didSet{
            updateTrainerChallenge()
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
    func updateUserChallenge(){
        
        challengeLabel.text = userChallenge.cName
        deadlineLabel.text = DateFormatter().string(from: userChallenge.enddate!)
        trainerLabel.text = userChallenge.createdBy?.username
        cDescriptionLabel.text = userChallenge.description

        var current = Date()
        var chDate = userChallenge.enddate
        var interval = current.distance(to: userChallenge.enddate!)
        print(interval)
        print("Time")
        // Continue later
        
        
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        self.userStartTime = Date()
        
    }
    
    @IBAction func viewScoreboard(_ sender: Any) {
    }
    
}
