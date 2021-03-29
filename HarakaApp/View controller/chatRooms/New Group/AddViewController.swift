//
//  AddViewController.swift
//  HarakaApp
//
//  Created by ohoud on 05/08/1442 AH.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    
    let userDefaults = UserDefaults()

    
    public var completion: ((String, String, Date) -> Void)?
    struct WheelDataPickerStyle{}
  //  var update : (()->void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }

    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty {

            let targetDate = datePicker.date

            completion?(titleText, bodyText, targetDate)

        }
        /*save
       var count = UserDefaults().value
        (forKey : "count") as? int
        
        let newCount = count + 1
        UserDefaults().set(newCount, forKey :"count")
        UserDefaults().set(titleText, forKey :"date_\(newCount)")
        
        update?()
        navigationController?.popViewController(animated:true)
    */
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
