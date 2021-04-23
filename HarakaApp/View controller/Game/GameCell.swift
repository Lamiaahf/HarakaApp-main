//
//  GameCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import UIKit

class GameCell: UITableViewCell{
    
    
    @IBOutlet weak var GameLabel: UILabel!
    @IBOutlet weak var CreatorLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var frontView: UIView!
    var game: Game!{
        didSet{
            updateGame()
        }
    }
    
    func updateGame(){
        
        GameLabel.text = game.name
        CreatorLabel.text = game.creatorID // Change to username
        
    }
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
