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
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    var currentGame: Game?
    var playerCount: Int?
    var participants: [Player]?
    
    let ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersBoard.delegate = self
        playersBoard.dataSource = self
        playersBoard.separatorStyle = .singleLine
        playersBoard.estimatedRowHeight = playersBoard.rowHeight
        playersBoard.rowHeight = UITableView.automaticDimension
        
        //joinButton.alpha = 0
        messageLabel.alpha = 0
        self.joinButton.setTitle("انتهت اللعبة", for: .disabled)
        
        playerCount = 0
        participants = []
        checkCount()
   //     fetchPlayers()  << Turn this into updateResults if above works
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPlayers()
    }
    
    func initializeGame(g: Game){
        currentGame = g
        
    }
    
    func checkCount(){
        
        ref.child("GameParticipants").child((currentGame?.gID)!).getData(completion: {
            (error, snapshot) in
            if let error = error {return}
            
            if snapshot.children.allObjects.count == self.currentGame?.playerCount {
                self.joinButton.isEnabled = false
            }
            else{
                self.joinButton.alpha = 1
                for child in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    guard let gameDict = child.value as? [String:Any] else { return }
                    
                    let pid = child.key
                    let score = gameDict["Result"] as? Double
                    
                    DBManager.getUser(for: pid){
                        user in
                        let username = user.username
                        let player = Player(username: username!, uid: pid, score: score!)
                        self.participants?.append(player)
                        self.playersBoard.reloadData()
                    }
                    
                }
            }
        })
    }
    
    func fetchPlayers(){
        // change atValue to beforeValue

        ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").observe(.childAdded){
            snapshot in
            
            print(snapshot.childrenCount)
            self.playerCount = self.playerCount!+1
            
            if(snapshot.childrenCount == (self.currentGame?.playerCount)!){
               // self.joinButton.alpha = 0
                // label.alpha = 1
                self.joinButton.isEnabled = false
            }
            else{
                self.joinButton.alpha = 1
                // label.alpha = 0
            }
            
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
        if(currentGame?.playerCount == participants?.count){
            // popup message
        }
        else{
            let uid = Auth.auth().currentUser!.uid
            for p in participants!{
                if p.uid == uid {
                    exists = true
                    joinButton.alpha = 0
                    messageLabel.text = "!انتهى دورك"
                    messageLabel.alpha = 1
                    
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
        //    self.navigationController?.show(ARView, sender: self)
           
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
