//
//  WeatherController.swift
//  WeatherApp
//
//  Created by 12345 on 12.01.2022.
//
import Foundation
import UIKit

protocol WeatherViewModelProtocol: NSObjectProtocol {
    
    func loadData()
    func loadData(with alert: UIAlertController)
}

enum CollectionViewSections {
    
    case twentyFourHoursWeather
    case weatherForTenDays
    case individualIndicators
    
    var sectionTitle: String {
        switch self {
        case .twentyFourHoursWeather:
            return "weather for 24 hours"
        case .weatherForTenDays:
            return "weather for 10 days"
        case .individualIndicators:
            return "individual indicators"
        }
    }
    
    var cellsCount: Int {
        switch self {
        case .twentyFourHoursWeather:
            return 1
        case .weatherForTenDays:
            return 1
        case .individualIndicators:
            return 2
        }
    }
}

class WeatherViewModel {
    
    private var weatherSixteenDaysModel: WeatherResponseForSixteenDays?
    private var weatherForTwentyFourHoursModel: WeatherResponseForTwentyFourHours?
    private var currentWeatherModel: CurrentWeatherResponse?
    
    var sections: [CollectionViewSections] = [.twentyFourHoursWeather, .weatherForTenDays, .individualIndicators]
    
    private let requestManager = RequestManager()
    weak var delegate: WeatherViewModelProtocol?
    
    func loadAllData() {
        fetchWeatherDataForSixteenDays()
        fetchDataForTwentyFourHours()
        fetchCurrentWeather()
    }
    
    func fetchWeatherDataForSixteenDays() {
        requestManager.requestDataForSixteenDays { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                self.weatherSixteenDaysModel = data
                self.delegate?.loadData()
            case .error(let error):
                let alert = self.showAlert(title: "Alert", message: error, buttonTitle: "Try again") { _ in
                    self.loadAllData()
                }
                self.delegate?.loadData(with: alert)

            }
        }
    }
    
    func getModelOfSixteenDays() -> WeatherResponseForSixteenDays {
        return weatherSixteenDaysModel ?? WeatherResponseForSixteenDays()
    }
    // functions for 24 hours of curent day data
    
    func fetchDataForTwentyFourHours() {
        requestManager.requestDataForTwentyFourHours { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                self.weatherForTwentyFourHoursModel = data
                self.delegate?.loadData()
            case .error(let error):
                let alert = self.showAlert(title: "Alert", message: error, buttonTitle: "Try again") { _ in
                    self.loadAllData()
                }
                self.delegate?.loadData(with: alert)
            }
        }
    }
    
    func getDaylyWeather() -> WeatherResponseForTwentyFourHours {
        return weatherForTwentyFourHoursModel ?? WeatherResponseForTwentyFourHours()
    }
    
    // functions for curent time data
    func fetchCurrentWeather() {
        requestManager.requestCurrentWeatherData { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                self.currentWeatherModel = data
                self.delegate?.loadData()
            case .error(let error):
                let alert = self.showAlert(title: "Alert", message: error, buttonTitle: "Try again") { _ in
                    self.loadAllData()
                }
                self.delegate?.loadData(with: alert)
            }
        }
    }
    
    func getCurrentWeatherDataPropherties() -> CurrentWeatherResponse {
        currentWeatherModel ?? CurrentWeatherResponse()
    }
    
}
