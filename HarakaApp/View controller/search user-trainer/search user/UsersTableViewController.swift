//
//  UsersTableViewController.swift
//  HarakaApp
//
//  Created by lamia on 21/03/2021.
//ohoud

import UIKit
import FirebaseDatabase

class UsersTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var UsersTable: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    var loggedInUser:CurrentUser?
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var testArray = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    
      var inSearchMode = false
      
      var search: String!
      
    //

    override func viewDidLoad() {
        super.viewDidLoad()
          searchController.searchResultsUpdater = self
          searchController.obscuresBackgroundDuringPresentation = false
          definesPresentationContext = true
          tableView.tableHeaderView = searchController.searchBar


        databaseRef.child("users").queryOrdered(byChild: "Name").observe(.value, with: { (snapshot) in
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
          // SHOULD NOT SHOW THE LOGGEDIN USER
            if(key == self.loggedInUser?.uid)
            {
                print("Same as logged in user, so don't show!")
            }
            else
            {
                self.usersArray.append(snapshot)
                //insert the rows
                self.UsersTable.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
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
               
               if searchController.isActive && searchController.searchBar.text != " "{
                return filteredUsers.count
               }
               return self.usersArray.count
           }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

             let user : NSDictionary?
             
             if searchController.isActive && searchController.searchBar.text != ""{

                 user = filteredUsers[indexPath.row]
             }
             else
             {
                 user = self.usersArray[indexPath.row]
             }
             
             cell.textLabel?.text = user?["Name"] as? String
             cell.detailTextLabel?.text = user?["Username"] as? String
             

             return cell
         }

  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.usersArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowUsers") as? OtherUsersViewController
         vc?.otherUser = user
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowUser" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let user = usersArray[indexPath.row]
                    let controller = segue.destination as? OtherUsersViewController
                    controller?.otherUser = user
            
                }
            }
        } */
        

       
        
        func updateSearchResults(for searchController: UISearchController) {
            
            filterContent(searchText: self.searchController.searchBar.text!)

        }
        
    func filterContent(searchText:String)
    {
        self.filteredUsers = self.usersArray.filter{ user in

            let username = user!["Name"] as? String
            
            if( username != nil){
            return(username?.lowercased().contains(searchText.lowercased()))!
           
        }
            else {return false}
        }
        tableView.reloadData()
    }

    }

    
    




