//
//  HeaderCollectionReusableView.swift
//  WeatherApp
//
//  Created by 12345 on 15.01.2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func fill(model: CurrentWeatherData, dayWeaherModel: WeatherDataForSixteenDays) {
        if let cityName = model.cityName, let temp = model.temp, let condition = model.weather?.description, let minTemp = dayWeaherModel.minTemp, let maxTemp = dayWeaherModel.maxTemp
{
            locationLabel.text = cityName
            currentTemperatureLabel.text = "\(Int(temp))°"
            weatherCondition.text = condition
            
            highTempLabel.text = "H: \(Int(maxTemp))°"
            lowTempLabel.text = "L: \(Int(minTemp))°"

        }
       
    }
    
}
