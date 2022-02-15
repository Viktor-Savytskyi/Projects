//
//  TodayCollectionViewCell.swift
//  WeatherApp
//
//  Created by 12345 on 13.01.2022.
//

import UIKit
import Kingfisher

class TodayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fill(model: WeatherDataForTwentyFourHours) {
        if let temp = model.temp, let dateString = model.timestampLocal, let image = model.weather?.icon {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "HH"
            let hour = dateFormatter.string(from: date!)
            timeLabel.text = hour

            temperatureLabel.text = "\(Int(temp))°"
            setImage(img: image)
        }
      
    }
    
    func setImage(img: String) {
        let url = URL(string: "https://www.weatherbit.io/static/img/icons/\(img).png")
        weatherImage.kf.setImage(with: url)
    }

}
