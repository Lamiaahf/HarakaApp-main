//
//  Trainner.swift
//  HarakaApp
//
//  Created by lamia on 22/03/2021.
//

import Foundation
// Trainar = approveSpecliat
class Trainner {
var TName: String?
var TDOB: String?
var Tusername: String?
var TLinkedin: String?
var TEmail: String?
var TPassword: String?
var autoKey: String?
var Tpic :String?



    init(TrainName:String,TrainDOB:String,Trainusername:String, TrainLinked:String,TrainEmail:String, TrainPassword:String, Trainpic : String , autoKey:String) {

    self.TName = TrainName
    self.Tusername = Trainusername
    self.TDOB = TrainDOB
    self.TLinkedin = TrainLinked
    self.TEmail = TrainEmail
    self.TPassword = TrainPassword
    self.Tpic = Trainpic
    self.autoKey = autoKey
    
    
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
