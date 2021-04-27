//
//  Extension.swift
//  Haraka-AR
//
//  Created by Njood Alhajery on 26/03/2021.
//

import UIKit

extension UIView {
    
    func setView(hidden: Bool) { self.isHidden = hidden }
    
    func set(alpha: Int) { self.alpha = 0 }
    
    func setOverlay() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.49).cgColor
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
  
    


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension Dictionary {
    public init(keys: [Key], values: [Value]) {
        precondition(keys.count == values.count)

        self.init()

        for (index, key) in keys.enumerated() {
            self[key] = values[index]
        }
    }
}
