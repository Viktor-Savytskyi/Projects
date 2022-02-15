//
//  ViewController.swift
//  ImageApp
//
//  Created by 12345 on 17.09.2021.
//

import UIKit
import Kingfisher
import Alamofire


class RandomCollectionViewController: UIViewController {
    
    @IBOutlet weak var randomImagesCollectionView: UICollectionView!
    
    private var countElement: Int = 20
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var doubleTapGesture : UITapGestureRecognizer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        randomImagesCollectionView.delegate = self
        randomImagesCollectionView.dataSource = self
        setDoubleTap()
        cache.countLimit = 50
    }
    
    private func loadImges(completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            let url = URL(string: "https://picsum.photos/200")!
            guard let data = try? Data (contentsOf: url) else {return}
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func setDoubleTap(){
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        randomImagesCollectionView.addGestureRecognizer(doubleTapGesture)
        doubleTapGesture.delaysTouchesBegan = true
    }
    
    @objc func didDoubleTap(){
        let pointInCollectionView = doubleTapGesture.location(in: randomImagesCollectionView)
        
        if let selectedIndexPath = randomImagesCollectionView.indexPathForItem(at: pointInCollectionView) {
            guard let selectedCell = randomImagesCollectionView.cellForItem(at: selectedIndexPath) as? RandomImageCell else {return}
            
            if !SavedImages.shared.savedImagesArray.contains((selectedCell.randomImg.image)!) {
                print("image of this cell saved to array: ", selectedIndexPath.row)

                SavedImages.shared.savedImagesArray.append(selectedCell.randomImg.image!)
                
                UIImageView.animate(withDuration: 0.7, animations:  {
                    selectedCell.heartImage.alpha = 0.4
                    selectedCell.heartImage.tintColor = .red
                }, completion: { done in
                    if done {
                        selectedCell.heartImage.alpha = 0
                    }
                })
            }
        }
    }
    
}

extension RandomCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("Tapped")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countElement
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "randomCellId", for: indexPath)
        as! RandomImageCell
        print(indexPath.row)
        if indexPath.row >= countElement - 1 {
            countElement += 20
            collectionView.reloadData()
        }
        //        let url = URL(string: randomImagesArray[indexPath.item].downloadURL)!
        //        print(url)
        //        cell.randomImg.kf.indicatorType = .activity
        //        cell.randomImg.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let widthConstant = UIScreen.main.bounds.width / 2
        let heightConstant = widthConstant
        return CGSize(width: widthConstant, height: heightConstant)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RandomImageCell else {return}
        let itemsNumber = NSNumber(value: indexPath.item)
        
        if let cachedImages = self.cache.object(forKey: itemsNumber) {
            print("Using a cached image for item: \(itemsNumber)")
            cell.randomImg.image = cachedImages
        } else {
            self.loadImges { [weak self] (images) in
                guard let self = self, let images = images else {return}
                cell.randomImg.image = images
                self.cache.setObject(images, forKey: itemsNumber)
            }
        }
    }
    
}
