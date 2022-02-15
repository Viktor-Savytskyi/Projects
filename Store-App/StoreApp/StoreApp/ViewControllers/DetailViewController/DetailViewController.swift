//
//  DetailViewController.swift
//  StoreApp
//
//  Created by 12345 on 22.01.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    var gameId: Int?
    var gameDetailsController = GameDetailsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        navigationControllerConfigurations()
        fetchGameData()
    }
    
    func navigationControllerConfigurations() {
        navigationController?.navigationBar.isHidden = false
    }
    
    func prepareCollectionView() {
        detailCollectionView.register(UINib(nibName: "DetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailsCollectionViewCell")
        detailCollectionView.register(UINib(nibName: "DetailBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailBannerCollectionViewCell")
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        configureLayout()
    }
    
    func fetchGameData() {
        if let gameId = gameId {
            gameDetailsController.fetchGameDetailsModel(id: gameId, completion: {
                self.detailCollectionView.reloadData()
            })
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let screenShots = gameDetailsController.getGameDetailsById().screenshots {
            switch section {
            case 0:
                return screenShots.count
            default:
                return 1
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailBannerCollectionViewCell", for: indexPath) as! DetailBannerCollectionViewCell
            if let screenShots = gameDetailsController.getGameDetailsById().screenshots {
                cell.fill(model: screenShots[indexPath.row])}
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
                cell.fill(with: gameDetailsController.getGameDetailsById())
            return cell
        }
    }

}

extension DetailViewController {
    func configureLayout() {
        detailCollectionView.collectionViewLayout = DetailsBannerCustomLayout().createDetailsViewControllerCustomLayout()
    }
    
}
