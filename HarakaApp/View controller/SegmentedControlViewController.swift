//
//  SegmentedControlViewController.swift
//  HarakaApp
//
//  Created by Noura AlSheikh on 11/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class SegmentedControlViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    struct Trainer {
        var username: String?
        var profileImage: UIImage?
    }
    let activities = ["المشي","الدراجات","الرماية", "التنس", "كرة القدم", "سكواش", "الهايكنج", "الجري"]   // let means value cannot be edited
    let locations = ["location1","location2"]
    var users = [User]()
    var trainers = [Trainer]()
    //let users = ["user1","user2"]
    //let trainers = ["trainer1","trainer2"]
    var filteredData: [String]!
    var usersCollectionRef: CollectionReference!
    var trainerCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate =  self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        usersCollectionRef = Firestore.firestore().collection("users")
        trainerCollectionRef = Firestore.firestore().collection("trainers")
        
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        usersCollectionRef.getDocuments { (snapshot, error) in
            if let err = error{
                debugPrint("Error fetching docs: \(error)")
            }
            else{
                print(snapshot?.documents)
            }
        }
        
        trainerCollectionRef.getDocuments { (snapshot, error) in
            if let err = error{
                debugPrint("Error fetching Docs:  \(error)")
            }
            else{
                print(snapshot?.documents)
            }
        }
    }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch controller.selectedSegmentIndex {
        case 0:
            return activities.count
            
        case 1:
            return locations.count
            
        case 2:
            return users.count
            
        case 3:
            return trainers.count
            
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
         switch controller.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = activities[indexPath.row]
        case 1:
            cell.textLabel?.text = locations[indexPath.row]
        case 2:
            usersCollectionRef.getDocuments { (snapshot, error) in
                if let err = error{
                    debugPrint("Error fetching docs: \(err)")
                }
                else{
                    guard let snap = snapshot else {
                        return
                    }
                    for document in snap.documents{
                        let data = document.data()
                        let username = data["username"] as? String
                        
                    }
                }
            }
        case 3:
            trainerCollectionRef.getDocuments { (snapshot, error) in
                if let err = error{
                    debugPrint("Error fetching Docs:  \(err)")
                }
                else{
                    guard let snap = snapshot else {
                        return
                    }
                    for document in snap.documents{
                        let data = document.data()
                        let username = data["username"] as? String
                    }
                }
            }
        default:
            break
        }
        return cell
    }
    
    
    @IBAction func changeSegment(_ sender: Any) {
        tableView.reloadData()
    }
    
    
}
