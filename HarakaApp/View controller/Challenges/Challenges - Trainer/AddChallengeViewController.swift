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
    
    // Method used to create challenge and add it to database
    @IBAction func createChallenge(_ sender: Any) {
        
        // Define a DateFormatter and set it's format
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
        
        
        // Get trainer id
        let creatorID = tid
        // Deadline is current date advanced by 518400s, which is number of seconds in a week
        let deadline = Date().advanced(by:  518400)
        // Convert deadline to string
        let dateString = formatter.string(from: deadline)
        // Get challenge name and description
        let name = cName.text
        let desc = cDesc.text
        
     
        // Store challenge information in DB under "Challenges" child
        ref.childByAutoId().setValue([
                                        "CreatorID":creatorID,
                                        "Deadline":dateString,
                                        "Name":name,
                                        "Description":desc,
                                        "Type":self.type])
        
        // Dismiss page
        self.dismiss(animated: true, completion: nil)
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
