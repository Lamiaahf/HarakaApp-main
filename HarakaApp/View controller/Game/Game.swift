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
    
    init(gName: String, uid: String, gid: String){
        name = gName
        creatorID = uid
        gID = gid
    }
    
}
