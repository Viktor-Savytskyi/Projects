//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by 12345 on 13.01.2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherTableView: UITableView!
    var weatherSixteenDaysData: WeatherResponseForSixteenDays?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareTableView()
        self.setCornerRadius(by: 10)
    }
    
    func prepareTableView() {
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.setCornerRadius(by: 10)
    }
    
    func fill(model: WeatherResponseForSixteenDays?) {
        weatherSixteenDaysData = model
        self.weatherTableView.reloadData()
    }
}

extension WeatherCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.fill(model: ((weatherSixteenDaysData?.data?[indexPath.row])) ?? WeatherDataForSixteenDays())
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 15))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-30)
            label.text = "10-DAY FORECAST"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .black
            
            headerView.addSubview(label)
            
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 20
        }
    
    
}



