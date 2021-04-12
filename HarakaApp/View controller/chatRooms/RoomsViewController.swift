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


class RoomsViewController: UIViewController,  UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
  
    
    var colors:[UIColor] = [
        #colorLiteral(red: 0.9766376615, green: 0.5785049796, blue: 0.1343751848, alpha: 1),
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
        #colorLiteral(red: 0.3974583745, green: 0.5797579885, blue: 0.6469487548, alpha: 1),
        #colorLiteral(red: 0.9766376615, green: 0.5785049796, blue: 0.1343751848, alpha: 1),
        #colorLiteral(red: 0.6096846461, green: 0.7915071845, blue: 0.8629189134, alpha: 1),
        #colorLiteral(red: 0.7747570276, green: 0.8219625354, blue: 0.9175457954, alpha: 1),
        #colorLiteral(red: 0.7485505939, green: 0.8943883777, blue: 0.9117907286, alpha: 1)
           ]

   
    @IBOutlet weak var goCreateButton: UIButton!
    
    let transition = CircularTransition()
    
    
    @IBOutlet weak var RoomsTable: UICollectionView!
   // @IBOutlet weak var RoomsTable: UICollectionView!
    
//    @IBOutlet weak var EImage: UIImageView!
    
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
    let DefImage : UIImageView = {
    let DEIMAGE = UIImageView()
    DEIMAGE.image = UIImage(systemName: "person.3")
        
        return DEIMAGE
    }()
    
    
    func observeRoom(){
        let databaseRef = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference()
        databaseRef.child("rooms").observe(.childAdded) {
            (snapshot) in
            if let dataArray = snapshot.value as? [String: Any]{
                if let name = dataArray ["name"] as? String {
                
                        let EventImage = dataArray["EventImage"] as? UIImageView
                    let room = Room.init(rId: snapshot.key, rname: name , EImage: EventImage ?? self.DefImage   )
                    
                    /*
                    Storage.storage().reference(forURL: room.EventImage).getData(maxSize: 1048576, completion: { (data, error) in

                        guard let imageData = data, error == nil else {
                            return
                        }
                        room.EventImage.image = UIImage(data: imageData)
                        self.setupEventImage()*/
                        self.rooms.append(room)
                self.RoomsTable.reloadData()
                
            }}
        }
    }
    
    
     /* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.backgroundColor =  #colorLiteral(red: 0.9253895879, green: 0.9255481362, blue: 0.9253795743, alpha: 0.5479452055)
        
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 3
        cell.layer.borderColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            cell.textLabel?.text = room.name
              return cell
    }*/
  
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let chatView = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        chatView.room = room
        self.navigationController?.pushViewController(chatView, animated: true)
    }*/

  
    
    
  /*  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let chatView = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        chatView.room = room
        self.navigationController?.pushViewController(chatView, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rooms.count    }
    
  
   // var EImage = UIImageView()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let room = self.rooms[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for:indexPath as IndexPath )
        cell.backgroundColor =  colors.randomElement()
       cell.layer.cornerRadius = 5
      
      var EImage = room.EventImage
       // cell.layer.borderWidth = 3
        // cell.layer.borderColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      //  let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        let groupName = UILabel(frame: CGRect(x: 0 , y: 0 , width: cell.bounds.size.width , height: 40  ))
        groupName.textColor=UIColor.white
        groupName.text = room.name
        groupName.textAlignment = .center
        groupName.font = UIFont.boldSystemFont(ofSize:15)
      
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.5
        cell.contentView.addSubview(groupName)
              return cell
    }
    
   /* func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)}*/
        
        
    
    
    

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


