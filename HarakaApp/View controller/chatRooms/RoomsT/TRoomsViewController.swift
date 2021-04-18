//
//  TRoomsViewController.swift
//  HarakaApp
//

//  Created by ohoud on 22/07/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class TRoomsViewController: UIViewController,  UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
  
    
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
                    let EventImage = dataArray["EventImage"] as? String
                  let creatorName = dataArray["creatorName"] as? String
                    let room = Room.init(rId: snapshot.key, rname: name, EImage: EventImage! , creatorN : creatorName!)
                    

                         
                        self.rooms.append(room)
                self.RoomsTable.reloadData()
   
            }
        }
    }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let chatView = self.storyboard?.instantiateViewController(withIdentifier: "TRoomViewController") as! TRoomViewController
        chatView.room = room
        self.navigationController?.pushViewController(chatView, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rooms.count    }
    
  
   // var EImage = UIImageView()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let room = self.rooms[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for:indexPath as IndexPath ) as! RoomCell
        cell.OBJRoom = room
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
        
      /*  let creatorN = UILabel(frame: CGRect(x: 0 , y: 0 , width: cell.bounds.size.width , height: -40  ))
        creatorN.text = room.ownerName
        creatorN.textAlignment = .center
        creatorN.font = UIFont.italicSystemFont(ofSize:10)*/
        
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


