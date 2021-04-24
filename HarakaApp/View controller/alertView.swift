//
//  alertView.swift
//  HarakaApp
//
//  Created by lamia on 23/04/2021.
//

import Foundation
import UIKit

class alertVierw : UIView{
    @IBOutlet var parentVeiw : UIView!
    @IBOutlet var alertVeiw : UIView!
    @IBOutlet weak var M: UILabel!
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var DoneButton: UIButton!
    override init(frame : CGRect){
        super.init(frame : frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
