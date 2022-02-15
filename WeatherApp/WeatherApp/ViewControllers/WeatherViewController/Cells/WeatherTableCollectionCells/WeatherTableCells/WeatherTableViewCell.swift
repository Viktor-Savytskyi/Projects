//
//  weatherTableViewCell.swift
//  WeatherApp
//
//  Created by 12345 on 11.01.2022.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fill(model: WeatherDataForSixteenDays) {
        
        if let dateString = model.validDate, let minTemp = model.minTemp, let maxTemp = model.maxTemp, let image = model.weather?.icon, let midleTemp = model.temp {
            
            let dateFormatter = DateFormatter()
            // тут получаем не такой формат как ми описати
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "E"
            let stringDate = dateFormatter.string(from: date!)
            dateLbl.text = stringDate.capitalized

            minTempLbl.text = "\(Int(minTemp))°"
            maxTempLbl.text = "\(Int(maxTemp))°"
            
            setIcon(img: image)
            temperatureSlider.minimumValue = minTemp
            temperatureSlider.maximumValue = maxTemp
            temperatureSlider.value = midleTemp
            temperatureSlider.isEnabled = false
            temperatureSlider.minimumTrackTintColor = .systemBlue
            temperatureSlider.maximumTrackTintColor = .red
            
        }
        
    }
    
    func setIcon(img: String) {
        let url = URL(string: "https://www.weatherbit.io/static/img/icons/\(img).png")
        weatherImage.kf.setImage(with: url)
    }
    
    
}
