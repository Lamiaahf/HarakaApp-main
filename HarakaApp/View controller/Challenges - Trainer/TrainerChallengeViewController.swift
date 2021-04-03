//
//  TrainerChallengeViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 02/04/2021.
//

import UIKit
import Firebase

class TrainerChallengeViewController: UITableViewController{
    
    var challenges: [Challenge]?
    var ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchChallenges()
        tableView.reloadData()
    }
    
    func fetchChallenges(){
        
        ref.child("Challenges").observe(.childAdded){
            (snapshot) in
            if snapshot.exists(){
                if let challengeDict = snapshot.value as? [String: Any]{
                    if let chall = challengeDict["ChallengeName"] as? String {
                        let cDesc = challengeDict["ChallengeDescription"] as? String ?? ""
                        let tid = challengeDict["TrainerID"] as? String ?? ""
                        let end = challengeDict["Deadline"] as? Date ?? Date()
                        let cid = snapshot.key
                        
                        let challengeTrainer = DBManager().getTrainer(id: tid)
                        let challenge = Challenge(createdBy: challengeTrainer, enddate: end, cName: chall, cDesc: cDesc, chalID: cid)
                        
                        self.challenges?.append(challenge)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return challenges?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as! ChallengeCell
        cell.challenge = challenges![indexPath.row]


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
