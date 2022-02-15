//
//  Element.swift
//  TimeApp
//
//  Created by 12345 on 13.11.2021.
//

import Foundation
import UIKit

class Element {
    
    var time: String
    var text: String?
    var status: Bool
    
    init(time: String, text: String?, status: Bool = false) {
        self.time = time
        self.text = text ?? ""
        self.status = status
    }
    
    func toDict() -> [String : Any] {
        ["time": time, "text": text, "status": status]
    }
    
    static func read(from dict: [String : Any]) -> Element {
        Element.init(time: dict["time"] as! String, text: dict["text"] as! String, status: dict["status"] as? Bool ?? false)
    }
    
}
