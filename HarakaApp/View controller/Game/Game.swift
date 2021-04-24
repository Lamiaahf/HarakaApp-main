//
//  Game.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import Foundation

class Game{
    
    var name: String?
    var creatorID: String?
    var gID: String?
    var playerCount: Int?
    
    init(gName: String, uid: String, gid: String, count: Int){
        name = gName
        creatorID = uid
        gID = gid
        playerCount = count
        
        
    }
    
}

class Player{
    
    var username: String?
    var uid: String?
    var score: Double?
    
    init(username: String, uid: String, score: Double){
        
        self.username = username
        self.uid = uid
        self.score = score
    }
    
}
