//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green  : 99/255, blue: 173/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleTextView(textBox: UITextView){
        
      //  view.addSubview(textBox)
        //textBox.translatesAutoresizingMaskIntoConstraints = false
        
        textBox.autocorrectionType = .no
        textBox.backgroundColor = .systemGray6
        textBox.textColor = .secondaryLabel
        textBox.font = UIFont.preferredFont(forTextStyle: .body)
        textBox.layer.cornerRadius = 20
        textBox.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        textBox.layer.shadowColor = UIColor.gray.cgColor;
        textBox.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textBox.layer.shadowOpacity = 0.4
        textBox.layer.shadowRadius = 20
        textBox.layer.masksToBounds = false
        
    }
  
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    

    
    
}
