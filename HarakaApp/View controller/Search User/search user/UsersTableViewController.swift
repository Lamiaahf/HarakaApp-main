//
//  UsersTableViewController.swift
//  HarakaApp
//
//  Created by lamia on 21/03/2021.
//ohoud

import UIKit
import FirebaseDatabase

class UsersTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var UsersTableView: UITableView!
    let searchTController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    var loggedInUser:CurrentUser?
    var UsersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var testArray = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    
      var inSearchMode = false
      
      var search: String!
      
    //

    override func viewDidLoad() {
        super.viewDidLoad()
         searchTController.searchResultsUpdater = self
         searchTController.obscuresBackgroundDuringPresentation = false
         definesPresentationContext = true
         tableView.tableHeaderView = searchTController.searchBar


        databaseRef.child("users").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in

                 
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
// SHOULD NOT SHOW THE LOGGEDIN USER
            if(key == self.loggedInUser?.uid)
            {
                print("Same as logged in trainer, so don't show!")
            }
            else
            {
                self.UsersArray.append(snapshot)
                //insert the rows
                self.UsersTableView.insertRows(at: [IndexPath(row:self.UsersArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
            }

           
            }) { (error) in
            print(error.localizedDescription)
        }
        
        //ohoud (half page)
       /* let newView = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 600))
                newView.layer.cornerRadius = 20

                self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

                // self.view is now a transparent view, so now I add newView to it and can size it however, I like.

                self.view.addSubview(newView)*/


        
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

 
        
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        // #warning Incomplete implementation, return the number of rows
               
               if searchTController.isActive && searchTController.searchBar.text != " "{
                return filteredUsers.count
               }
               return self.UsersArray.count
           }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

             let user : NSDictionary?
             
             if searchTController.isActive && searchTController.searchBar.text != ""{

                 user = filteredUsers[indexPath.row]
             }
             else
             {
                user = self.UsersArray[indexPath.row]
             }
             
             cell.textLabel?.text = user?["Name"] as? String
             cell.detailTextLabel?.text = user?["Username"] as? String
             

             return cell
         }

  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let u = self.UsersArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowUser") as? OtherUsersViewController
         vc?.otherUser = u
        self.navigationController?.pushViewController(vc!, animated: true)
    }

   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowTrainer" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let Trainer = trainersArray[indexPath.row]
                    let controller = segue.destination as? OtherTrainersViewController
                    controller?.otherTrainers = Trainer
            
                }
            }
        } */
        

       
        
        func updateSearchResults(for searchController: UISearchController) {
            
            filterContent(searchText: self.searchTController.searchBar.text!)

        }
        
    func filterContent(searchText:String)
    {
        self.filteredUsers = self.UsersArray.filter{ user in
 
            let username = user!["Name"] as? String
            
            if( username != nil){
            return(username?.lowercased().contains(searchText.lowercased()))!
           
        }
            else {return false}
        }
        
        tableView.reloadData()
    }

    }

    
    

    




