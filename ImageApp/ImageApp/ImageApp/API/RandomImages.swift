//
//  RandomImages.swift
//  ImageApp
//
//  Created by 12345 on 17.09.2021.
//

import Foundation

// MARK: - RandomImageList
struct RandomImage: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias RandomImages = [RandomImage]
