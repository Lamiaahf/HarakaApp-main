//
//  TCreateActivityViewController.swift
//  HarakaApp
//
//  Created by lamia on 27/04/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class TCreateActivityViewController: UIViewController {

    var Activitys = ["كرة التنس", "كرةالسلة","كرة قدم ","كرة طائرة","رماية","كراتيه","يوقا","هايكنج","بولينق","قولف","ركوب الخيل","مشي","جري","دراجات"]
    
    @IBOutlet weak var typeimage: UIImageView!
    
    @IBOutlet weak var typeL: UILabel!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ADescription: UITextField!
    @IBOutlet weak var Alocation: UITextField!
    @IBOutlet weak var price: UITextField!

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
        Utilities.styleTextField(price)
        
        // hide ErrorM Lable
        ErrorM.alpha = 0



        }
    
    @IBAction func ParticipantStepper(_ sender: UIStepper) {
        
        participantLable.text = String( sender.value)
    }
    
    @IBAction func txtDateEditingBegin(_ sender: UITextField) {
        sender.resignFirstResponder()
        showPicker()
    }
    
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, #colorLiteral(red: 0.4173190594, green: 0.5955227613, blue: 0.6585710645, alpha: 1)])
        style.pickerMode = .dateAndTime
        style.titleString  = "التاريخ والزمن  "
        style.returnDateFormat = .yyyy_To_ss
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            self?.DateTime.text = date
        }
        self.present(pick, animated: true, completion: nil)
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
        let Aprice = price.text!.trimmingCharacters(in:.whitespacesAndNewlines)
       

        
        self.ref.child("Trainers").child("Approved").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dict = snapshot.value as? [String:Any] else {return}
            self.CByName = dict["Name"] as? String ?? ""
            
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
            
            let AData = ["ActivityName": Aname , "createdByID" : self.uid,"createdByName" : self.CByName , "Description" : disc,"DateTime" : DT , "ActivityType": type, "NumOfParticipant":part,"location" :Locat , "Image": metaImageUrl , "price" : Aprice ] as [String : Any]
            
         let ID = self.ref.child("Activity").childByAutoId().key
            
            self.ref.child("Activity").child(ID!).setValue(AData)
          //self.ref.child("Activity").child(ID!).updateChildValues(["ActivityID" : ID as Any])
            
     
        }
         

            } ) }
           
        }
        self.dismiss(animated: true, completion: nil)

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
        
        
        
        
    
extension TCreateActivityViewController : UIPickerViewDelegate , UIPickerViewDataSource{
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
    


