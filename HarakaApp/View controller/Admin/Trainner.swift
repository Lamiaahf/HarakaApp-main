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
var TAge: String?
var Tusername: String?
var TLinkedin: String?
var TEmail: String?
var TPassword: String?
var autoKey: String?


init(specName:String,specAge:String,specusername:String, specLinked:String, specEmail:String, specPassword:String, autoKey:String) {
    self.TName = specName
    self.TAge = specAge
    self.Tusername = specusername
    self.TLinkedin = specLinked
    self.TEmail = specEmail
    self.TPassword = specPassword
    self.autoKey = autoKey
    
    
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
