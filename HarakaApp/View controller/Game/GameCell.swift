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
