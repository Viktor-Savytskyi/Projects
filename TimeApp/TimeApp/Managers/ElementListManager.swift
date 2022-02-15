//
//  ElementListManager.swift
//  TimeApp
//
//  Created by 12345 on 01.12.2021.
//

import Foundation

class ElementListManager {
    
    private var listOfElements: [Element] = []
    
    func getAllElements() -> [Element]{
        return listOfElements
    }
    
    func elementBy(index: Int) -> Element {
        return listOfElements[index]
    }
    
    func getArray(array: [Element]) {
         listOfElements = array
    }
    
    func saveElementToLocalStorage() {
        var elementParsedDicts: [[String : Any]] = []
        
        listOfElements.forEach { element in
            elementParsedDicts.append(element.toDict())
        }
        UserDefaults.standard.set(elementParsedDicts, forKey: "\(TimeChoiseViewController.selectedInterval.rawValue)")
    }
    
    func reedElementFromLocalStorage() {
        guard let elementsParsedDicts = UserDefaults.standard.value(forKey: "\(TimeChoiseViewController.selectedInterval.rawValue)") as? [[String : Any]] else {return}
        var elements: [Element] = []
        elementsParsedDicts.forEach { dict in
                elements.append(Element.read(from: dict))
            }
        self.listOfElements = elements
    }
    
    func deleteFromLocalStorage() {
        UserDefaults.standard.removeObject(forKey: "\(TimeChoiseViewController.selectedInterval.rawValue)")
    }
    
    func createArrayWithTimeIntervals(from startTime: Date, interval: Int) -> [Element] {
        let calendar = Calendar.current
        var startTime = startTime
        let endTime = Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: Date())!
        var arrayOfTimes: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        while startTime < endTime {
            arrayOfTimes.append(startTime)
            startTime = calendar.date(byAdding: .minute, value: interval, to: startTime)!
            print(startTime)
        }
        return arrayOfTimes.compactMap { time in Element(time: "\(dateFormatter.string(from: time))", text: "")
        }
    }
}
