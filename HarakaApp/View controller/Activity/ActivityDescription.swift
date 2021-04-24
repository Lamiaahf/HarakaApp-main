//
//  ActivityDescription.swift
//  HarakaApp
//
//  Created by lamia on 10/04/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class ActivityDescription: UIViewController {
    
    @IBOutlet weak var Activiimg : UIImageView!
    @IBOutlet weak var ActivitName: UILabel!
    @IBOutlet weak var ADesc: UILabel!
    @IBOutlet weak var ActivitType: UILabel!
    @IBOutlet weak var ADataTime: UILabel!
    @IBOutlet weak var CName: UILabel!
    @IBOutlet weak var Count: UILabel!
    @IBOutlet weak var ALoca: UILabel!
    
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var priceValue: UILabel!

    
    @IBOutlet weak var JoinB: UIButton!
    
    var databaseRef = Database.database().reference()
     var ActivityID  = ""
     var count  = ""

   // var UserData :NSDictionary?

    var id : String?
    var Act : Activity!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceLable.alpha = 0
        self.priceValue.alpha = 0
      
        Utilities.styleFilledButton(JoinB)
        id = Auth.auth().currentUser?.uid
      //  AddcreatedByid()
        
        fetchActivity()
        
        databaseRef.child("Trainers").child("Approved").child(id!).observe(.childAdded){
        (snapshot) in
            if(snapshot.exists()){
                self.JoinB.alpha = 0
                self.priceLable.alpha = 1
                self.priceValue.alpha = 1

            }
            
        }

        databaseRef.child("JoinedActivity").child(id!).child(ActivityID).observe(.value, with: {(snapshot) in
        
                if(snapshot.exists())
                {
                    self.JoinB.setTitle(" تم الانضمام", for: .normal)
                    print("You Can't join the Activity")

                }
                else
                {
                    self.JoinB.setTitle("الانضمام", for: .normal)
                    print("You Can join the Activity")
                }
        
     //   let  id = Auth.auth().currentUser?.uid
      })
        
        }
    
    func fetchActivity(){

        let Name = Act.Aname
        let Loc = Act.ALoca
        let dis = Act.Adisc
        let DT = Act.ADateTime!
        let AType = Act.Atype
        count = Act.Apartic!
        let createdByN = Act.createdByName
        let Image  = Act.AImage!
        ActivityID = Act.ActivityID!

        Storage.storage().reference(forURL: Image).getData(maxSize: 1048576, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
           // self.Userimg.image = UIImage(data: imageData)
          //  self.setupUserimg()
            
            // add Vakue to the Labels
            self.ActivitName.text = Name
            self.ADesc.text = dis
            self.ActivitType.text = AType
            
            // Convert Date to String
            self.ADataTime.text = DT
            self.CName.text = createdByN
            self.ALoca.text = Loc
            self.Count.text = self.count
            self.Activiimg.image = UIImage(data: imageData)
         //   self.CountInt = Int(count!)
            

        })

                            }
    
    
    
  
            
          
    
    @IBAction func JoinTap(_ sender: Any) {
        
        if (self.JoinB.titleLabel?.text == " تم الانضمام  "){ return}
    
         // to chcke the number of users are join the Activity
        /* let JoinedNum = self.databaseRef.child("JoinedActivity").child( self.uid).observe(DataEventType.value, with: { (snapshot) in
       print(snapshot.childrenCount)
      })*/
 //  let   JoinedN = String(JoinedNum)
        var JoinedN = 0
        let countInt = Int(self.count)
        if (JoinedN == countInt ){
            
       
            
            print("alert")
 
        } //first if
        
        else
        {
           
        //if (self.JoinB.titleLabel?.text == " الانضمام ")
       //   {
              print("انضم للفعالية")
              
             // add the new user id to JoinedActivitys
            databaseRef.child("JoinedActivity").child(id!).child(ActivityID).setValue("")
            JoinedN = JoinedN+1
    //let joinRef = "JoinedActivity/" + (ActivityID as! String) + "/" + (self.id! as! String )
              print("تم الانضمام بنجاح ")
              
              JoinB.isEnabled = false
        //  }
                }

    
        
        
        
    }
    
}

