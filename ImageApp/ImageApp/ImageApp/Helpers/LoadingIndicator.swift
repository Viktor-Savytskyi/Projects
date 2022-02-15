//
//  LoadingIndicator.swift
//  ImageApp
//
//  Created by 12345 on 17.09.2021.
//

import UIKit

class LoadingIndicator {
    
    static var shared : LoadingIndicator = {
        let instanse = LoadingIndicator()
        return instanse
    }()
    
    private init(){}
    
    var indicator = UIActivityIndicatorView(style: .large)
    
    func showLoadingIndicator() {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func hideLoadingIndicator(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}
