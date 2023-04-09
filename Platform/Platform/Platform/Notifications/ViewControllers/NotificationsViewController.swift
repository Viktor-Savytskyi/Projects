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
		notificationManager.delegate = self
		NotificationsTimer.shared.stopFetchingNotifications()
		setNavigationVisible()
		notificationManager.getNotificationsData(showLoading: true)
		notificationManager.hideTabItemBadge()
        setNavigationBarLargeTitle()
        setUpdateScreenDelegat()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		notificationManager.delegate = nil
		NotificationsTimer.shared.startFetchingNotifications()
        removeNavigationBarLargeTitle()
    }
    
    override func prepareUI() {
        super.prepareUI()
        navigationItem.title = "Notifications"
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        notificationsTableView.addSubview(refreshControl)
    }
    
    private func setUpdateScreenDelegat() {
        userFollowingManager.updateScreenDelegat = self

    }
   
    private func prepateTableView() {
        notificationsTableView.register(UINib(nibName: NotificationsTableViewCell.identifier, bundle: nil),
                                        forCellReuseIdentifier: NotificationsTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier, for: indexPath)
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

extension NotificationsViewController: NotificationManagerDelegate {
    var viewController: NotificationsViewController {
        self
    }
}

extension NotificationsViewController: UpdateScreenDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func showAlert(error: String) {
        showMessage(message: error)
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}
