//
//  Game.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import Foundation

class Game{
    
    var name: String?
    var participants: [User]?
   // var results: [String:Float]?
    var results: [Float]?
    var creatorID: String?
    //var gID: String?
    
    init(gName: String, prtcpnts: [User], rslts: [Float], uid: String){
        name = gName
        participants = prtcpnts
        results = rslts
        creatorID = uid
    }
    
}
