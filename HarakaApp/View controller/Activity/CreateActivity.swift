//
//  CreateActivity.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CreateActivity: UIViewController {
    
    var Activitys = ["كرة التنس", "كرةالسلة","كرة قدم ","كرة طائرة","رماية","كراتيه","يوقا","هايكنج","بولينق","قولف","ركوب الخيل","مشي","جري","دراجات"]
    
    @IBOutlet weak var typeimage: UIImageView!
    
    @IBOutlet weak var typeL: UILabel!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ADescription: UITextField!
    @IBOutlet weak var Alocation: UITextField!

    @IBOutlet weak var ErrorM: UILabel!

    @IBOutlet weak var DateTime: UITextField!
        let dateTP = UIDatePicker()
        
    @IBOutlet weak var ActivityTypePicker : UIPickerView!
    
    
    @IBOutlet weak var participantLable: UILabel!
    
    @IBOutlet weak var createB: UIButton!
        var ref = Database.database().reference()
        var uid = Auth.auth().currentUser?.uid
        var type = " "
        var CByName = " "
        var image :UIImage? = nil

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
        Utilities.styleTextField(DateTime)
        
        // hide ErrorM Lable
        ErrorM.alpha = 0

        creatDatePicker()


        }
    
    @IBAction func ParticipantStepper(_ sender: UIStepper) {
        
        participantLable.text = String( sender.value)
    }
    
        func creatDatePicker()  {
            DateTime.textAlignment = .right
            //toolbare
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            //bar button
            let doneBtn = UIBarButtonItem (barButtonSystemItem:.done , target: nil, action: #selector(donePressed))
            toolbar.setItems([doneBtn], animated: true)
            
            // assining toolbare
            DateTime.inputAccessoryView = toolbar
            //assinge date pickre to text filde
            DateTime.inputView = dateTP
            // date picker mode to remove the time
            dateTP.datePickerMode = .dateAndTime
        }
        @objc func donePressed(){
            //formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.dateFormat = "yyyy-MM-dd at HH:mm"
            DateTime.text = formatter.string(from: dateTP.date )
            self.view.endEditing(true)
        }
        
    @IBAction func CreateBTap(_ sender: Any) {
        image = typeimage.image
    guard let imageSelected = self.image else {return}
    guard let  imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}

        // Validate the fields
        let error = validatefields()
        
        if error != nil {
            
        // There's something wrong with the fields, show error message
            showError(error!)
        }
 
        else{
        let type = typeL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Aname = Name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let disc = ADescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let DT = DateTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let part = participantLable.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let Locat = Alocation.text!.trimmingCharacters(in:.whitespacesAndNewlines)

        self.ref.child("users").child(self.uid!).observe(.value , with : { snapshot in
            if snapshot.exists(){

    
        guard let dict = snapshot.value as? [String:Any] else {return}
              
            let user = CurrentUser( uid : self.uid! , dictionary : dict )
                self.CByName = user.name
            }
            else{return}

        })
        
     
        // save the image to firbase Storage and user

        let storageRef = Storage.storage().reference(forURL: "gs://haraka-73619.appspot.com")
        let StorageActivityRef  = storageRef.child("ActivityImage").child(Aname)
                         //.child(currentUser.uid)
         let metaData = StorageMetadata()
                         
          metaData.contentType = "image/jpg"
          StorageActivityRef.putData( imageData ,metadata: metaData) { (StorageMetadata, error) in
            if error != nil { print (error?.localizedDescription as Any)}
                             // save image url as string
            StorageActivityRef.downloadURL(completion: {(url , error ) in
        if let metaImageUrl = url?.absoluteString {
            
            let AData = ["ActivityName": Aname , "createdByID" : self.uid,"createdByName" : self.CByName , "Description" : disc,"DateTime" : DT , "ActivityType": type, "NumOfParticipant":part,"location" :Locat , "Image": metaImageUrl  ] as [String : Any]
            
         let ID = self.ref.child("Activity").childByAutoId().key
            
            self.ref.child("Activity").child(ID!).setValue(AData)
            self.ref.child("Activity").child(ID!).updateChildValues(["ActivityID" : ID as Any])
            
     
        }
           let alert = Service.createAlertController(title: "شكرا", message: "تم انشاء الفعالية بنجاح")
                self.present(alert, animated: true, completion: nil)
            } ) }
            self.dismiss(animated: true, completion: nil)

        }
        }
      
    func AddcreatedByid(_ ID:String) {
       
        self.ref.child("JoinedActivity").child(ID).child(self.uid!).setValue("")
            }
    
    
        
    func validatefields() -> String? {
        // all fields filled in
            if Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                typeL.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                ADescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                DateTime.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                participantLable.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
                Alocation.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               
                return "الرجاء التأكد من أن جميع الحقول ممتلئة ."

                
            }
            
        return nil
        }
    
    func showError(_ message : String )  {
        ErrorM.text = message
        ErrorM.alpha = 1
    }
    }// END OF CLASS
        
        
        
        
    
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
    

