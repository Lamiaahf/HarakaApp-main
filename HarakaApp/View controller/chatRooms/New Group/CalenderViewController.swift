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
     
        let defaults = UserDefaults.standard
        if let saveddate = defaults.object(forKey: "models") as? Data{
            let jsonDecoder = JSONDecoder()
            do{
                models=try jsonDecoder.decode([MyReminder].self , from : saveddate)
            } catch {
                print ("failed")
            }
    }

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
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.save()
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

        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 18)
        return cell
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let saveddata = try? jsonEncoder.encode(models){
            let defualts = UserDefaults.standard
            defualts.set(saveddata , forKey:"models")
            
        }else {
            print("failed")
        }
    }

}


struct MyReminder: Codable {
    let title: String
    let date: Date
    let identifier: String
}

