//
//  NetworkManager.swift
//  ImageApp
//
//  Created by 12345 on 21.09.2021.
//

import Foundation
import Alamofire
import UIKit

enum Result<T>{
    case success(T)
    case error(String)
}

class NetworkManager{
    
    var imageCache  = NSCache<NSString, NSObject>()
    
    static var shared: NetworkManager = {
        let instanse = NetworkManager()
        return instanse
    }()
    
    private init () {}
    
    func getRandomImageList(completion: @escaping(Result<RandomImages>) -> Void) {
        
        let request = AF.request("https://picsum.photos/v2/list?page=1&limit=30")
        request.responseJSON { (json) in
            do {
                let response = try JSONDecoder().decode(RandomImages.self, from: json.data!)
                completion(Result.success(response))
            } catch {
                completion(Result.error(error.localizedDescription))
            }
        }
    }
}
