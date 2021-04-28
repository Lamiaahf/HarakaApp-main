
//  ActivitysListTable.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ActivitysListTable: UITableViewController {
    
    var ActivitysList:[Activity]?


    @IBOutlet weak var UserActivitysB: UIButton!
     
    var  UserID : String?
    var followingIDS: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
          UserID = Auth.auth().currentUser?.uid
        Utilities.styleFilledButton(UserActivitysB)

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        ActivitysList = []
        followingIDS = []

        fetchActivity()

    }
    func fetchActivity(){
        
        followingIDS = []
        
        followingIDS!.append(self.UserID!)
        
        DBManager.getFollowing(for: self.UserID!){
            users in
            for u in users{
                self.followingIDS!.append(u.userID!)
            }
             
            
            // retrieve posts from database, may return error or snapshot (snapshot contains data)
            let ref = Database.database().reference()
            ref.child("Activity").observe(.childAdded){
            (snapshot) in
             let id = String(snapshot.key)
                if let ADict = snapshot.value as? [String: Any]{
                let createdByid = ADict["createdByID"] as? String ?? ""
                  
                    if self.followingIDS!.contains(createdByid){
         
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

                /// add createdByid
             //   ref.child("Activity").child(AKey).set(createdByid)
                      
                        let NewActivity = Activity(createdBy: createdByN,createdByi :createdByid, name: Name, disc: dis, DateTime: DT, type: AType, partic: count, Loca : Loc, uid : ID , image : Aimage , id : ID , p : price )
                 //       postArray.insert(newPost, at: indx)
                 
                
                         self.ActivitysList?.append(NewActivity)
                        self.tableView.reloadData()
                         
                    }
            
            
        }
        
    
                
            }
            
        }
        
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
extension ActivitysListTable {
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ActivitysList = ActivitysList {
            return ActivitysList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ACell", for: indexPath) as! ActivityCell
        cell.activi = ActivitysList![indexPath.row]
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
