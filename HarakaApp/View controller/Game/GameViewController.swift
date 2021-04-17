//
//  GameViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 17/03/2021.
//

import UIKit
import Firebase
import FirebaseAuth

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playersBoard: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    let ref: DatabaseReference! = Database.database().reference()
    
    var currentGame: Game?
    var playerCount: Int?
    var participants: [Player]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersBoard.delegate = self
        playersBoard.dataSource = self
        playersBoard.separatorStyle = .singleLine
        playersBoard.estimatedRowHeight = playersBoard.rowHeight
        playersBoard.rowHeight = UITableView.automaticDimension
        
        //joinButton.alpha = 0
        joinButton.isEnabled = false
        messageLabel.alpha = 0
        
        playerCount = 0
        participants = []
        checkPlayers()
   //     fetchPlayers()
    }
    
    func initializeGame(g: Game){
        currentGame = g
        
    }
    
    func checkPlayers(){
        
        ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").queryEnding(beforeValue: 0).observe(.value){
            
            snapshot in
            if snapshot.children.allObjects.count == self.currentGame?.playerCount {
                self.messageLabel.text = "!انتهت اللعبة"
                self.joinButton.alpha = 0
                self.messageLabel.alpha = 1
                // Remove from database to prevent fetching next time?
            }
            else{
                self.joinButton.isEnabled = true
            }
            
            self.fetchBoard()
        }
        
    }
    
    func fetchBoard(){
        // change atValue to beforeValue 0

        ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").queryEnding(beforeValue: 0).observe(.childAdded){
            snapshot in
            
            guard let dict = snapshot.value as? [String: Any] else {return}
            let pid = snapshot.key
            let score = dict["Result"] as? Double
            
            DBManager.getUser(for: pid){
                user in
                let username = user.username
                let player = Player(username: username!, uid: pid, score: score!)
                self.participants?.append(player)
                self.playersBoard.reloadData()
            }
            
        }
        
    }
    
    @IBAction func joinGame(_ sender: Any) {
        
        var exists = false

        let uid = Auth.auth().currentUser!.uid
        for p in participants!{
            if p.uid == uid {
                messageLabel.text = "!انتهى دورك"
                joinButton.alpha = 0
                messageLabel.alpha = 1
                exists = true
                break
            }
        }

            if(!exists){
                
                ref.child("GameParticipants/\(currentGame?.gID)").child(uid).setValue([
                                                                        "Result":0.0])
                
                let ARView = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutViewController") as! WorkoutViewController
                ARView.initializeGame(g: self.currentGame!)
                self.navigationController?.pushViewController(ARView, animated: true)
            }

           var test = "does exits == true reach here or does it BREAK"
        
    }
    

    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let participants = participants{
            return self.participants!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = participants![indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
        cell.player = player
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension Array{
    
    func add(e: Player){
        
        //
        
    }
    
}
