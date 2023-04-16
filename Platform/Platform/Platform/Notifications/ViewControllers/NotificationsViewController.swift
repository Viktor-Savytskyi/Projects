import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var noNotificationsLabel: UILabel!

    private let refreshControl = UIRefreshControl()
	private var notificationManager = NotificationManager.shared
    private var userFollowingManager = UserFollowingManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		noNotificationsLabel.isHidden = true
		notificationManager.notificationDelegate = self
		NotificationsTimer.shared.stopFetchingNotifications()
		setNavigationVisible()
		notificationManager.getNotificationsData(showLoading: true)
		notificationManager.hideTabItemBadge()
        setNavigationBarLargeTitle()
        setUpdateScreenDelegates()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		notificationManager.notificationDelegate = nil
		NotificationsTimer.shared.startFetchingNotifications()
        removeNavigationBarLargeTitle()
    }
    
    override func prepareUI() {
        super.prepareUI()
        navigationItem.title = "Notifications"
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        notificationsTableView.addSubview(refreshControl)
    }
    
    private func setUpdateScreenDelegates() {
        userFollowingManager.screenAlertDelegate = self
        userFollowingManager.screenLoaderDelegate = self

    }
   
    private func prepateTableView() {
        notificationsTableView.register(UINib(nibName: NotificationsTableViewCell.getTheClassName(), bundle: nil), forCellReuseIdentifier: NotificationsTableViewCell.getTheClassName() )
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
    }
    
    @objc func refresh(_ sender: AnyObject) {
		notificationManager.getNotificationsData(showLoading: true)
        refreshControl.endRefreshing()
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		notificationManager.allNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.getTheClassName(), for: indexPath)
                as? NotificationsTableViewCell else { return NotificationsTableViewCell() }
        
        let notification = notificationManager.allNotifications[indexPath.row]
        cell.setup(with: notification)
        cell.rightClickButtonCallBack = { isLikeNotification in
            if isLikeNotification {
                let postDetailsVC = PostDetailsViewController()
                postDetailsVC.post = notification.post
                self.navigationController?.pushViewController(postDetailsVC, animated: true)
            } else {
                guard let user = notification.user else { return }
                UserFollowingManager.shared.switchFollowState(userId: user.id) { _ in
                    self.notificationManager.getNotificationsData()
                    self.notificationsTableView.reloadData()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profilePageVC = ProfilePageViewController()
        profilePageVC.userId = notificationManager.allNotifications[indexPath.row].notificationInfo?.userId
        navigationController?.pushViewController(profilePageVC, animated: true)
    }
}

extension NotificationsViewController: ScreenLoaderDelegate, ScreenAlertDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func showAlert(error: String, completion: (() -> Void)?) {
        if completion == nil {
            showMessage(message: error)
        }
        showMessage(message: error) { _ in
            completion?()
        }
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}

extension NotificationsViewController: NotificationManagerDelegate {
    func reloadData() {
        notificationsTableView.reloadData()

    }

    func changeNotificationLabelVisible(isHidden: Bool) {
        noNotificationsLabel.isHidden = isHidden
    }
    
}
