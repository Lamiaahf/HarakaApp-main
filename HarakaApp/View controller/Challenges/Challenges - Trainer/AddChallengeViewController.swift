//
//  AddChallengeViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 20/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AddChallengeViewController: UIViewController {

    var types = ["هايكنق", "ركوب دراجات","مشي", "جري"]
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var cName: UITextField!
    @IBOutlet weak var cDesc: UITextView!
    @IBOutlet weak var typePicker: UIPickerView!
    var type: String?
    @IBOutlet weak var createButton: UIButton!
    
    let ref: DatabaseReference = Database.database().reference().child("Challenges")
    let tid: String = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker.delegate = self
        typePicker.dataSource = self
        
        Utilities.styleTextField(cName)
        Utilities.styleFilledButton(createButton)
        Utilities.styleTextView(textBox: cDesc)
        
        hideKeyboardWhenTappedAround()

        
    }
    
    
    @IBAction func createChallenge(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
     //   formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = Locale.current
        
        guard let imageSelected = typeImage.image else {return}
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        
        let creatorID = tid
        let deadline = Date().advanced(by:  518400)
        let dateString = formatter.string(from: deadline)
        let name = cName.text
        let desc = cDesc.text
        
     
        ref.childByAutoId().setValue([
                                        "CreatorID":creatorID,
                                        "Deadline":dateString,
                                        "Name":name,
                                        "Description":desc,
                                        "Type":self.type])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddChallengeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return types.count
    }
    func pickerView(_ pickerView: UIPickerView , titleForRow row: Int, forComponent component : Int) -> String? {
        return types[row]    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeImage.image = UIImage (named: types[row])
        self.type = types[row]
    }
    
    
}
