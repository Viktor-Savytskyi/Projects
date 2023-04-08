import Foundation

class Notification {
    var notificationInfo: NotificationInfo?
    var user: CHUser?
    var post: Post?
    
    init(notificationType: NotificationInfo?, user: CHUser?, post: Post? = nil) {
        self.notificationInfo = notificationType
        self.user = user
        self.post = post
    }
}
