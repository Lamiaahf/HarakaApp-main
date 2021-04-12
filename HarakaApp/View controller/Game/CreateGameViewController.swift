//
//  CreateGameViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import UIKit
import Firebase
    
class CreateGameViewController: UIViewController{
    

    @IBOutlet weak var gameLabel: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var playerCount: UILabel!
    
    @IBAction func Stepper(_ sender: UIStepper) {
        
        playerCount.text = String(Int(sender.value))
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createGame(_ sender: Any) {
        
       guard let uid = Auth.auth().currentUser?.uid,
             let pCount = Int(self.playerCount.text!),
             let gameName = self.gameLabel.text,
             gameName.isEmpty == false else{
        return
       }
        
        self.gameLabel.resignFirstResponder()
        
       Database.database().reference().child("GameRooms").childByAutoId().setValue([
                                                                                        "CreatorID": uid,
                                                                                        "GameName":gameName,
                                                                                    "PlayerCount":pCount])
        {
            (err,key) in
            if(err == nil){
                self.gameLabel.text = ""
                self.addParticipant(key: key.key!, id: uid)
            }
        
            
        }
        
        
    }
    
    func addParticipant(key: String, id: String){
    
                Database.database().reference().child("GameParticipants").child(key).child(id).setValue(["Result":0.0])
            
        }
    
    /*
     Database.database().reference().child("GameParticipants").queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: {
         snapshot in
         if snapshot.exists(){
             // Global method to find game
             
             var currentCount = Int(snapshot.childrenCount)
             
             Database.database().reference().child("GameRooms").queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: {
                 snapshot in
                 guard let dict = snapshot.value as? [String: Any] else {return}
                 
                 var playerCount = dict["PlayerCount"] as! Int
                 
                 if(currentCount == playerCount){
                     // Send popup message to user
                     let alert = UIAlertController(title: "حدث خطأ", message: "اللعبة ممتلئة", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler:nil))
                     self.present(alert, animated: true)
                     return
                 }
                 else{
                     Database.database().reference().child("GameParticipants").child(key).childByAutoId().setValue([
                         "UID":id,
                         "Result":0.0
                     ])
                 }
                 
             })
             
         }else{*/
        
       
        

}
