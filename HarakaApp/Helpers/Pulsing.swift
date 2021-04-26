//
//  Pulsing.swift
//  CoreAnimation
//
//  Created by Training on 16/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class Pulsing: CALayer {

    var animationGroup = CAAnimationGroup()
    
    var initialPulseScale:Float = 0
    var nextPulseAfter:TimeInterval = 0
    var animationDuration:TimeInterval = 1.5
    var radius:CGFloat = 200
    var numberOfPulses:Float = Float.infinity
    
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init (numberOfPulses:Float = Float.infinity, radius:CGFloat, position:CGPoint) {
        super.init()
        
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                 self.add(self.animationGroup, forKey: "pulse")
            }
        }

        
        
    }
    
    
    func createScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
    
        
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
        
        
    }
    
    
    
}
/*   UserBut.isUserInteractionEnabled = true
 UserBut.isEnabled = true

 
 let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingupAsViewController.addPulse))
 tapGestureRecognizer.numberOfTapsRequired = 1
 UserBut.addGestureRecognizer(tapGestureRecognizer)
 
 
}


@objc func addPulse(){
 let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: UserBut.center)
 pulse.animationDuration = 0.8
 pulse.backgroundColor = #colorLiteral(red: 0.4173190594, green: 0.5955227613, blue: 0.6585710645, alpha: 1)
 
 self.view.layer.insertSublayer(pulse, below: UserBut.layer)

}*/
