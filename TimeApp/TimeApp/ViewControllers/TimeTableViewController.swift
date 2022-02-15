//
//  TimeTableViewController.swift
//  TimeApp
//
//  Created by 12345 on 30.07.2021.
//

import UIKit


class TimeTableViewController: UIViewController {
    
    @IBOutlet weak var timeTableView: UITableView!
    
    var uiRefreshControl: UIRefreshControl?
    let userDefaults = UserDefaults.standard
    let elementListManager = ElementListManager()
    var startTime: Date?
    
    var arrayOfTwoHourInterval : [Element] {
        get {
            return elementListManager.createArrayWithTimeIntervals(from: startTime ?? Date(), interval: 112)
        }
    }
    
    var arrayOfHalfOfHourItnerval : [Element] {
        get {
            return elementListManager.createArrayWithTimeIntervals(from: startTime ?? Date(), interval: 31)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigurations()
        setListBasedOnInterval()
        setUiRefreshControll()
        setNavigationBarConfigurations()
    }
    
    func setNavigationBarConfigurations() {
        // setup white color for navBar items
        navigationController?.navigationBar.tintColor = .init(red: 41, green: 174, blue: 119, alpha: 1)
        // set navTitle font style and white color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = TimeChoiseViewController.selectedInterval.rawValue

        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(deleteTimeTable))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 2500

        if offset >= 1 {
            offset = 1
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 41, green: 174, blue: 119, alpha: 1).withAlphaComponent(offset)
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            navigationController?.navigationBar.barTintColor = UIColor.systemGreen.withAlphaComponent(offset)
        }
    }
    
    func setDeleteButtonAlert() {
        let uiAlert = UIAlertController(title: "", message: "Точно видалити?", preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction.init(title: "Видалити", style: .destructive, handler: { _ in
            self.elementListManager.deleteFromLocalStorage()
            self.setListBasedOnInterval()
            self.timeTableView.reloadData()
        }))
        uiAlert.addAction(UIAlertAction.init(title: "Відмінити", style: .default, handler: { _ in
            print("cancel")
        }))
        
        present(uiAlert, animated: true, completion: nil)
    }
    
    func setUiRefreshControll() {
        uiRefreshControl = UIRefreshControl()
        guard let uiRefreshControl = uiRefreshControl else {
            return
        }
        uiRefreshControl.tintColor = .black
        uiRefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        timeTableView.addSubview(uiRefreshControl)
    }
    
    @objc func refreshData() {
        guard let uiRefreshControl = uiRefreshControl else {
            return
        }
        
        setListBasedOnInterval()
        uiRefreshControl.endRefreshing()
        timeTableView.reloadData()
    }
    
    @objc func deleteTimeTable() {
        setDeleteButtonAlert()
    }
    
    func tableViewConfigurations() {
        timeTableView.dataSource = self
        timeTableView.delegate = self
    }
    
    func setListBasedOnInterval() {
        switch TimeChoiseViewController.selectedInterval {
        case .thirtyOneMinute:
            if userDefaults.value(forKey: TimeChoiseViewController.selectedInterval.rawValue) != nil  {
                elementListManager.reedElementFromLocalStorage()
            } else {
                elementListManager.getArray(array: arrayOfHalfOfHourItnerval)
            }
        case .oneHourAndFiftyTwoMinutes:
            if userDefaults.value(forKey: TimeChoiseViewController.selectedInterval.rawValue) != nil  {
                elementListManager.reedElementFromLocalStorage()
            } else {
                elementListManager.getArray(array: arrayOfTwoHourInterval)
            }
        }
    }
    
//    @objc func shareToFriend() {
//        switch TimeChoiseViewController.selectedInterval {
//        case .thirtyOneMinute:
//            let activityVc = UIActivityViewController(activityItems: [arrayOfHalfOfHourItnerval.first?.text], applicationActivities: nil)
//            activityVc.popoverPresentationController?.sourceView = self.view
//            self.present(activityVc, animated: true, completion: nil)
//        case .oneHourAndFiftyTwoMinutes:
//            let activityVc = UIActivityViewController(activityItems: arrayOfTwoHourInterval, applicationActivities: nil)
//            activityVc.popoverPresentationController?.sourceView = self.view
//            self.present(activityVc, animated: true, completion: nil)
//        }
//    }
    
}

extension TimeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementListManager.getAllElements().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
        cell.fill(model: elementListManager.elementBy(index: indexPath.row))
        
        
        
        // complation what return bool status of cell button and revers it. But i dont know is it saved in Elemnt status and UserDefaults
        
        cell.complation = { selected in
            let reversSelected = !selected
            if selected == true {
                self.elementListManager.elementBy(index: indexPath.row).status = reversSelected
                cell.selectButton.isSelected = reversSelected
                print(reversSelected)
            } else if selected == false {
                self.elementListManager.elementBy(index: indexPath.row).status = reversSelected
                cell.selectButton.isSelected = reversSelected
                print(reversSelected)
            }
            self.elementListManager.saveElementToLocalStorage()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editingViewController = (storyboard?.instantiateViewController(withIdentifier: "EditingViewController")) as! EditingViewController
        editingViewController.timeTableViewControllerDelegate = self
        editingViewController.indexPath = indexPath
        editingViewController.currentElement = elementListManager.elementBy(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(editingViewController, animated: true)
    }
}

extension TimeTableViewController: TimeTableViewControllerDelegate {
    
    func didLabelChanged(with text: String, indexPath: IndexPath) {
        elementListManager.elementBy(index: indexPath.row).text = text
        elementListManager.saveElementToLocalStorage()
        timeTableView.reloadData()
    }
}
