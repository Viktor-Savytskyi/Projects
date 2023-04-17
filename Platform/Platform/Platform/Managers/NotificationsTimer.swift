import Foundation

class NotificationsTimer {
    
    static let shared = NotificationsTimer()
    private var timer: Timer?
    
    func startFetchingNotifications() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: Constants.NotificationTimer.timeInterval, target: self, selector: #selector(getNotificationsData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func stopFetchingNotifications() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func getNotificationsData() {
        NotificationManager.shared.getNotificationsData()
    }
}
