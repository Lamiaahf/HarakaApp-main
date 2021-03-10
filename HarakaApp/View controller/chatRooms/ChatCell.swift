//
//  ChatCell.swift
//  HarakaApp
//
//  Created by ohoud on 23/07/1442 AH.
//

import UIKit

class ChatCell: UITableViewCell {
    enum bubbleType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var chatStack: UIStackView!


    @IBOutlet weak var textViewBobbleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textViewBobbleView.layer.cornerRadius = 9
        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
   
  
  
    
  
    
    
    //  self.messageContainerView.layer.cornerRadius = 10
    // Initialization code

func setBubbleDataForMessage(message: Message){
    if(message.messageText != nil) {
        self.textView.text = message.messageText
    } else if(message.imageLink != nil){
    //    self.imageView.image =
    }
    
    self.senderNameLabel.text = message.senderUsername
}

func setBubbleType(type: bubbleType){
    if(type == .outgoing){
        print("incoming !")
        self.chatStack.alignment = .trailing
        self.textViewBobbleView.backgroundColor =
            self.textView.textColor; #colorLiteral(red: 0.3974583745, green: 0.5797579885, blue: 0.6469487548, alpha: 1)
        self.textView.textColor = UIColor.white
        
    }
    else if(type == .incoming){
        self.chatStack.alignment = .leading
        self.textViewBobbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.textView.textColor = UIColor.black

    }
    
    
}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

