//
//  SearchTableViewController.swift
//  HomePageHaraka
//
//  Created by Noura AlSheikh on 03/02/2021.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {   //UISearchBarDelegate allows us to have access to the methods and functions that allow us to  make the search bar work

    let data = ["المشي","الدراجات","الرماية", "التنس", "كرة القدم", "سكواش", "الهايكنج", "الجري"]   // let means value cannot be edited
    var filteredData: [String]! // (!) means that this field exists but not initialized and var because value will be edited
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self //self refers to the class that i am working in
                                  //searchBar.delegeate to connect the search bae to the class
        filteredData = data //we initialized here
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1    //number of sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell    //Allows us to create a cell
        
        cell.textLabel?.text = filteredData[indexPath.row]                        //textLabel acceses the text inside of the cell and text is to set the text label inside of our table
        //data[indexPath.row] returns the data for which ever row it is
        return cell
    }
    
    //MARK: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {    //Whenever the text in the search bar changes run the code
        
        filteredData = []       //to clear any data there so we can relplace it
        
        if searchText == "" {
            filteredData=data       //if search bar is empty it will repopulate the filtered data
        }
        else{
                for sport in data {
                    if sport.contains(searchText){ //if the sport contains my search Text it will be added to my filtered data
                        
                        filteredData.append(sport)
                }
            }
        }
    
        self.tableView.reloadData()         //to refresh everytime user types a letter
    

}
}
