//
//  CalenderViewController.swift
//  HarakaApp
//
//  Created by ohoud on 04/08/1442 AH.
//
import UserNotifications
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CalenderViewController: UIViewController {
   
    var objRoom : Room!
    
    @IBOutlet weak var table: UITableView!
    
    var models = [MyReminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        observerCalender()
        
        
        /*   let defaults = UserDefaults.standard
        if let saveddate = defaults.object(forKey: "models") as? Data{
            let jsonDecoder = JSONDecoder()
            do{
                models=try jsonDecoder.decode([MyReminder].self , from : saveddate)
            } catch {
                print ("failed")
            }
    }*/

    }
        @IBAction func didTapAdd() {
        // show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }

        vc.title = "المفكرة"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date , identifier: "id_\(title)")
                self.models.append(new)
                //self.save()
                self.table.reloadData()

               /* let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date as String
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)

               let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    print("something went wrong")
                    }
               })*/
            }
        }
       /* vc.update = {
            DispatchQueue.main.async{
            self.updateDate()
        }
        }*/
        navigationController?.pushViewController(vc, animated: true)
}

}

extension CalenderViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension CalenderViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.models[indexPath.row].title
        let date = models[indexPath.row].date
        cell.detailTextLabel?.text=date
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 18)
        return cell
    }
    
    func observerCalender(){
        let dataRef = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference().child("Calender")
        dataRef.observe(.childAdded) {
                (snapshot) in
                if let Edate = snapshot.value as? [String: Any]{
                    if let EventDate = Edate ["EventDate"] as? String , let EventTitle = Edate ["EventTitle"]as? String {
                        let calender = MyReminder(title: EventTitle, date: EventDate, identifier: "")
                        self.models.append(calender)
                        self.table.reloadData()
                    
                }}
            }
        }
    
    
    

 /*   func save() {
        let jsonEncoder = JSONEncoder()
        if let saveddata = try? jsonEncoder.encode(models){
            let defualts = UserDefaults.standard
            defualts.set(saveddata , forKey:"models")
            
        }else {
            print("failed")
        }
    }

}*/

}

struct MyReminder {
    let title: String
    let date: String
    let identifier: String
}

