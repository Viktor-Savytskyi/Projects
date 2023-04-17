import Foundation
import UIKit

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private var posts: [Post]?
    private var likeNotifications: [Notification] = []
    private var followingNotifications: [Notification] = []
    weak var notificationDelegate: NotificationManagerDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var screenAlertDelegate: ScreenAlertDelegate?

	var allNotifications: [Notification] {
		let result = followingNotifications + likeNotifications
		return result.sorted { $0.notificationInfo?.date ?? Date() > $1.notificationInfo?.date ?? Date() }
	}
	
	private var notificationTabItem: UITabBarItem? {
		if let tabBarVC = Utils.window?.rootViewController as? UITabBarController {
			let notificationVCTabIndex = tabBarVC.viewControllers?.firstIndex(where: { $0.children.first is NotificationsViewController })
			return tabBarVC.tabBar.items?[notificationVCTabIndex ?? 0]
		}
		return nil
	}
    
    private init() { }
    
    func getNotificationsData(showLoading: Bool = false) {
//        showLoading ? delegate?.viewController.showLoader() : nil
        showLoading ? screenLoaderDelegate?.showScreenLoader() : nil
        notificationDelegate?.changeNotificationLabelVisible()
		clearNotifications()
//		delegate?.viewController.notificationsTableView.reloadData()
        notificationDelegate?.reloadData()
        getCurrentUser()
    }
	
	func hideTabItemBadge() {
		notificationTabItem?.badgeValue = nil
	}
    
    private func getCurrentUser() {
		guard let userId = AccountManager.shared.userId else { return }
        FirestoreAPI.shared.getUserData(userId: userId) { [weak self] _, error in
            guard let self else { return }
            if let error {
//                self.delegate?.viewController.hideLoader()
                self.screenLoaderDelegate?.hideScreenLoader()
//                self.delegate?.viewController.showMessage(message: error.localizedDescription)
                self.screenAlertDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                self.getUserPosts()
            }
        }
    }
    
    private func getUserPosts() {
        guard let userId = AccountManager.shared.currentUser?.id else { return }
        FirestoreAPI.shared.getPosts(usersIds: [userId]) { [weak self] posts, error in
            guard let self else { return }
            if let error {
//                self.delegate?.viewController.hideLoader()
                self.screenLoaderDelegate?.hideScreenLoader()
//                self.delegate?.viewController.showMessage(message: error.localizedDescription)
                self.screenAlertDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                self.posts = posts
                UsersStorage.shared
                    .featchUsers(screenAlertDelegate: self.screenAlertDelegate,
                                 completion: {
//                        self.delegate?.viewController.hideLoader()
                        self.screenLoaderDelegate?.hideScreenLoader()
                        self.notificationDelegate?.changeNotificationLabelVisible()
                        self.fetchAllNotifications(posts: self.posts, users: UsersStorage.shared.users)
                    })
            }
        }
    }
    
    private func fetchAllNotifications(posts: [Post]?, users: [CHUser]?) {
		clearNotifications()
        posts?.forEach({ post in
            if post.userId == AccountManager.shared.userId {
                post.likes.forEach { like in
                    let userWhoLiked = users?.first(where: { like.userId == $0.id })
                    if userWhoLiked?.id != AccountManager.shared.userId {
                        likeNotifications.append(Notification(notificationType: like, user: userWhoLiked, post: post))
                    }
                }
            }
        })
        users?.forEach({ user in
            AccountManager.shared.currentUser?.followersIds?.forEach({
                if $0.userId == user.id {
                    followingNotifications.append(Notification(notificationType: $0, user: user))
                }
            })
        })
        checkNewNotifications()
    }
    
    private func checkNewNotifications() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        var hasNewNotification = false
        allNotifications.forEach {
            guard let lastTimeNotificationsViewed = currentUser.lastTimeNotificationsViewed,
                  let notificationDate = $0.notificationInfo?.date else { return }
            if lastTimeNotificationsViewed < notificationDate {
				hasNewNotification = true
            }
        }
		
		if let notificationDelegate {
//			delegate.viewController.notificationsTableView.reloadData()
            notificationDelegate.reloadData()
//            delegate.viewController.noNotificationsLabel.isHidden = !allNotifications.isEmpty
            notificationDelegate.changeNotificationLabelVisible(isHidden: !allNotifications.isEmpty)
            
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.setLastViewedNotificationsDateForCurrentUser()
			}
		} else {
            if hasNewNotification {
                showTabItemBadge()
            } else {
                hideTabItemBadge()
            }
		}
    }
    
    private func showTabItemBadge() {
        notificationTabItem?.badgeValue = Constants.NotificationManager.badgeValue
		notificationTabItem?.badgeColor = .clear
		notificationTabItem?.setBadgeTextAttributes([.foregroundColor: Constants.Colors.green], for: .normal)
	}
	
	private func clearNotifications() {
        likeNotifications = []
        followingNotifications = []
    }
    
	private func setLastViewedNotificationsDateForCurrentUser() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        currentUser.lastTimeNotificationsViewed = Date()
        FirestoreAPI.shared.saveUserData(user: currentUser, completion: nil)
    }
}
