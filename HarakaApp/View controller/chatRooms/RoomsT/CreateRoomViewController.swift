//
//  CreateRoomViewController.swift
//  HarakaApp
//
//  Created by ohoud on 16/08/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import DropDown

class CreateRoomViewController: UIViewController {

    @IBOutlet weak var newRoomTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var EImage: UIImageView!
    
    let dropDown = DropDown()
    
        override func viewDidLoad() {
            super.viewDidLoad()

           dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        }

        @IBAction func dismissSecondVC(_ sender: AnyObject) {
            
            self.dismiss(animated: true, completion: nil)
        
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    let Emenu = ["كرة قدم", "كرة سلة", "مشي", "كرة تنس", "كرة طائرة", "دراجات ","جري", "ركوب الخيل", "قولف", "هايكنج", "بولنق","يوقا", "كراتيه", "رماية"]
    
    @IBAction func topChooseMenuItem(_ sender: UIButton) {
        dropDown.dataSource = Emenu
        dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.show()
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal)
                
                if (self?.dropDown.selectedItem == "كرة قدم"){
                    self?.EImage.image = #imageLiteral(resourceName: "Soccer")}
                if (self?.dropDown.selectedItem == "كرة سلة"){
                    self?.EImage.image = #imageLiteral(resourceName: "basketball")}
                if (self?.dropDown.selectedItem == "كرة تنس"){
                    self?.EImage.image = #imageLiteral(resourceName: "Tennis")}
                if (self?.dropDown.selectedItem == "كرة طائرة"){
                    self?.EImage.image = #imageLiteral(resourceName: "volleyball")}
                if (self?.dropDown.selectedItem == "مشي"){
                    self?.EImage.image = #imageLiteral(resourceName: "Walk")}
                if (self?.dropDown.selectedItem == "جري"){
                    self?.EImage.image = #imageLiteral(resourceName: "running")}
                if (self?.dropDown.selectedItem == "دراجات"){
                    self?.EImage.image = #imageLiteral(resourceName: "Bike")}
                if (self?.dropDown.selectedItem == "يوقا"){
                    self?.EImage.image = #imageLiteral(resourceName: "yoga")}
                if (self?.dropDown.selectedItem == "كاراتيه"){
                    self?.EImage.image = #imageLiteral(resourceName: "taekwondo")}
                if (self?.dropDown.selectedItem == "ركوب الخيل"){
                    self?.EImage.image = #imageLiteral(resourceName: "Horse")}
                if (self?.dropDown.selectedItem == "هايكنج"){
                    self?.EImage.image = #imageLiteral(resourceName: "Hike")}
                if (self?.dropDown.selectedItem == "رماية"){
                    self?.EImage.image = #imageLiteral(resourceName: "shooting")}
                if (self?.dropDown.selectedItem == "بولنق"){
                    self?.EImage.image = #imageLiteral(resourceName: "bowling")}
                if (self?.dropDown.selectedItem == "قولف"){
                    self?.EImage.image = #imageLiteral(resourceName: "golf")}
                
            }
    }

    
@IBAction func didPressCreateNewRoom(_ sender: UIButton) {
    guard let userId = Auth.auth().currentUser?.uid,
          let roomName = self.newRoomTextField.text,
          roomName.isEmpty == false else {
        return    }
  //  let EventImage = self.EImage.image
       
    self.newRoomTextField.resignFirstResponder()
    
    let databaseRef = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()

    let roomRef = databaseRef.child("rooms").childByAutoId()
    let roomData:[String: Any] = ["creatorId" : userId, "name": roomName]
        //, "EventImage" : EventImage
    
    
    roomRef.setValue(roomData) { (err, ref) in
        if(err == nil){
            self.newRoomTextField.text = ""
          
        }
    }
    
}

    }
