//
//  RoomsViewController.swift
//  HarakaApp
//
//  Created by ohoud on 22/07/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UIViewControllerTransitioningDelegate{

    

    @IBOutlet weak var goCreateButton: UIButton!
    
    let transition = CircularTransition()
    
    @IBOutlet weak var RoomsTable: UITableView!
    
    
    
    var rooms = [Room]()
    //var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            goCreateButton.layer.cornerRadius = goCreateButton.frame.size.width / 2

        self.RoomsTable.delegate = self
        self.RoomsTable.dataSource = self
        
     /*   ref = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference();        self.ref.child("rooms").getData(completion:{(error,snapshot)in
            
            if let error = error {print(error.localizedDescription)}
            
            else if (snapshot.exists()){ for child in snapshot.children.allObjects as! [DataSnapshot]{ guard let roomDict = child.value as?[String:Any] else {return}
                
                let name = roomDict["name"] as? String ?? ""
                
                let roomId = roomDict["roomId"] as? String ?? ""
                
                
                let ownerId = roomDict["createrId"] as? String ?? ""
                
                
                let r = Room(rId: roomId, rname: name, oId: ownerId)
                
                
                self.rooms.append(r)
                
                self.RoomsTable.reloadData()
}}
            (snapshot.exists())
        })
        */
        
        
       self.observeRoom()

        // Do any additional setup after loading the view.
    }
    
    func observeRoom(){
        let databaseRef = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference()
        databaseRef.child("rooms").observe(.childAdded) {
            (snapshot) in
            if let dataArray = snapshot.value as? [String: Any]{
                if let name = dataArray ["name"] as? String {
                    let room = Room.init(rId: snapshot.key, rname: name)
                self.rooms.append(room)
                self.RoomsTable.reloadData()
                
            }}
        }
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 3
        cell.layer.borderColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            cell.textLabel?.text = room.name
              return cell
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let chatView = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        chatView.room = room
        self.navigationController?.pushViewController(chatView, animated: true)
    }

  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    

// ui
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let secondVC = segue.destination as! CreateRoomViewController
    secondVC.transitioningDelegate = self
    secondVC.modalPresentationStyle = .custom
}


func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = goCreateButton.center
    transition.circleColor = goCreateButton.backgroundColor!
    
    return transition
}

func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = goCreateButton.center
    transition.circleColor = goCreateButton.backgroundColor!
    
    return transition
}



}


