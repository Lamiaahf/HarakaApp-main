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
    
    var currentGame: Game?
    var playerCount: Int?
    var participants: [Player]?
    
    @IBOutlet weak var joinButton: UIButton!
    let ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersBoard.delegate = self
        playersBoard.dataSource = self
        playersBoard.separatorStyle = .singleLine
        playersBoard.estimatedRowHeight = playersBoard.rowHeight
        playersBoard.rowHeight = UITableView.automaticDimension
        
        joinButton.alpha = 0
        
        playerCount = 0
        participants = []
        fetchPlayers()
    }
    
    func initializeGame(g: Game){
        currentGame = g
        
    }
    
    func fetchPlayers(){
        // change atValue to beforeValue
        
        ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").observe(.childAdded){
            snapshot in
            
            guard let dict = snapshot.value as? [String: Any] else {return}
            let pid = snapshot.key
            let score = dict["Result"] as? Double
          
            let player = Player(username: "empty", uid: pid, score: score!)
            
            self.participants?.append(player)
            self.playersBoard.reloadData()
            self.joinButton.alpha = 1
            //Replace above code with below later
            /*
            DBManager.getUser(for:pid){
                user in
                let username = user.username
                let player = Player()
                self.participants?.append(player)
                self.playersBoard.reloadData()
            }*/
            
        }
        
    }
    
    @IBAction func joinGame(_ sender: Any) {
        
        var exists = false
        if(currentGame?.playerCount == participants?.count){
            // popup message
        }
        else{
            let uid = Auth.auth().currentUser!.uid
            for p in participants!{
                if p.uid == uid {
                    exists = true
                    break
                }
            }
            // DBManager add method call ... or dont? we dont need username right now
            if(!exists){
                let player = Player(username: "Empty", uid:uid , score: 0)
                
                ref.child("GameParticipants/\(currentGame?.gID)").child(uid).setValue([
                                                                        "Result":0.0])
                
            }
            let ARView = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutViewController") as! WorkoutViewController
            ARView.initializeGame(g: self.currentGame!)
            self.navigationController?.pushViewController(ARView, animated: true)
           
        }
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
