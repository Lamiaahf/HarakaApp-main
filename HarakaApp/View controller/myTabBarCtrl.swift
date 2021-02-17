//
//  myTabBarCtrl.swift
//  HomePageHaraka
//
//  Created by Noura AlSheikh on 03/02/2021.
//

import Foundation
import UIKit
//import SwiftIcons

class MyTabBarCtrl: UITabBarController, UITabBarControllerDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
   }
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {

            //let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            
            //STYLE THE BUTTON YOUR OWN WAY
            //middleBtn.setIcon(icon: .fontAwesomeSolid(.home), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
            //middleBtn.applyGradient(colors: colorBlueDark.cgColor,colorBlueLight.cgColor])
            
            //add to the tabbar and add click event
            //self.tabBar.addSubview(middleBtn)
            //middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

            self.view.layoutIfNeeded()
        }

        // Menu Button Touch Action
        @objc func menuButtonAction(sender: UIButton) {
            self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
        }
}
