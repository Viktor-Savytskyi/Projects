//
//  GameDetailResponse.swift
//  StoreApp
//
//  Created by 12345 on 24.01.2022.
//

import Foundation

class GameDetailResponse: Codable {
    var id: Int?
    var title: String?
    var thumbnail: String?
    var status: String?
    var shortDescription: String?
    var description: String?
    var gameUrl: String?
    var genre: String?
    var platform: String?
    var publisher: String?
    var developer: String?
    var releaseDate: String? //"2019-05-21"
    var freetogameProfileUrl: String?
    var minimumSystemRequirements: MinimumSystemRequirements?
    var screenshots: [Screenshots]?
    
    private enum CodingKeys : String, CodingKey {
        case id, title, thumbnail, status, genre, description, platform, publisher, developer, screenshots
        case shortDescription = "short_description", gameUrl = "game_url", releaseDate = "release_date", freetogameProfileUrl = "freetogame_profile_url", minimumSystemRequirements = "minimum_system_requirements"
    }
}

class MinimumSystemRequirements: Codable {
    var os: String?
    var processor: String?
    var memory: String?
    var graphics: String?
    var storage: String?
}

class Screenshots: Codable {
    var id: Int?
    var image: String?
}

