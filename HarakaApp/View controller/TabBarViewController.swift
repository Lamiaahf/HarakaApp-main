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
    let HPVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController")
    let nav1 = UINavigationController (rootViewController: HPVC)
    let MVC = storyboard.instantiateViewController(withIdentifier: "MapViewController")
    let nav2 = UINavigationController (rootViewController: MVC)
    let SBVC = storyboard.instantiateViewController(withIdentifier: "searchBViewController")
    let nav3 = UINavigationController (rootViewController: SBVC)
    let UPVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
    let nav4 = UINavigationController (rootViewController: UPVC) /*   let CVC = storyboard.instantiateViewController(withIdentifier: "")*/

    viewControllers = [
      HPVC,
      MVC,
      SBVC,
      UPVC
    ]
  }
    

}


