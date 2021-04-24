//
//  OtherTrainerChallengesTable.swift
//  HarakaApp
//
//  Created by lamia on 24/04/2021.
//

import UIKit
import FirebaseDatabase

class OtherTrainerChallengesTable: UITableViewController {

    var otherTrainerID : String?
    var ChallengeList:[Challenge]?


     
    var  UserID : String?
    var followingIDS: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        ChallengeList = []

        fetchChallenge()

    }
    func fetchChallenge(){
  // retrieve Activity from database, may return error or snapshot (snapshot contains data)
        
            let ref =  Database.database().reference()
            ref.child("Challenges").observe(.childAdded){
            (snapshot) in
                if let cDict = snapshot.value as? [String:Any]{
                let createdBy = cDict["CreatorID"] as? String ?? ""
                 


                let  NewChallenge = Challenge(snapshot: snapshot)
                            if(self.otherTrainerID ==  createdBy){
                                self.ChallengeList?.append(NewChallenge!)
                        }

                
                    self.tableView.reloadData()

                }}}}
        
        
    
                
     
extension OtherTrainerChallengesTable {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ActivitysList = ChallengeList {
            return ActivitysList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ACell", for: indexPath) as! ChallengCell
           cell.cha = ChallengeList![indexPath.row]
           return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
  
    
    
    
}

