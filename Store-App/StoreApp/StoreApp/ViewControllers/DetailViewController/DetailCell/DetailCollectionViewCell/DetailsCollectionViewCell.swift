//
//  DetailTableCollectionViewCell.swift
//  StoreApp
//
//  Created by 12345 on 24.01.2022.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var graphicsLabel: UILabel!
    @IBOutlet weak var memoryLabel: UILabel!
    @IBOutlet weak var processorLabel: UILabel!
    @IBOutlet weak var osLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(with model: GameDetailResponse) {
        if let title = model.title, let description = model.description, let genre = model.genre, let platform = model.platform, let developer = model.developer, let date = model.releaseDate, let os = model.minimumSystemRequirements?.os, let processor = model.minimumSystemRequirements?.processor, let memory = model.minimumSystemRequirements?.memory, let graphics = model.minimumSystemRequirements?.graphics, let storage = model.minimumSystemRequirements?.storage  {
            titleLabel.text = title
            descriptionTextView.text = description
            genreLabel.text = genre
            developerLabel.text = developer
            platformLabel.text = platform
            releaseDateLabel.text = date
            osLabel.text = "Os: \(os)"
            processorLabel.text =  "Processor: \(processor)"
            memoryLabel.text = "Memory: \(memory)"
            graphicsLabel.text = "Grephycs: \(graphics)"
            storageLabel.text = "Storage: \(storage)"
        }
    }
    
}
