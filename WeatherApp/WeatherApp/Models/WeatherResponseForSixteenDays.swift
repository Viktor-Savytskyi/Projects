//
//  Weather.swift
//  WeatherApp
//
//  Created by 12345 on 11.01.2022.
//

import Foundation


class WeatherResponseForSixteenDays: Codable {
    var data: [WeatherDataForSixteenDays]?
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

    class WeatherDataForSixteenDays: Codable {
    var moonreseTs: Int?
    var windCdir: String?
    var rh: Int?
    var pres: Float?
    var highTemp: Float?
    var sunsetTs: Int?
    var ozone :Float?
    var weather: WeaterValue?
    var appMinTemp: Float?
    var windSpd: Float?
    var pop: Int?
    var windCdirFull: String?
    var slp: Float?
    var moonPhaseLunation: Float?
    var validDate: String?
    var appMaxTemp: Float?
    var lowTemp: Float?
    var maxTemp: Float?
    var temp: Float?
    var minTemp: Float?
    
    private enum CodingKeys : String, CodingKey {
        case rh, pres, ozone, weather, pop, slp, temp
        case moonreseTs = "moonrese_ts", windCdir = "wind_cdir", highTemp = "high_temp", sunsetTs = "sunset_ts", appMinTemp = "app_min_temp", windSpd = "wind_spd", windCdirFull = "wind_cdir_full", moonPhaseLunation = "moon_phase_lunation", appMaxTemp = "app_max_temp", validDate = "valid_date", lowTemp = "low_temp", maxTemp = "max_temp", minTemp = "min_temp"
       }
}

class WeaterValue: Codable {
    var icon: String?
    var code: Int?
    var description: String?
}


