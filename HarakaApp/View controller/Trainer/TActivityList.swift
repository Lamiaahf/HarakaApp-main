//
//  TActivityList.swift
//  HarakaApp
//
//  Created by lamia on 23/04/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TActivityList: UITableViewController {
    
    var ActivitysList:[Activity]?


     
    var  UserID : String?
    var followingIDS: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
          UserID = Auth.auth().currentUser?.uid

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        ActivitysList = []

        fetchActivity()

    }
    func fetchActivity(){
// retrieve Activity from database, may return error or snapshot (snapshot contains data)
        
            let ref = Database.database().reference()
            ref.child("Activity").observe(.childAdded){
            (snapshot) in
             let id = String(snapshot.key)
                if let ADict = snapshot.value as? [String: Any]{
              let createdByid = ADict["createdByID"] as? String ?? ""
              let Name = ADict["ActivityName"] as? String ?? ""
              let Loc = ADict["location"] as? String ?? ""
              let dis = ADict["Description"] as? String ?? ""
                    let DT = ADict["DateTime"] as? String ?? ""
              let AType = ADict["ActivityType"] as? String ?? ""
              let count = ADict["NumOfParticipant"] as? String ?? ""
              let createdByN = ADict["createdByName"] as? String ?? ""
              let Aimage = ADict["Image"] as? String ?? ""
              let ID = ADict ["ActivityID"] as? String ?? ""
              let price = ADict ["price"] as? String ?? ""

                      
                    let NewActivity = Activity(createdBy: createdByN ,createdByi :createdByid, name: Name, disc: dis, DateTime: DT, type: AType, partic:count, Loca : Loc, uid: id, image: Aimage, id: ID, p: price)
                    
                    ref.child("Trainers").child("Approved").child(createdByid).observe(.value){
                    (snapshot) in
                        if(snapshot.exists()){
                        self.ActivitysList?.append(NewActivity)
                            self.tableView.reloadData()
                        }
                        
                    }
                   // self.tableView.reloadData()

    
                
            }
        
        }

    }   }
extension TActivityList {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ActivitysList = ActivitysList {
            return ActivitysList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ACell", for: indexPath) as! ActivityCell
           cell.activi = ActivitysList![indexPath.row]
           return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let act = self.ActivitysList![indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowActivity") as? ActivityDescription
         vc?.Act = act
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
}

