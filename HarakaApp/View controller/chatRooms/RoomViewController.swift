//
//  RoomViewController.swift
//  HarakaApp
//
//  Created by ohoud on 22/07/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    
    
  
    //image?
    
    var room:Room?
    var messages = [Message]()

  
    @IBOutlet weak var newMessageTextField: UITextField!
    
    @IBOutlet weak var messagesTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.roomNameLabel.text = self.room?.name
         self.navigationItem.title = self.room?.name
         self.messagesTable.delegate = self
         self.messagesTable.dataSource = self
         self.messagesTable.separatorStyle = .none
         self.messagesTable.allowsSelection = false
         observerMessages()
         // Do any additional setup after loading the view.
    }
    func observerMessages(){
        let messagesRef = Database.database().reference().child("rooms").child((self.room?.roomId)!).child("messages")
        
        messagesRef.observe(.childAdded) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                if let senderId = data["senderId"] as? String,
                   let senderName = data["senderName"] as? String{
                    var message:Message?
                    
                    if let text = data["text"] as? String {
                        message = Message(senderId: senderId, messageText: text, senderUsername: senderName, imageLink: nil)
                    } else if let imageLink = data["imageLink"] as? String{
                        message = Message(senderId: senderId, messageText: nil, senderUsername: senderName, imageLink: imageLink)
                    }
                    
                    if message != nil {
                        
                        self.messages.append(message!)
                        self.messagesTable.reloadData()
                    }
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
     //   print("message \(indexPath.row) sender: \(message.senderUsername)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell2") as! ChatCell
        if(Auth.auth().currentUser?.uid == message.senderId){
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }
        cell.setBubbleDataForMessage(message: message)
        return cell
    }
    

    @IBAction func didPressSendMessage(_ sender: UIButton) {
    
    
        if let messageText = self.newMessageTextField.text{
            self.sendMessage(text: messageText, imageLink: nil)
        }    }
    
    func sendMessage(text: String?, imageLink: String?){
        if let userId = Auth.auth().currentUser?.uid,
           let roomId = self.room?.roomId{
            
            let roomRef = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference().child("rooms").child(roomId)
            let newMessageRef = roomRef.child("messages").childByAutoId()
            //   ServerValue.timestamp()
            let ref = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference().child("users").child(userId).child("Username")
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let userName = snapshot.value as! String
                if(text != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName, "text": text!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                } else if(imageLink != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName, "imageLink": imageLink!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                }
                
                self.newMessageTextField.text = ""
                self.newMessageTextField.resignFirstResponder()
            }
            let refT = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference().child("Trainers").child("Approved").child(userId).child("Username")
            
            refT.observeSingleEvent(of: .value) { (snapshot) in
                let userName = snapshot.value as! String
                if(text != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName, "text": text!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                } else if(imageLink != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName, "imageLink": imageLink!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                }
                
                self.newMessageTextField.text = ""
                self.newMessageTextField.resignFirstResponder()
            }        }
    }
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
