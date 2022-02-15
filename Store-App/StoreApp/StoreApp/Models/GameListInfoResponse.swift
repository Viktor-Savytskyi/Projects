//
//  GameListModel.swift
//  StoreApp
//
//  Created by 12345 on 22.01.2022.
//

import Foundation


class GameListInfoResponse: Codable {
    var id: Int?
    var title: String?
    var thumbnail: String?
    var shortDescription: String?
    var gameUrl: String?
    var genre: String?
    var platform: String?
    var publisher: String?
    var developer: String?
    var releaseDate: String? //"2019-05-21"
    var freetogameProfileUrl: String?
    
    private enum CodingKeys : String, CodingKey {
        case id, title, thumbnail, genre, platform, publisher, developer
        case shortDescription = "short_description", gameUrl = "game_url", releaseDate = "release_date", freetogameProfileUrl = "freetogame_profile_url"
    }
}


