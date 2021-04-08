//
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
        ref.child("Activitys").observe(.childAdded){
        (snapshot) in
        if let ADict = snapshot.value as? [String: Any]{
                    let Name = ADict["Name"] as? String ?? ""
                    let Loc = ADict["Location"] as? String ?? ""
                    let dis = ADict["Description"] as? String ?? ""
                    let DT = ADict["DateTime"] as? Date
                    let AType = ADict["Type"] as? String ?? ""
                    let count = ADict["participantNum"] as? String ?? ""
                    let createdByid = ADict["createdByID"] as? String ?? ""

                   let createdByN = ADict["createdByName"] as? String ?? ""
                
                    let id = String(snapshot.key)
                  
            let NewActivity = Activity(createdBy: createdByN ,createdByi :createdByid, name: Name, disc: dis, DateTime: DT, type: AType, partic:count, Loca : Loc, uid: id)
             //       postArray.insert(newPost, at: indx)
                    self.ActivitysList?.append(NewActivity)
                  //  postArray.append(newPost)
                //    indx = indx+1
                    self.tableView.reloadData()
                
            }}
   //     self.posts = postArray
        
        }
    }
extension ActivitysListTable{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let activitys = ActivitysList{
            return activitys.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ACell", for: indexPath) as! ActivityCell
        cell.activitys = ActivitysList![indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

