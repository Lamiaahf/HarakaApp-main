//
//  GameBoardViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 07/04/2021.
//

import UIKit
import Firebase

class GameBoardViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        //tableView.allowsSelection = true
        tableView.dataSource = self
        
    }
}
