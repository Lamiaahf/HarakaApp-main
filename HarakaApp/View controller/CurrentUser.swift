//
//  CurrentUser.swift
//  HarakaApp
//
//  Created by lamia on 02/03/2021.
//


import Foundation

struct CurrentUser{
let uid  : String
let name :String
let username :String
let userimg :String



init ( uid : String, dictionary : [String: Any]){

    self.uid  = uid
    self.name  = dictionary["Name"] as? String ?? " "
    self.username = dictionary["Username"] as? String ?? " "
    self.userimg = dictionary["ProfilePic"] as? String ?? " "
}
}
