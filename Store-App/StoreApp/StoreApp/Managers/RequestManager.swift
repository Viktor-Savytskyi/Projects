//
//  RequestManager.swift
//  StoreApp
//
//  Created by 12345 on 22.01.2022.
//

import Foundation
import Alamofire

class RequestManager {
    
    func requestGamesListData(completion: @escaping ([GameListInfoResponse])->()) {
        let headers: HTTPHeaders = ["x-rapidapi-host": "free-to-play-games-database.p.rapidapi.com",
                                    "x-rapidapi-key": "642a5c3753msh5b82d7feddbada6p14449djsn48489766241e"]
        
        
        let url = "https://free-to-play-games-database.p.rapidapi.com/api/games"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers ).responseDecodable(of: [GameListInfoResponse].self) { response in
            if let info = response.value {
                completion(info)
                print(info)
            }
        }
    }
    
    func requestGameData(id: Int, completion: @escaping (GameDetailResponse)->()) {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "free-to-play-games-database.p.rapidapi.com",
            "x-rapidapi-key": "642a5c3753msh5b82d7feddbada6p14449djsn48489766241e"
        ]
        
        
        let url = "https://free-to-play-games-database.p.rapidapi.com/api/game?id=\(id)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers ).responseDecodable(of: GameDetailResponse.self) { response in
            if let details = response.value {
                completion(details)
                print(details)
            }
        }
    }
   
   
    
}
