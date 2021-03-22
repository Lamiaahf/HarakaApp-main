//
//  CalenderViewController.swift
//  HarakaApp
//
//  Created by ohoud on 04/08/1442 AH.
//
import UserNotifications
import UIKit


class CalenderViewController: UIViewController {
   
    

    @IBOutlet weak var table: UITableView!
    
    var models = [MyReminder]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
       /* //save
            if !UserDefaults().bool(forKey:"setup"){
            UserDefaults().set(true , forKey:"setup")
            UserDefaults().set(0, forKey:"count")
            }
        
            updateDate()*/
    }

    
    
  /*  func updateDate(){
        models.removeAll()
    let count = UserDefaults().value(forKey:"count") as? int
   //     else { return }
        for x in 0..<count {
            if let date = UserDefaults().value(forKey :"date_\(x+1)") as? String {
                models.append(date)
            }
        
    }
        tableView.reloadData()
    }*/

    @IBAction func didTapAdd() {
        // show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }

        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()

                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate),
                                                            repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
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

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)

        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        return cell
    }

}


struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}

