//
//  WeatherrepsonseForTwentyFourHours.swift
//  WeatherApp
//
//  Created by 12345 on 17.01.2022.
//

import Foundation

class WeatherResponseForTwentyFourHours: Codable {
    var data: [WeatherDataForTwentyFourHours]?
    var cityName: String?
    var lon: Float?
    var timezone: String?
    var lat: Float?
    var countryCode: String?
    var stateCode: String?
    
    private enum CodingKeys : String, CodingKey {
        case data, lon, timezone, lat
        case cityName = "city_name", countryCode = "country_code", stateCode = "state_code"
       }
}

class WeatherDataForTwentyFourHours: Codable {
    var windCdir: String?
    var rh: Int?
    var pres: Float?
    var ozone :Float?
    var weather: WeaterValue?
    var windSpd: Float?
    var pop: Int?
    var windCdirFull: String?
    var slp: Float?
    var temp: Float?
    var timestampLocal: String?
    
    private enum CodingKeys : String, CodingKey {
        case rh, pres, ozone, weather, pop, slp, temp
        case windCdir = "wind_cdir", windSpd = "wind_spd", windCdirFull = "wind_cdir_full", timestampLocal = "timestamp_local"
       }
}


