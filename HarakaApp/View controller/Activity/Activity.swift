//
//  Activity.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit

class Activity {
         var createdByName: String?
         var createdByID: String?
         var Aname: String?
         var Adisc: String?
         var ADateTime: String?
         var Atype : String?
         var Apartic : String?
         var ALoca : String?
         var AImage : String?
         var ActivityID : String?


      
        
    init(createdBy: String?,createdByi :String?, name: String?, disc: String?, DateTime: String?, type: String?, partic: String?, Loca : String?, uid : String?
         , image : String , id : String ){
            createdByName = createdBy
            createdByID = createdByi
            Aname = name
            Adisc = disc
            ADateTime = DateTime
            Atype = type
            Apartic = partic
            ALoca = Loca
            AImage = image
            ActivityID = id
        }
}
