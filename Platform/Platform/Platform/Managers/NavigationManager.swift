import UIKit

class NavigationManager {
    static let shared = NavigationManager()
    weak var rootNavigationVC: UINavigationController?
    
    private init() { }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let home = HomeViewController()
        home.tabBarItem = UITabBarItem(
            title: Constants.NavigationManager.tabBarTitleName,
            image: UIImage(named: Constants.NavigationManager.tabBarImageNameHome),
            selectedImage: UIImage(named: Constants.NavigationManager.tabBarImageNameHome))
        
        let createPostVC = CreatePostViewController()
        createPostVC.tabBarItem = UITabBarItem(
            title: Constants.NavigationManager.tabBarTitleName,
            image: UIImage(named: Constants.NavigationManager.tabBarImageNameCreatePost),
            selectedImage: UIImage(named: Constants.NavigationManager.tabBarImageNameCreatePost))
        
        let notificationsVC = NotificationsViewController()
        notificationsVC.tabBarItem = UITabBarItem(
            title: Constants.NavigationManager.tabBarTitleName,
            image: UIImage(named: Constants.NavigationManager.tabBarImageNameNotifications),
            selectedImage: UIImage(named: Constants.NavigationManager.tabBarImageNameNotifications)
        )
        
        let account = ProfilePageViewController()
        account.tabBarItem = UITabBarItem(
            title: Constants.NavigationManager.tabBarTitleName,
            image: UIImage(named: Constants.NavigationManager.tabBarImageNameProfile),
            selectedImage: UIImage(named: Constants.NavigationManager.tabBarImageNameProfile))
        
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
            let accountVC = VerificationViewController()
            navigationController.viewControllers = [accountVC]
        }
        Utils.window?.rootViewController = navigationController
    }
    
    func setRootNavigationViewController(userAuthState: AuthState) {
        switch userAuthState {
        case .authorized:
            let tabBarVC = Utils.window?.rootViewController as? UITabBarController
            rootNavigationVC = tabBarVC?.viewControllers?[tabBarVC?.selectedIndex ?? 0] as? UINavigationController
        case .unAuthorized:
            rootNavigationVC = Utils.window?.rootViewController as? UINavigationController
        case .notVerified:
            break
        }
    }
    
    func openProfilePage(profileId: String) {
        let profileVC = ProfilePageViewController()
        profileVC.userId = profileId
        rootNavigationVC?.pushViewController(profileVC, animated: true)
    }
    
    func openPostDetailsScreen(post: Post) {
        let postDetailsVC = PostDetailsViewController()
        postDetailsVC.post = post
        rootNavigationVC?.pushViewController(postDetailsVC, animated: true)
    }
    
    func openRegistrationPage() {
        rootNavigationVC?.pushViewController(RegisterWithEmailViewController(), animated: true)
    }
    
    func openPostDetails(postId: String, isDeletedMessage: String, invalidLinkMessage: String) {
        let topVC = rootNavigationVC?.topViewController as? BaseViewController
        topVC?.showLoader()
        FirestoreAPI.shared.getPostById(postId: postId) { post, error in
            topVC?.hideLoader()
            if let error = error {
                topVC?.showMessage(message: error.localizedDescription)
            } else if let post {
                if post.isDeleted {
                    topVC?.showMessage(message: isDeletedMessage)
                    return
                }
                self.openPostDetailsScreen(post: post)
            } else {
                topVC?.showMessage(message: invalidLinkMessage)
            }
        }
    }
    
    func openInterestsAsRootViewController() {
        let navigationController = UINavigationController()
        let iterests = InterestsViewController()
        iterests.state = .register
        navigationController.viewControllers = [iterests]
        Utils.window?.rootViewController = navigationController
    }
    
    func returnToHomeScreenAfterPostCreating() {
        //            if let createPostVC = self.rootNavigationVC?.viewControllers.first as? CreatePostViewController {
        //                createPostVC.cleanFields()
        //            }
        //            tabBarController?.selectedIndex = 0
        //            navigationController?.popToRootViewController(animated: true)
        //        }
    }
}
