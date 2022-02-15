//
//  NetworkConnection.swift
//  WeatherApp
//
//  Created by 12345 on 11.01.2022.
//

import Foundation
import Alamofire

class NetworkConnection {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
