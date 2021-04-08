//
//  CreateActivity.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

    class CreateActivity: UIViewController {
    
    var Activitys = ["كرة التنس ", "كرة السلة ","كرة قدم ","كرة طائرة","رماية","كراتيه","يوقا","هايكنج","بولينق","قولف","ركوب الخيل ","مشي","جري","دراجات"]
    
    @IBOutlet weak var typeimage: UIImageView!
    
    @IBOutlet weak var typeL: UILabel!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ADescription: UITextField!
    @IBOutlet weak var Alocation: UITextField!
        
    @IBOutlet weak var DateTime: UIDatePicker!
    @IBOutlet weak var ActivityTypePicker : UIPickerView!
    
    
    @IBOutlet weak var participantLable: UILabel!
    
    @IBOutlet weak var createB: UIButton!
        var ref = Database.database().reference()

    override func viewDidLoad() {

        super.viewDidLoad()

        // Activate the  ActivityTypePicker
        ActivityTypePicker.delegate = self
        ActivityTypePicker.dataSource = self
        // Style
        Utilities.styleFilledButton(createB)
        Utilities.styleTextField(Name)
        Utilities.styleTextField(Alocation)
        Utilities.styleTextField(ADescription)

        }
    
    @IBAction func ParticipantStepper(_ sender: UIStepper) {
        
        participantLable.text = String( sender.value)
    }
    
    @IBAction func CreateBTap(_ sender: Any) {
        validatefields()
        let type = typeL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Aname = Name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let disc = ADescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     //   let DT = DateTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let part = participantLable.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let Locat = Alocation.text!.trimmingCharacters(in:.whitespacesAndNewlines)

        
        
        let user = Auth.auth().currentUser
        let UID = user?.uid
        let Uname =  "لمياء"
        let AData = ["createdByID" : UID!,"createdByName" : Uname , "Description" : disc,"DateTime" : DateTime , "ActivityType": type, "NumOfParticipant":part,"location" :Locat ] as [String : Any]
        
        self.ref.child("Activity").childByAutoId().setValue(AData) { (error, snapshot) in if let error = error {
            debugPrint("error adding post: \(String(describing: error))")
        }}
        
     //   self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
        func validatefields() {
        // all fields filled in
            if Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                typeL.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                ADescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            //    DateTime.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                participantLable.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
                Alocation.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                let m = "الرجاء التأكد من أن جميع الحقول ممتلئة ."
                let t = "عذرا "
                Service.createAlertController(title: t ,message: m)
            }
            
        }
    }

extension CreateActivity : UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return Activitys.count
    }
    func pickerView(_ pickerView: UIPickerView , titleForRow row: Int, forComponent component : Int) -> String? {
        return Activitys[row]    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeL.text = Activitys[row]
        typeimage.image = UIImage (named: Activitys[row])
    }
}

