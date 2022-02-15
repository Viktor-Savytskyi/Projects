//
//  ViewController.swift
//  TimeApp
//
//  Created by 12345 on 30.07.2021.
//

import UIKit
import DropDown


enum TimeIntervals: String, CaseIterable {
    case thirtyOneMinute = "31 хв."
    case oneHourAndFiftyTwoMinutes = "1 год. 52 хв."
}


class TimeChoiseViewController: UIViewController {
    
    @IBOutlet weak var choiseTimeLbl: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var backgroundViewOfDatePicker: UIView!
    
    static var selectedInterval: TimeIntervals = .thirtyOneMinute
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownMenuConfiguration()
        //        calculateButton.isEnabled = false
        screenUiConfigurations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarConfigurations()
    }
    
    @IBAction func showTimeIntervals(_ sender: UIButton) {
        dropDown.show()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    }
    
    @IBAction func moveToTableOfTimes(_ sender: Any) {
        let timeTableViewController = (storyboard?.instantiateViewController(identifier: "TimeTableViewController"))! as TimeTableViewController
//        guard let interval = dropDown.selectedItem else { return }
        
        if dropDown.selectedItem == nil {
            TimeChoiseViewController.selectedInterval = .thirtyOneMinute
        } else {
            if dropDown.selectedItem == TimeIntervals.oneHourAndFiftyTwoMinutes.rawValue {
                TimeChoiseViewController.selectedInterval = .oneHourAndFiftyTwoMinutes
            } else {
                TimeChoiseViewController.selectedInterval = .thirtyOneMinute
            }
        }
        timeTableViewController.startTime = timeDatePicker.date
        navigationController?.pushViewController(timeTableViewController, animated: true)
    }
    
    func dropDownMenuConfiguration() {
        dropDown.selectedTextColor = .white
        dropDown.selectionBackgroundColor = .gray
        dropDown.cornerRadius = 15
        dropDown.dataSource = TimeIntervals.allCases.map({ interval  in
            interval.rawValue
        })
        dropDownButton.setTitle(TimeChoiseViewController.selectedInterval.rawValue, for: .normal)
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.dropDownButton.setTitle(item, for: .normal)
        }
    }
    
    func screenUiConfigurations() {
        choiseTimeLbl.setCornerRadius(radius: choiseTimeLbl.frame.height / 3)
        dropDownButton.setCornerRadius(radius: dropDownButton.frame.height /  3)
        choiseTimeLbl.setCornerRadius(radius: choiseTimeLbl.frame.height /  3)
        calculateButton.setCornerRadius(radius: calculateButton.frame.height /  3)
        startTimeLabel.setCornerRadius(radius: startTimeLabel.frame.height / 3)
        backgroundViewOfDatePicker.setCornerRadius(radius: startTimeLabel.frame.height / 3)
        dropDownButton.centerTextAndImage(spacing: 7)
    }
    
    
    
    func setNavigationBarConfigurations() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Georgia", size: 25)]
    }
    
}

