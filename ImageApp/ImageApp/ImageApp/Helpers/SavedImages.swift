//
//  SavedImages.swift
//  ImageApp
//
//  Created by 12345 on 26.10.2021.
//

import Foundation
import UIKit

class SavedImages {
    
    var savedImagesArray = [UIImage]()
    
    static var shared: SavedImages = {
        let instance = SavedImages()
        return instance
    }()
    
    init(){}
    
    
}
