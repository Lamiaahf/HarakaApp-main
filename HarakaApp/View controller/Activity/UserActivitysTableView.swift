//
//  UserActivitysTableView.swift
//  HarakaApp
//
//  Created by lamia on 17/04/2021.
//

import UIKit
import Firebase

class UserActivitysTableView: UITableViewController {


        var user:CurrentUser?
        var databaseRef = Database.database().reference()
        var UserActivitys:[Activity]?
        var ActivitysID:[String]?
        var uid = Auth.auth().currentUser?.uid
   
        
        
        override func viewDidLoad() {
                super.viewDidLoad()
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = tableView.rowHeight
                tableView.rowHeight = UITableView.automaticDimension
                tableView.delegate = self
                
                UserActivitys = []
                ActivitysID = []
                fetchActivity()
            }

            func fetchActivity () {
                //get all the JoinedActivitys id
                databaseRef.child("JoinedActivity").child(uid!).observeSingleEvent(of :.value, with : { [self] (snapshot) in
                    
                    for item in snapshot.children{

                        self.ActivitysID!.append((item as AnyObject).key)
                            }
                    print (ActivitysID!)
                        })
                for ID in self.ActivitysID! {
                    print(ID)
                    // to git the JoinedActivity Data and show them in the table
                    databaseRef.child("Activity").child(ID).observeSingleEvent(of :.childAdded, with : { (snapshot) in

                         if (snapshot.exists()){
                            if let ADict = snapshot.value as? [String: Any]{
                            let id = String(snapshot.key)
                            let Name = ADict["ActivityName"] as? String ?? ""
                            let Loc = ADict["location"] as? String ?? ""
                            let dis = ADict["Description"] as? String ?? ""
                            let DT = ADict["DateTime"] as? String
                            let AType = ADict["ActivityType"] as? String ?? ""
                            let count = ADict["NumOfParticipant"] as? String ?? ""
                            let createdByid = ADict["createdByID"] as? String ?? ""
                            let createdByN = ADict["createdByName"] as? String ?? ""
                            let Aimage = ADict["Image"] as? String ?? ""
                            let ID = ADict ["ActivityID"] as? String ?? ""
                            let T = ADict ["Type"] as? String ?? ""

                                let NewActivity = Activity(createdBy: createdByN ,createdByi :createdByid, name: Name, disc: dis, DateTime: DT, type: AType, partic:count, Loca : Loc, uid: id, image: Aimage, id: ID, t: T)
                                self.UserActivitys?.append(NewActivity)
                                self.tableView.reloadData()

                            }}

                    
                    
                        })
                        
                    }
                    
                print(self.UserActivitys!)

                
                
                
            }
    
    

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        // MARK: - Table view data source


        
    }
extension UserActivitysTableView {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ActivitysList = UserActivitys {
            return ActivitysList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ACell", for: indexPath) as! ActivityCell
        cell.activi = UserActivitys![indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let act = self.UserActivitys![indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowActivity") as? ActivityDescription
         vc?.Act = act
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
}

