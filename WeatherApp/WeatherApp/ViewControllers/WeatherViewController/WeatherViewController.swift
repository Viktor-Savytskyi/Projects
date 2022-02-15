//
//  ViewController.swift
//  WeatherApp
//
//  Created by 12345 on 29.12.2021.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let weatherViewModel: WeatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWeatherViewModel()
        fetchWeather()
        prepareCollectionView()
    }
    
    func prepareWeatherViewModel() {
        weatherViewModel.delegate = self
    }
    
    func fetchWeather() {
        weatherViewModel.fetchWeatherDataForSixteenDays()
        weatherViewModel.fetchDataForTwentyFourHours()
        weatherViewModel.fetchCurrentWeather()
    }
    
    func setBackgroundImage() {
        if let weather = weatherViewModel.getCurrentWeatherDataPropherties().data?[0].weather?.code {
            print(weather)
            if weather >= 200 && weather < 600  {
                self.backgroundImage.loadGif(name: "rain")
            } else if weather >= 600 && weather <= 751 {
                self.backgroundImage.loadGif(name: "snow")
            } else if weather >= 800 && weather <= 801 {
                self.backgroundImage.loadGif(name: "sunshineGif")
            } else if weather >= 802 && weather <= 900 {
                self.backgroundImage.loadGif(name: "cloudsGif")
            } else {
                self.backgroundImage.image = nil
            }
        }
    }
    
    func prepareCollectionView() {
        weatherCollectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        weatherCollectionView.register(UINib(nibName: "TodayWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodayWeatherCollectionViewCell")
        weatherCollectionView.register(UINib(nibName: "SingeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SingeCollectionViewCell")
        weatherCollectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "HeaderCollectionReusableView")
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
    }
}

extension WeatherViewController: WeatherViewModelProtocol {
    
    func loadData() {
        self.activityIndicator.startAnimating()
        weatherCollectionView.reloadData()
        self.activityIndicator.stopAnimating()
        setBackgroundImage()
    }
    
    func loadData(with alert: UIAlertController) {
        present(alert, animated: true) {
            self.weatherCollectionView.reloadData()
        }
    }
    
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModel.sections[section].cellsCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        weatherViewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch weatherViewModel.sections[indexPath.section] {
        case .twentyFourHoursWeather:
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayWeatherCollectionViewCell", for: indexPath) as! TodayWeatherCollectionViewCell
            collectionViewCell.fill(model: weatherViewModel.getDaylyWeather())
            return collectionViewCell
        case .weatherForTenDays:
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
            collectionViewCell.fill(model: weatherViewModel.getModelOfSixteenDays())
            return collectionViewCell
        case .individualIndicators:
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingeCollectionViewCell", for: indexPath) as! SingeCollectionViewCell
            if let currentData = weatherViewModel.getCurrentWeatherDataPropherties().data?[0] {
                if indexPath.row == 0 {
                    collectionViewCell.fillOnZeroIndex(by: currentData)
                } else {
                    collectionViewCell.fillOnFirstIndex(by: currentData)
                }
            }
            return collectionViewCell
        }
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countNumberOfRowsInThirdSection = 2
        let spaceBetweenCells = 5
        
        switch weatherViewModel.sections[indexPath.section] {
        case .twentyFourHoursWeather:
            return CGSize.init(width: weatherCollectionView.frame.width, height: 130)
        case .weatherForTenDays:
            return CGSize.init(width: weatherCollectionView.frame.width, height: 470)
        case .individualIndicators:
            let frameCollectionView = weatherCollectionView.frame
            let widthCell = frameCollectionView.size.width / CGFloat(countNumberOfRowsInThirdSection)
            let heightCell = widthCell
            let spacingForRow = CGFloat(countNumberOfRowsInThirdSection + 1) * CGFloat(spaceBetweenCells) / CGFloat(countNumberOfRowsInThirdSection)
            let verticalSpacingForCell: CGFloat = CGFloat(spaceBetweenCells * 2)
            return CGSize.init(width: widthCell - spacingForRow, height: heightCell - verticalSpacingForCell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch weatherViewModel.sections[section] {
        case .twentyFourHoursWeather:
            return CGSize(width: weatherCollectionView.frame.size.width, height: 200)
        case .weatherForTenDays:
            return CGSize(width: weatherCollectionView.frame.size.width, height: 0)
        case .individualIndicators:
            return CGSize(width: weatherCollectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        if let currentData = weatherViewModel.getCurrentWeatherDataPropherties().data?[indexPath.row], let sixteenDaysData = weatherViewModel.getModelOfSixteenDays().data?[indexPath.row] {
            header.fill(model: currentData, dayWeaherModel: sixteenDaysData)
        }
        return header
    }
    
}
