//
//  ShowFriendsTable.swift
//  HarakaApp
//
//  Created by lamia on 17/03/2021.
//

import UIKit
import Firebase
class ShowFriendsTable: UITableViewController, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

        @IBOutlet var followersTable: UITableView!
        var listFollowers = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    var user:CurrentUser?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            //get all the followers
            databaseRef.child("followers").child(self.user!.uid).observe(.childAdded, with: { (snapshot) in
                
                let snapshot = snapshot.value as? NSDictionary
                
                //add the followers to the array
                self.listFollowers.append(snapshot)
                
                //insert row
                self.followersTable.insertRows(at: [IndexPath(row:self.listFollowers.count-1,section:0)], with: UITableView.RowAnimation.automatic)

                
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
            return listFollowers.count
        }
        
      /*
        @IBAction func didTapBack(_ sender: AnyObject) {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        */

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "followersUserCell", for: indexPath)

            cell.textLabel?.text = self.listFollowers[indexPath.row]?["name"] as? String
            
            cell.detailTextLabel?.text = "@"+(self.listFollowers[indexPath.row]?["handle"] as? String)!
            
            return cell
        }


    }
