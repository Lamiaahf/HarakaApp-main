//
//  PlayerCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 10/04/2021.
//

import UIKit

class PlayerCell: UITableViewCell{
    
    
    @IBOutlet weak var rankImage: UIImageView!
    
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var firstPlace: UIImageView!
    
    
    var player: Player!{
        didSet{
            updateBoard()
        }
    }
    
    func updateBoard(){
        playerLabel.text = player.username
        scoreLabel.text = String(format: "%.2f", player.score ?? -1)
        firstPlace.alpha = 1
        rankImage.alpha = 1
        
    }
}
