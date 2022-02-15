//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by 12345 on 11.01.2022.
//

import Foundation
import Alamofire
import SwiftUI

enum RequestResult<T> {
    case success(T)
    case error(String)
}

class RequestManager {
    
    let headers: HTTPHeaders = [
        "x-rapidapi-host": "weatherbit-v1-mashape.p.rapidapi.com",
        "x-rapidapi-key": "642a5c3753msh5b82d7feddbada6p14449djsn48489766241e"
    ]
    
    let urlForSixteenDays = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=49.4285&lon=32.0621"
    let urlForTwentyFourHours = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=49.4285&lon=32.0621&hours=24"
    let urlCurrentWeatherData = "https://weatherbit-v1-mashape.p.rapidapi.com/current?lon=32.0621&lat=49.4285"

    // request data for 16 days
    func requestDataForSixteenDays(completion: @escaping (RequestResult<WeatherResponseForSixteenDays>)->()) {
        AF.request(urlForSixteenDays, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseDecodable(of: WeatherResponseForSixteenDays.self) { response in
            if let weather = response.value {
                completion(RequestResult.success(weather))
            } else {
                guard let error = response.error else { return }
                completion(RequestResult.error(error.localizedDescription))
            }
        }
    }
    
    // request data for 24 hours
    func requestDataForTwentyFourHours(completion: @escaping (RequestResult<WeatherResponseForTwentyFourHours>)->()) {
      
        AF.request(urlForTwentyFourHours, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseDecodable(of: WeatherResponseForTwentyFourHours.self) { response in
            if let response = response.value {
                completion(RequestResult.success(response))
            } else {
                guard let error = response.error else { return }
                completion(RequestResult.error(error.localizedDescription))
            }
        }
    }
    
    //request data for current moment
    func requestCurrentWeatherData(completion: @escaping (RequestResult<CurrentWeatherResponse>)->()) {
        AF.request(urlCurrentWeatherData, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseDecodable(of: CurrentWeatherResponse.self) { response in
            if let response = response.value {
                completion(RequestResult.success(response))
            } else {
                guard let error = response.error else { return }
                completion(RequestResult.error(error.localizedDescription))
            }
        }
    }
}
