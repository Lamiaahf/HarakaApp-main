//
//  AddViewController.swift
//  HarakaApp
//
//  Created by ohoud on 05/08/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
   // @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var popUpView: UIView!
    var objRoom  : Room!
    
    public var completion: (() -> Void)?
    struct WheelDataPickerStyle{}
  //  var update : (()->void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
       // bodyField.delegate = self
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        /*navigationItem.rightBarButtonItem = UIBarButtonItem(title: "حفظ", style: .done, target: self, action: #selector(didTapSaveButton))*/
    }

   
 
    
    @IBAction func didTabSaveButton(_ sender: UIButton) {
    
    // @objc func didTapSaveButton() {
        if let titleText = self.titleField.text, !titleText.isEmpty
        /*,
            let bodyText = bodyField.text, !bodyText.isEmpty */
        {

            let targetDate = datePicker.date
           // added
           
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM, dd, YYYY"
            let d = formatter.string(from: date)
           // completion?(titleText, bodyText, d )
            let dataRef = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()
            let CalenRef = dataRef.child("Calender").child(objRoom.roomId!).childByAutoId()
            let calenderData:[String:Any] = [ "EventTitle":titleText , "EventDate": d  /*"EventBody":bodyText*/ ]
        
        CalenRef.setValue(calenderData) { (err, ref) in
            if(err == nil){
                self.titleField.text = ""
               // self.bodyField.text = ""
              
            }
            
        }
            completion?()
        }
     /*  guard let vc = storyboard?.instantiateViewController(identifier: "CalenderViewController") as? CalenderViewController else {
            return}
                navigationController?.pushViewController(vc, animated: true)*/
        self.dismiss(animated: true, completion: nil)
    
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    
    }
    
    

    

}
