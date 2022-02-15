//
//  SortedViewController.swift
//  ToDo List
//
//  Created by 12345 on 23.12.2021.
//

import UIKit

enum SortingType: String {
    case sortByTitleFromAToZ
    case sortByTitleFromZToA
    case sortByCreateDateFromNewestToOldest
    case sortByCreateDateFromOldestToNewest
    case sortByComplatingTasks
    case sortByNotComplatingTasks
    case sortByTaskExecutionDate
}

class SortedViewController: BaseViewController {

    @IBOutlet weak var nameFromAToZButton: UIButton!
    @IBOutlet weak var nameFromZToAButton: UIButton!
    @IBOutlet weak var createDateFromNewestToOldestButton: UIButton!
    @IBOutlet weak var createDateFromOldestToNewestButton: UIButton!
    @IBOutlet weak var complatingTasksButton: UIButton!
    @IBOutlet weak var notComplatingTasksButton: UIButton!
    @IBOutlet weak var taskExecutionDateButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var toSortButton: UIButton!
    
    let radioController: RadioButtonController = RadioButtonController()
    var completion: ((SortingType)->())?
    var sortType: SortingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radioButtonsConfigurations()
        uiElementsConfigurations()
    }
    
    @IBAction func howToSortAction(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        if sender == nameFromAToZButton {
            sortType = .sortByTitleFromAToZ
            radioController.buttonArrayUpdated(buttonSelected: sender)
        } else if sender == nameFromZToAButton {
            sortType = .sortByTitleFromZToA
            radioController.buttonArrayUpdated(buttonSelected: sender)
        } else if sender == createDateFromNewestToOldestButton {
            sortType = .sortByCreateDateFromNewestToOldest
            radioController.buttonArrayUpdated(buttonSelected: sender)
        } else if sender == createDateFromOldestToNewestButton {
            sortType = .sortByCreateDateFromOldestToNewest
            radioController.buttonArrayUpdated(buttonSelected: sender)
        }
        else if sender == complatingTasksButton {
            sortType = .sortByComplatingTasks
            radioController.buttonArrayUpdated(buttonSelected: sender)
        } else if sender == notComplatingTasksButton {
            sortType = .sortByNotComplatingTasks
            radioController.buttonArrayUpdated(buttonSelected: sender)
        }
        else if sender == taskExecutionDateButton {
            sortType = .sortByTaskExecutionDate
            radioController.buttonArrayUpdated(buttonSelected: sender)
        }
    }
    
    func radioButtonsConfigurations() {
        radioController.buttonsArray = [nameFromAToZButton, nameFromZToAButton, createDateFromNewestToOldestButton, createDateFromOldestToNewestButton, complatingTasksButton, notComplatingTasksButton, taskExecutionDateButton]
        
        if sortType == nil {
            radioController.defaultButton = createDateFromNewestToOldestButton
        } else if sortType == .sortByTitleFromAToZ {
            radioController.defaultButton = nameFromAToZButton
        } else if sortType == .sortByTitleFromZToA {
            radioController.defaultButton = nameFromZToAButton
        } else if sortType == .sortByCreateDateFromNewestToOldest {
            radioController.defaultButton = createDateFromNewestToOldestButton
        } else if sortType == .sortByCreateDateFromOldestToNewest {
            radioController.defaultButton = createDateFromOldestToNewestButton
        } else if sortType == .sortByComplatingTasks {
            radioController.defaultButton = complatingTasksButton
        } else if sortType == .sortByNotComplatingTasks {
            radioController.defaultButton = notComplatingTasksButton
        } else if sortType == .sortByTaskExecutionDate {
            radioController.defaultButton = taskExecutionDateButton
        }
        
        nameFromAToZButton.centerTextAndImage(spacing: 7)
        nameFromZToAButton.centerTextAndImage(spacing: 7)
        createDateFromNewestToOldestButton.centerTextAndImage(spacing: 7)
        createDateFromOldestToNewestButton.centerTextAndImage(spacing: 7)
        complatingTasksButton.centerTextAndImage(spacing: 7)
        notComplatingTasksButton.centerTextAndImage(spacing: 7)
        taskExecutionDateButton.centerTextAndImage(spacing: 7)
     }
   
    func uiElementsConfigurations() {
        buttonsStackView.setCornerRadius(radius: 12)
        toSortButton.setCornerRadius(radius: 12)
    }
    
    @IBAction func toSort(_ sender: Any) {
        completion?(sortType!)
        self.dismiss(animated: true, completion: nil)
    }
}


