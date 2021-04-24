//
//  ChallengeBoardViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 24/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth

class ChallengeBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let ref: DatabaseReference! = Database.database().reference()
    let currentID: String = Auth.auth().currentUser!.uid
    var currentChallenge: Challenge?
    var participants: [Player]?
    
    @IBOutlet weak var scoreBoard: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreBoard.dataSource = self
        scoreBoard.delegate = self
        scoreBoard.separatorStyle = .singleLine
        scoreBoard.estimatedRowHeight = scoreBoard.rowHeight
        scoreBoard.rowHeight = UITableView.automaticDimension
        
        participants = []
        updateBoard()
    }
    
    func updateBoard(){
        
        participants = []
        ref.child("ChallengeParticipants").child((currentChallenge?.chalID)!).queryOrdered(byChild: "Score").observe(.childAdded){
                snapshot in
            
            guard let dict = snapshot.value as? [String:Any] else {return}
            let score = dict["Score"] as? Double
            if(score!>0){
                
                let uid = snapshot.key
                
                DBManager.getUser(for: uid){
                    user in
                    let participant = Player(username: user.username!, uid: uid, score: score!)
                    self.participants?.append(participant)
                    self.participants!.sort {
                        $0.score! < $1.score!
                    }
                    self.scoreBoard.reloadData()
                }

            }
            
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
