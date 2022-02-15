//
//  Connectivity.swift
//  ImageApp
//
//  Created by 12345 on 17.09.2021.
//

import Foundation
import Alamofire

class Connectivity {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
