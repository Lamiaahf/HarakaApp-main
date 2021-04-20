//
//  TabBarViewController.swift
//  HarakaApp
//
//  Created by ohoud
//

import UIKit
import AMTabView

class TabBarViewController: AMTabsViewController {

  // MARK: - ViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

   setTabsControllers()

    selectedTabIndex = 0
    }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let HPVC = storyboard.instantiateViewController(withIdentifier: "homeN")
 
    let MVC = storyboard.instantiateViewController(withIdentifier: "MapN")
  
    let SBVC = storyboard.instantiateViewController(withIdentifier: "SearchN")
  
    let UPVC = storyboard.instantiateViewController(withIdentifier: "UserN")
    
    /*   let CVC = storyboard.instantiateViewController(withIdentifier: "")*/

    viewControllers = [
      HPVC,
      MVC,
      SBVC,
      UPVC
    ]
    
    
  }
    

}

class TabBarTViewController: AMTabsViewController {

  // MARK: - ViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

   setTabsControllers()

    selectedTabIndex = 0
    }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let HPVC = storyboard.instantiateViewController(withIdentifier: "homeN2")
 
    let MVC = storyboard.instantiateViewController(withIdentifier: "MapN2")
  
    let SBVC = storyboard.instantiateViewController(withIdentifier: "SearchN2")
  
    let UPVC = storyboard.instantiateViewController(withIdentifier: "TrainerN")
    
    /*   let CVC = storyboard.instantiateViewController(withIdentifier: "")*/

    viewControllers = [
      HPVC,
      MVC,
      SBVC,
      UPVC
    ]
  }
}
