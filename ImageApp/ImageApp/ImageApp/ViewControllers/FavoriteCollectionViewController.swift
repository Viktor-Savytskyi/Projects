//
//  FavoriteViewController.swift
//  ImageApp
//
//  Created by 12345 on 29.09.2021.
//

import UIKit

class FavoriteCollectionViewController: UIViewController {
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var informLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var doubleTapGesture : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteCollectionView.reloadData()
        deleteButton.isEnabled = false
    }
    
    @objc func toDeleteItem(){
        if let selectedCells = favoriteCollectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { item in item.item }.sorted().reversed()
            for item in items {
                SavedImages.shared.savedImagesArray.remove(at: item)
                print(item.hashValue)
            }
            deleteButton.isEnabled = false
            favoriteCollectionView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        favoriteCollectionView.allowsMultipleSelection = editing
        let indexPaths = favoriteCollectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = favoriteCollectionView.cellForItem(at: indexPath) as! FavoriteImageCell
            cell.isEditingMode = editing
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        toDeleteItem()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
}

extension FavoriteCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SavedImages.shared.savedImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if SavedImages.shared.savedImagesArray.count == 0 {
            informLabel.isHidden = false
        } else {
            informLabel.isHidden = true
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteImageCell
        cell.favoriteImage!.image = SavedImages.shared.savedImagesArray[indexPath.row]
        cell.isEditingMode = isEditing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let widthConstant = screenWidth / 2
        let heightConstant = widthConstant
        return CGSize(width: widthConstant, height: heightConstant)
    }
    
    
    
}



