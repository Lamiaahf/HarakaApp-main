//
//  GameRoomsViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 05/04/2021.
//

import UIKit
import FirebaseDatabase

class GameRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate{
    
    
    @IBOutlet weak var createGame: UIButton!
    @IBOutlet weak var gamesTable: UITableView!
    
    var games: [Game]?
    let transition = CircularTransition()
    let ref: DatabaseReference! = Database.database().reference()
    var colors: [UIColor] = [
        #colorLiteral(red: 0.9417592287, green: 0.7611551881, blue: 0.6725053191, alpha: 1),
        #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
        #colorLiteral(red: 0.8051247001, green: 0.8318073153, blue: 0.994340837, alpha: 1),
        #colorLiteral(red: 0.9041472673, green: 0.7244386077, blue: 0.792001009, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGame.layer.cornerRadius = createGame.frame.size.width / 2
        gamesTable.estimatedRowHeight = gamesTable.rowHeight
        gamesTable.rowHeight = UITableView.automaticDimension
        gamesTable.delegate = self
        gamesTable.dataSource = self
        gamesTable.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
         games = []
        fetchGames()

    }
    
    func fetchGames(){
        
        ref.child("GameRooms").observe(.childAdded, with: { snapshot in
            if let gameDict = snapshot.value as? [String:Any] {
                guard let uid = gameDict["CreatorID"] as? String else {return}
                let name = gameDict["GameName"] as! String
                let count = gameDict["PlayerCount"] as! Int
                let gameKey = snapshot.key
            
                var g = Game(gName: name, uid: uid, gid: gameKey, count: count)

                self.games?.append(g)
                self.gamesTable.reloadData()
            }
        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let games = games{
            return self.games!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = self.games![indexPath.row]
        let cell = gamesTable.dequeueReusableCell(withIdentifier: "GameCell")! as! GameCell
        cell.game = game
        cell.backgroundColor =  colors.randomElement()
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 3
        cell.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = self.games![indexPath.row]
        let gameView = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameView.initializeGame(g: game)
        self.navigationController?.pushViewController(gameView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "createGameSegue"){
            let destinationVC = segue.destination as! CreateGameViewController
            destinationVC.transitioningDelegate = self
            destinationVC.modalPresentationStyle = .custom
        }
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = createGame.center
        transition.circleColor = createGame.backgroundColor!
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = createGame.center
        transition.circleColor = createGame.backgroundColor!
        
        return transition
    }
    
    
    
    
}
