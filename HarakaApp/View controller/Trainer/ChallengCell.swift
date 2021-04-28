//
//  ChallengCell.swift
//  HarakaApp
//
//  Created by lamia on 24/04/2021.
//

import UIKit
class ChallengCell: UITableViewCell {


    @IBOutlet weak var AName: UILabel!
    @IBOutlet weak var Des: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    @IBOutlet weak var type: UILabel!



var  cha: Challenge!{
    
    didSet{
        updateChallengeTable()
    }
}


func updateChallengeTable(){
    AName.text = self.cha.cName
    Des.text = self.cha.cDesc
    EndDate.text = self.cha.enddate!
    type.text = cha.challengeType
}
    
  
}
