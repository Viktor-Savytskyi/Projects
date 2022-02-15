//
//  GameInfoController.swift
//  StoreApp
//
//  Created by 12345 on 22.01.2022.
//

import Foundation

class GameDetailsController {
    private let requestManager = RequestManager()
    
    private var gameDetails: GameDetailResponse?
    
    func fetchGameDetailsModel(id: Int, completion: @escaping()->()) {
        requestManager.requestGameData(id: id) { response in
            self.gameDetails = response
            completion()
        }
    }
    
    func getGameDetailsById() -> GameDetailResponse {
        return gameDetails ?? GameDetailResponse()
    }
}
