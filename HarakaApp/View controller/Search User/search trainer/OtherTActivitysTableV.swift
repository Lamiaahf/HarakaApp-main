//
//  OtherTActivitysTableV.swift
//  HarakaApp
//
//  Created by lamia on 21/04/2021.
//

import UIKit
import Firebase
//container
class OtherTActivitysTableV: UITableViewController {

   
     var otherTrainerID: String?
     var ActivitysList:[Activity]?


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        ActivitysList = []
        fetchActivity()
    }
    func fetchActivity(){

        // retrieve posts from database, may return error or snapshot (snapshot contains data)
        let ref = Database.database().reference()
        ref.child("Activity").observe(.childAdded){
        (snapshot) in
         let id = String(snapshot.key)
          if let ADict = snapshot.value as? [String: Any]{
          let Name = ADict["ActivityName"] as? String ?? ""
          let Loc = ADict["location"] as? String ?? ""
          let dis = ADict["Description"] as? String ?? ""
          let DT = ADict["DateTime"] as? String ?? ""
          let AType = ADict["ActivityType"] as? String ?? ""
          let count = ADict["NumOfParticipant"] as? String ?? ""
          let createdByid = ADict["createdByID"] as? String ?? ""
          let createdByN = ADict["createdByName"] as? String ?? "" 
          let Aimage = ADict["Image"] as? String ?? ""
          let ID = ADict ["ActivityID"] as? String ?? ""
          let price = ADict ["price"] as? String ?? ""

           
            let NewActivity = Activity(createdBy: createdByN ,createdByi :createdByid, name: Name, disc: dis, DateTime: DT , type: AType, partic:count, Loca : Loc, uid: id, image: Aimage, id: ID, p: price)
            
            if (createdByid == self.otherTrainerID){
                    self.ActivitysList?.append(NewActivity)
            }
                    self.tableView.reloadData()
                
            }}
        
        }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowActivity" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let Activity = ActivitysList![indexPath.row]
                    let controller = segue.destination as? ActivityDescription
                    controller?.Act = Activity
            
                }
            }
        }*/

}
extension OtherTActivitysTableV {
    
    
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
    
  
    
    
    
}
