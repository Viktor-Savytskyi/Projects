//
//  TabBarBuilder.swift
//  Platform
//
//  Created by 12345 on 08.04.2023.
//

import UIKit

class NavigationBuilder {
    static let shared = NavigationBuilder()
    
    private init() { }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let home = HomeViewController()
        home.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home"))
        
        let createPostVC = CreatePostViewController()
        createPostVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "add"),
            selectedImage: UIImage(named: "add"))
        
        let notificationsVC = NotificationsViewController()
        notificationsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "notifications"),
            selectedImage: UIImage(named: "notifications")
        )
        
        let account = ProfilePageViewController()
        account.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile"))
        
        tabBar.viewControllers = [UINavigationController(rootViewController: home),
                                  UINavigationController(rootViewController: createPostVC),
                                  UINavigationController(rootViewController: notificationsVC),
                                  UINavigationController(rootViewController: account)]
        tabBar.tabBar.tintColor = .black
        tabBar.tabBar.barTintColor = Constants.Colors.tabBarBackgroundColor
        tabBar.tabBar.backgroundColor = Constants.Colors.tabBarBackgroundColor
        return tabBar
    }
    
    
    func navigateUserBy(state: AuthState) {
        let navigationController = UINavigationController()
        
        switch state {
        case .authorized:
            Utils.window?.rootViewController = createTabBar()
            return
        case .unAuthorized:
            let loginViewController = RootLoginViewController()
            navigationController.viewControllers = [loginViewController]
        case .notVerified:
            let accountVC = CreateAccountViewController()
            navigationController.viewControllers = [accountVC]
        }
        Utils.window?.rootViewController = navigationController
    }
}
