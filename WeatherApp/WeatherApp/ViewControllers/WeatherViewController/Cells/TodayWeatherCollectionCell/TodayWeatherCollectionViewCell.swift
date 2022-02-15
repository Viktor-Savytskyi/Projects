//
//  TodayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by 12345 on 13.01.2022.
//

import UIKit

class TodayWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var todayWeatherCollectionView: UICollectionView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var headerForHorizontalCollectionView: UILabel!
    
    var weatherForTwentyFourHours: WeatherResponseForTwentyFourHours?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewConfigurations()
        self.setCornerRadius(by: 10)
    }
    
    func collectionViewConfigurations() {
        todayWeatherCollectionView.register(UINib(nibName: "TodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodayCollectionViewCell")
        todayWeatherCollectionView.dataSource = self
        todayWeatherCollectionView.delegate = self
        cellView.setCornerRadius(by: 10)
    }
    
    func fill(model: WeatherResponseForTwentyFourHours?) {
        weatherForTwentyFourHours = model
        headerForHorizontalCollectionView.text = "WEATHER FOR 24 HOURS"
        todayWeatherCollectionView.reloadData()
    }
}

extension TodayWeatherCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = weatherForTwentyFourHours?.data?.count else { return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todayWeatherCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
        
        if let weatherForTwentyFourHours = weatherForTwentyFourHours, let model = weatherForTwentyFourHours.data?[indexPath.row]  {
            todayWeatherCollectionCell.fill(model: model)
        }
        return todayWeatherCollectionCell
    }
    
}

extension TodayWeatherCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 50, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }
}

