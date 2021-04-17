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

    selectedTabIndex = 1
  }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let HPVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController")
    let MVC = storyboard.instantiateViewController(withIdentifier: "MapViewController")
    let SBVC = storyboard.instantiateViewController(withIdentifier: "searchBViewController")
    let UPVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
 /*   let CVC = storyboard.instantiateViewController(withIdentifier: "")*/

    viewControllers = [
      HPVC,
      MVC,
      SBVC,
      UPVC
    ]
  }
    

}


