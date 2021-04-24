//
//  TrainerSearchTable.swift
//  HarakaApp
//
//  Created by lamia on 24/04/2021.
//

import UIKit
import FirebaseDatabase

class TrainerSearchTable: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var TrainersTableView: UITableView!
    let searchTController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    var loggedInTrainers:CurrentUser?
    var trainersArray = [NSDictionary?]()
    var filteredTrainers = [NSDictionary?]()
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


        databaseRef.child("Trainers").child("Approved").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in

                 
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
// SHOULD NOT SHOW THE LOGGEDIN USER
            if(key == self.loggedInTrainers?.uid)
            {
                print("Same as logged in trainer, so don't show!")
            }
            else
            {
                self.trainersArray.append(snapshot)
                //insert the rows
                self.TrainersTableView.insertRows(at: [IndexPath(row:self.trainersArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
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
                return filteredTrainers.count
               }
               return self.trainersArray.count
           }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

             let trainer : NSDictionary?
             
             if searchTController.isActive && searchTController.searchBar.text != ""{

                 trainer = filteredTrainers[indexPath.row]
             }
             else
             {
                 trainer = self.trainersArray[indexPath.row]
             }
             
             cell.textLabel?.text = trainer?["Name"] as? String
             cell.detailTextLabel?.text = trainer?["Username"] as? String
             

             return cell
         }

  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let u = self.trainersArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowTrainerr") as? OtherTrainerTable
         vc?.otherTrainers = u
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
        self.filteredTrainers = self.trainersArray.filter{ user in
 
            let username = user!["name"] as? String
            
            if( username != nil){
            return(username?.lowercased().contains(searchText.lowercased()))!
           
        }
            else {return false}
        }
        
        tableView.reloadData()
    }

    }

    
    
