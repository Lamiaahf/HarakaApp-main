//
//  CreateGameViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import UIKit
import Firebase
    
class CreateGameViewController: UIViewController {
    

    @IBOutlet weak var gameLabel: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playerCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
       dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    }
    
    @IBAction func Stepper(_ sender: UIStepper) {
        
        playerCount.text = String(Int(sender.value))
    
    }
    

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Method used to create a game (called after create button is clicked)
    @IBAction func createGame(_ sender: Any) {
        
       // Retrieve information:
       guard let uid = Auth.auth().currentUser?.uid, // User's id
             let pCount = Int(self.playerCount.text!), // Max player count
             let gameName = self.gameLabel.text, // Game Name
             
             gameName.isEmpty == false else{return} // Check whether game name is empty
        
        // Resign focus from textfield
        self.gameLabel.resignFirstResponder()
        
        // Add game to database under "GameRooms" child with a generated id
       Database.database().reference().child("GameRooms").childByAutoId().setValue([
                                                                "CreatorID": uid,
                                                                "GameName":gameName,
                                                                "PlayerCount":pCount])
       {
            (err,key) in // Adding to DB returns either an error or key of the added reference
        
            // if the returned value was a key, send it to the addParticipant method
            if(err == nil){
                self.gameLabel.text = ""
                self.addParticipant(key: key.key!, id: uid)
            }
        // Dismiss page
        self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    // Method used to add game creator's id to the "GameParticipants" child in the DB
    func addParticipant(key: String, id: String){
                // Result automatically set to 0 because user just created game
                Database.database().reference().child("GameParticipants").child(key).child(id).setValue(["Result":0.0])
        }
    

}
