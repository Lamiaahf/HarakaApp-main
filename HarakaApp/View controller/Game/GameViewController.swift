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
    let currentID: String = Auth.auth().currentUser!.uid
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
      //  playersBoard.reloadData()
    }
    
    func initializeGame(g: Game){
        currentGame = g
        
    }
    
    // Checks user's eligibility to play the game
    func checkPlayers(){

        ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").observe(.value){
                snapshot in
                // If current user created or joined the game..
                if(snapshot.exists()){
                    
                    guard let keysDict = snapshot.value as? [String:Any] else { return }
                    
                    // check if user already joined or created game
                    if keysDict.keys.contains(self.currentID){
                        guard let playerDict = keysDict[self.currentID] as? [String:Any] else {return}
                        let result = playerDict["Result"] as? Double
                        if result == 0 {
                            // If user created game but didnt play yet
                            self.switchState(state: 1)
                        }
                        else{
                            self.switchState(state: 3)
                        }
                        
                    }
                    else{
                        if keysDict.count == self.currentGame?.playerCount {
                            self.switchState(state: 2)
                        }
                        else{
                            self.switchState(state: 1)
                        }
                    }
 
                    self.fetchBoard(dict: keysDict)
                    
                }
                
            }
       // self.fetchBoard()
    }
    
    // Updates scoreboard
    func fetchBoard(dict: [String:Any]){

      //  ref.child("GameParticipants").child((currentGame?.gID)!).queryOrdered(byChild: "Result").queryEnding(beforeValue: 0).observe(.childAdded){snapshot in}
            
        //      guard let dict = snapshot.value as? [String: Any] else {return}
        //      let pid = snapshot.key
        //      let score = dict["Result"] as? Double
        
        participants = []
        for key in dict.keys{
            let pid = key
            let score = (dict[key] as? [String:Any])!["Result"] as? Double
            if(score!>0){
                DBManager.getUser(for: pid){
                    user in
                    let username = user.username
                    let player = Player(username: username!, uid: pid, score: score!)
                    self.participants?.append(player)
                    self.participants!.sort {
                        $0.score! < $1.score!
                    }
                    self.playersBoard.reloadData()
                }
            }
            
        }
         //   self.playersBoard.reloadData()
            
        
    }
    
    @IBAction func joinGame(_ sender: Any) {
        
        ref.child("GameParticipants").child((currentGame?.gID)!).child(currentID).updateChildValues(["Result":0.0])
        let ARView = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutViewController") as! WorkoutViewController
        ARView.initializeGame(g: self.currentGame!)
        self.navigationController?.pushViewController(ARView, animated: true)
        
    }
    
    func switchState(state: Int){
        
        switch(state){
        
        case 1:
            self.joinButton.isEnabled = true
            self.messageLabel.alpha = 0
            
        case 2:
            self.joinButton.isEnabled = false
            self.joinButton.alpha = 0
            self.messageLabel.text = "اكتمل عدد اللاعبين"
            self.messageLabel.alpha = 1
    
        case 3:
            self.joinButton.isEnabled = false
            self.joinButton.alpha = 0
            self.messageLabel.text = "انتهى دورك!"
            self.messageLabel.alpha = 1
        
        default:
            self.joinButton.isEnabled = false
            self.messageLabel.alpha = 0
        }
        
    }
    

    func checkRank(rank: Int, cell: PlayerCell){
        
        cell.firstPlace.alpha = 0
        
        switch(rank){
        
        case 0:
            cell.firstPlace.alpha = 1
            cell.rankImage.image = UIImage(systemName: "1.circle")
            break
        case 1:
            cell.rankImage.image = UIImage(systemName: "2.circle")
            break
        case 2:
            cell.rankImage.image = UIImage(systemName: "3.circle")
            break
        case 3:
            cell.rankImage.image = UIImage(systemName: "4.circle")
            break
        case 4:
            cell.rankImage.image = UIImage(systemName: "5.circle")
            break
        case 5:
            cell.rankImage.image = UIImage(systemName: "6.circle")
            break
        
        default:
            cell.rankImage.image = UIImage()
        }
        
        cell.rankImage.alpha = 1
    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let participants = participants{
            return self.participants!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = indexPath.item
        var row = indexPath.row
        let player = participants![indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
        checkRank(rank: indexPath.row, cell: cell)
        cell.player = player
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

