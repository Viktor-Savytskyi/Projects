//
//  CurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by 12345 on 15.01.2022.
//

import Foundation

class CurrentWeatherResponse: Codable {
    var data: [CurrentWeatherData]?
    var count: Int?
}
class CurrentWeatherData: Codable {
    var weather: WeaterValues?
    var temp: Float?
    var cityName: String?
    var uv: Float?
    var sunrise: String?
    var sunset: String?
    
    private enum CodingKeys : String, CodingKey {
        case weather, temp, uv, sunrise, sunset
        case cityName = "city_name"
    }
}

class WeaterValues: Codable {
    var icon: String?
    var code: Int?
    var description: String?
}


