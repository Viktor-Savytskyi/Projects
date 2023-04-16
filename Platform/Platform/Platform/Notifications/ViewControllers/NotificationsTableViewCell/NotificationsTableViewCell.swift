import UIKit
import SDWebImage

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var isViewedBadge: UIImageView!
    
    var rightClickButtonCallBack: ((Bool) -> Void)?
    var isLikeNotification = true
    
    func setup(with notification: Notification) {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        if let lastViewedDate = currentUser.lastTimeNotificationsViewed,
           let notificationDate = notification.notificationInfo?.date {
            isViewedBadge.isHidden = lastViewedDate > notificationDate
        }
        setNotificationImage(notification: notification)
        userNameLabel.text = notification.user?.userName.uppercased()
        rightButton.layer.cornerRadius = 18
        rightButton.clipsToBounds = true
        avatarImageView.setBorder(borderWith: 0.5)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        if let avatar = notification.user?.avatarImageUrl {
            avatarImageView.sd_setImage(with: URL(string: avatar))
        } else {
            avatarImageView.image = UIImage(named: "noAvatar")
        }
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yy"
        let notificationDate = formater.string(from: notification.notificationInfo?.date ?? Date())
        let description = notification.post == nil
            ? "Started following you. \(notificationDate)"
            : "Liked your item. \(notificationDate)"
        descriptionLabel.text = description
    }
    
    private func setNotificationImage(notification: Notification) {
        if notification.post == nil {
            isLikeNotification = false
            rightButton.setBorder(borderWith: 0)
            rightButton.sd_setBackgroundImage(with: nil, for: .normal)
            if let currentUserFollowers = AccountManager.shared.currentUser?.followedUserIds?.compactMap({ $0.userId }), currentUserFollowers.contains(notification.notificationInfo?.userId ?? "") {
                rightButton.setImage(UIImage(named: "following"), for: .normal)
            } else {
                rightButton.setImage(UIImage(named: "follow"), for: .normal)
            }
        } else {
            rightButton.setBorder(borderWith: 0.5)
            rightButton.setImage(UIImage(), for: .normal)
            rightButton.sd_setBackgroundImage(with: URL(string: notification.post?.firstImage.imageUrl ?? ""), for: .normal)
            isLikeNotification = true
        }
    }
    
    @IBAction func rightButtonClick(_ sender: Any) {
        rightClickButtonCallBack?(isLikeNotification)
    }
}
