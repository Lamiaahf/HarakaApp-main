//
//  ShowTrainner.swift
//  HarakaApp
//
//  Created by lamia on 22/03/2021.
//

import UIKit
import FirebaseDatabase
// ShowTrainner= showspcilest
class ShowTrainner: UIViewController, UITableViewDataSource {

@IBOutlet weak var approveTableView: UITableView!

var ref: DatabaseReference!
var databaseHandle: DatabaseHandle?

    var arrayOfRegisteration = [Trainner]()
   var atitle = [String]()

override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()

    approveTableView.dataSource = self
    approveTableView.delegate = self
    
    approveTableView.tableFooterView = UIView(frame: CGRect.zero)
    
    //display the unaprroved newly registered specialists
    let path = ref?.child("Trainers").child("Unapproved")
    
    databaseHandle = path?.observe(.childAdded, with: { (snapshot) in
        
        let dict = snapshot.value as! NSDictionary
        let key = snapshot.key
        let name = dict["Name"] as! String
        let age = dict["Age"] as! String
        let Username = dict["Username"] as! String
        let likedin = dict["Linkedin"] as! String // Linkdin change it to Linkedin
        let email = dict["Email"] as! String
        let pass = dict["Password"] as! String
        
        

        //specLinked:likedin,
        let specialist = Trainner(specName:name,specAge:age,specusername:Username,specLinked:likedin, specEmail:email, specPassword:pass ,autoKey:key )
        
        self.arrayOfRegisteration.append(specialist)
        self.atitle.append(name)
        
        self.approveTableView.reloadData()
        
    })
    
    
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if  segue.identifier == "RegisterationDetails",
        let destination = segue.destination as? ApproveTrainer,
        let blogIndex = approveTableView.indexPathForSelectedRow?.row
    {
        destination.approveSubject = self.arrayOfRegisteration[blogIndex]
        approveTableView.deselectRow(at:approveTableView.indexPathForSelectedRow!, animated: true)
    }
}
    @IBAction func Logout(_ sender: Any) {
        let storyboard = UIStoryboard(name : "Main",bundle: nil)
        let AdminLogin = storyboard.instantiateViewController(identifier: "loginAdmin")
        present(AdminLogin, animated: true, completion: nil)
    }
    
    

    


}

extension ShowTrainner: UITableViewDelegate{
//, UITableViewDelegate UITableViewDataSource

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "RegisterationDetails", sender: indexPath)
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return atitle.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? approveCell
    
    cell?.approveLbl.text = self.atitle[indexPath.row]
    
    
    return cell!
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100; //custom row height
}

}

