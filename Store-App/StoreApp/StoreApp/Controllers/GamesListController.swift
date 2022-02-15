//
//  GameInfoController.swift
//  StoreApp
//
//  Created by 12345 on 22.01.2022.
//

import Foundation

class GamesListController {
    
    private let requestManager = RequestManager()
    
    private var gameListInfo: [GameListInfoResponse]?
    private var firstHundredGameInfo: [GameListInfoResponse]?
    private var secondHundredGameInfo: [GameListInfoResponse]?
        
    func fechGameListData(completion: @escaping()->()) {
        requestManager.requestGamesListData { response in
            self.gameListInfo = response
            completion()
        }
    }
    
    func getFullGameListModel() -> [GameListInfoResponse] {
        return gameListInfo ?? [GameListInfoResponse]()
    }
    
    func getSecondHunredGamesListModel() -> [GameListInfoResponse] {
        secondHundredGameInfo = Array(self.gameListInfo?[100...199] ?? [])
        return secondHundredGameInfo ?? [GameListInfoResponse]()
    }
    
    func getFirstHunredGamesListModel() -> [GameListInfoResponse] {
        firstHundredGameInfo = Array(self.gameListInfo?[0...99] ?? [])
        return firstHundredGameInfo ?? [GameListInfoResponse]()
    }

}
