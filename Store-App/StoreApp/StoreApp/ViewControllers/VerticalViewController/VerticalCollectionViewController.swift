//
//  TableViewController.swift
//  StoreApp
//
//  Created by 12345 on 20.01.2022.
//

import UIKit


class VerticalCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gameInfoController = GamesListController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
    }
    
    func prepareCollectionView() {
        collectionView.register(UINib(nibName: "VertiaclCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VertiaclCollectionViewCell")
        collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        collectionView.register(UINib(nibName: "SectionHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
        collectionView.delegate = self
        collectionView.dataSource = self
        configureLayout()
        fetchGameData()
        navigationControllerConfigurations()
    }
    
    func navigationControllerConfigurations() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func fetchGameData() {
        gameInfoController.fechGameListData {
            self.collectionView.reloadData()
        }
    }
}

extension VerticalCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameInfoController.getFullGameListModel().count > 0 {
            return 100
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            if  gameInfoController.getFirstHunredGamesListModel().count > 0 {
                let firstdHundred = gameInfoController.getFirstHunredGamesListModel()
                cell.fill(with: firstdHundred[indexPath.row])
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VertiaclCollectionViewCell", for: indexPath) as! VertiaclCollectionViewCell
            if  gameInfoController.getSecondHunredGamesListModel().count > 0 {
                let secondHundred = gameInfoController.getSecondHunredGamesListModel()
                cell.fill(with: secondHundred[indexPath.row])
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        if indexPath.section == 0 {
            detailViewController?.gameId = gameInfoController.getFirstHunredGamesListModel()[indexPath.row].id
        } else {
            detailViewController?.gameId = gameInfoController.getSecondHunredGamesListModel()[indexPath.row].id
        }
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
}

extension VerticalCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as! SectionHeaderCollectionReusableView
        return header
    }
}

extension VerticalCollectionViewController {
    func configureLayout() {
        collectionView.collectionViewLayout = VerticalViewControllerCustomLayout().createVericalViewControllerCustonLayout()
    }
}
