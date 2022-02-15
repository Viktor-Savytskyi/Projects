//
//  SingleCollectionViewCell.swift
//  WeatherApp
//
//  Created by 12345 on 17.01.2022.
//

import UIKit

class SingeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headNameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var numbersLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius(by: 10)
    }
    
    func fillOnZeroIndex(by model: CurrentWeatherData) {
        if let uvIndex = model.uv {
            headNameLabel.text = "UV INDEX"
            numbersLabel.text = "\(Int(uvIndex))"
            if uvIndex > 0 && uvIndex <= 2 {
                textLabel.text = "Low"
            } else if uvIndex > 2 && uvIndex <= 5 {
                textLabel.text = "Medium"
            } else if uvIndex > 5 && uvIndex <= 7 {
                textLabel.text = "High"
            } else if uvIndex > 8 && uvIndex <= 10 {
                textLabel.text = "Very high"
            }   else if uvIndex > 11 {
                textLabel.text = "Extreme"
            }
            descriptionLabel.text = "Some text"
        }
    }
    
    func fillOnFirstIndex(by model: CurrentWeatherData) {
        if let sunrise = model.sunrise, let sunset = model.sunset {
            headNameLabel.text = "SUNRISE"
            textLabel.isHidden = true
            numbersLabel.text = sunrise
            descriptionLabel.text = "Sunset: \(sunset)"
        }
    }
}

