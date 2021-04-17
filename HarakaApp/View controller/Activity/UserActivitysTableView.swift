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

            func fetchActivity () {          //get all the followers
                databaseRef.child("JoinedActivity").child(uid!).observeSingleEvent(of :.childAdded, with: { (snapshot) in
            print("data returnd")
            print(snapshot)
            print(snapshot.key)

          //  let snapshot = snapshot.value as? NSDictionary?
                    self.ActivitysID!.append(snapshot.key)
                    print(self.ActivitysID)

                
                    
            }) { (error) in
                print(error.localizedDescription)
            }
            
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

