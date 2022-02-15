//
//  SavedListVC.swift
//  TimeApp
//
//  Created by 12345 on 13.11.2021.
//

import Foundation
import UIKit

class SavedListViewController: UIViewController {
    
    @IBOutlet weak var savedTableView: UITableView!
    
    var savedListOfElements: [Element] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SavedListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeTableViewController.listOfElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedIElementsCell", for: indexPath)
        return cell
    }
    
    
}
