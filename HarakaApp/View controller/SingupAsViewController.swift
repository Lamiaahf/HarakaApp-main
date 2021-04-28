//
//  SingupAsViewController.swift
//  HarakaApp
//
//  Created by lamia on 02/02/2021.
//

import UIKit

class SingupAsViewController: UIViewController, UIViewControllerTransitioningDelegate {
//But = Button
    @IBOutlet weak var UserBut: UIButton!
    @IBOutlet weak var TrainerBut: UIButton!
    
    let transition = CircularTransition()
    let transitionT = CircularTransition()


    override func viewDidLoad() {
        super.viewDidLoad()
        UserBut.layer.cornerRadius = UserBut.frame.size.width / 2


    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (UserBut.isSelected){
        let secondVC = segue.destination as! UserSingupViewController
        secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom}
         else if (TrainerBut.isSelected){

        let secondVC = segue.destination as! TrainerSingupViewController
            secondVC.transitioningDelegate = self
        }
    }
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = UserBut.center
        transition.startingPoint = TrainerBut.center
        transition.circleColor = #colorLiteral(red: 0.4173190594, green: 0.5955227613, blue: 0.6585710645, alpha: 1)
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = UserBut.center
        transition.startingPoint = TrainerBut.center

        transition.circleColor = #colorLiteral(red: 0.4173190594, green: 0.5955227613, blue: 0.6585710645, alpha: 1)
        
        return transition
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  // @IBAction func User(_ sender: Any) {}
    
    
  //  @IBAction func Trainer(_ sender: Any) {}
    
}
/*   UserBut.isUserInteractionEnabled = true
 
 let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingupAsViewController.addPulse))
 tapGestureRecognizer.numberOfTapsRequired = 1
 UserBut.addGestureRecognizer(tapGestureRecognizer)
 
 
}


@objc func addPulse(){
 let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: UserBut.center)
 pulse.animationDuration = 0.8
 pulse.backgroundColor = UIColor.blue.cgColor
 
 self.view.layer.insertSublayer(pulse, below: UserBut.layer)
 
}*/
