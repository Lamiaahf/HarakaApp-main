//
//  FollowingTableViewController.swift
//  HarakaApp
//
//  Created by lamia on 04/04/2021.
//

import UIKit
import Firebase
class FollowingTableViewController: UITableViewController {

    var user:CurrentUser?
    var databaseRef = Database.database().reference()
    var listFollowing = [NSDictionary?]()
    
    @IBOutlet var followingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            guard let uid = Auth.auth().currentUser?.uid else {print ("nil"); return}


        //get all the followers
            databaseRef.child("following").child(uid).observe(.childAdded, with: { (snapshot) in
        print("data returnd")
            print(snapshot)
            
        let snapshot = snapshot.value as? NSDictionary
        
        //add the users to the array
        self.listFollowing.append(snapshot)
    
            self.followingTableView.insertRows(at: [IndexPath(row:self.listFollowing.count-1,section:0)], with: UITableView.RowAnimation.automatic)

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listFollowing.count
    }

    //dismiss the modal and move back to the meViewController
    @IBAction func didTapDismiss(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingUserCell", for: indexPath)

        print(self.listFollowing[indexPath.row]!)
        
        cell.textLabel?.text = self.listFollowing[indexPath.row]?["Name"] as? String
        cell.detailTextLabel?.text = "@"+(self.listFollowing[indexPath.row]?["Username"] as? String)!
        
        return cell
    }

    
}