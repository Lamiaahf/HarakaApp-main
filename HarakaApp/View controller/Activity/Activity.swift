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
         var ADateTime: Date?
         var Atype : String?
         var Apartic : String?
         var ALoca : String?

      
        
    init(createdBy: String?,createdByi :String?, name: String?, disc: String?, DateTime: Date?, type: String?, partic: String?, Loca : String?, uid : String?){
            createdByName = createdBy
            createdByID = createdBy
            Aname = name
            Adisc = disc
            ADateTime = DateTime
            Atype = type
            Apartic = partic
            ALoca = Loca
        }
}
