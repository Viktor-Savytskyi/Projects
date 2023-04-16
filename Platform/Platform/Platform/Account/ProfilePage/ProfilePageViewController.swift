import UIKit
import SideMenu
import FirebaseAuth
import FirebaseFirestore

class ProfilePageViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstAndLastNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var possesionsLabel: UILabel!
    @IBOutlet weak var followButton: AppButton!
	@IBOutlet weak var segmentControl: AppSegmentedControl!
    @IBOutlet weak var userPostsView: UserPostsView!
    @IBOutlet weak var profileInfoView: ProfileInfoView!
    
    private var socialNetworkButtonsArray = [UIButton]()
    private var themeButtonsArray = [UIButton]()
    private var editedAvatarImage: UIImage?
    private var menu: SideMenuNavigationController!
    private var menuListViewController: MenuListController!
    private var user: CHUser?
    private var posts: [Post] = []
    private let userFollowingManager = UserFollowingManager.shared

	var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choseSocialNetwork()
        selectPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearPostsLocalData()
        fetchUserData(needTrackProfileOpen: true)
        userFollowingManager.setupDelegates(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(true)
    }
    
    override func prepareUI() {
        super.prepareUI()
        setVisibleView()
        navigationItem.title = "Profile page"
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        followButton.titleLabel?.font = UIFont.boldFont?.withSize(12)
		followButton.setBorder()
		followButton.setCorners(radius: 24)
        followButton.backgroundColor = Constants.Colors.thirdlyButtonBackground
        followButton.tintColor = Constants.Colors.viewBackground
        followButton.isHidden = true
		userId = userId ?? Auth.auth().currentUser?.uid
		if userId == Auth.auth().currentUser?.uid {
            createShareButtonImageViewWithGesture()
            let menuBarButtonCustomView = createCustomViewForBarButton(imageName: "menu", action: #selector(showMenu))
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBarButtonCustomView)
            
			menuListViewController = MenuListController()
			menu = SideMenuNavigationController(rootViewController: menuListViewController)
			SideMenuManager.default.rightMenuNavigationController = menu
			SideMenuManager.default.addPanGestureToPresent(toView: view)
			menu.menuWidth = 285
			menu.presentationStyle = .menuSlideIn
			menu.presentationStyle.presentingEndAlpha = 0.64
        } else {
            let shareBarButtonCustomView = createCustomViewForBarButton(imageName: "share", action: #selector(shareButtonImageViewTaped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBarButtonCustomView)
        }
    }
    
    private func createShareButtonImageViewWithGesture() {
        let shareImageView = UIImageView(image: UIImage(named: "share"))
        containerView.addSubview(shareImageView)
        shareImageView.translatesAutoresizingMaskIntoConstraints = false
        shareImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        shareImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        shareImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: -10).isActive = true
        shareImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17).isActive = true
        
        let tapGestureForShareButtonImageView = UITapGestureRecognizer(target: self, action: #selector(shareButtonImageViewTaped))
        shareImageView.isUserInteractionEnabled = true
        shareImageView.addGestureRecognizer(tapGestureForShareButtonImageView)
    }
    
    private func choseSocialNetwork() {
        profileInfoView.completion = { [weak self] networkType in
            let socialNetworkWebViewController = SocialNetworkWebViewController()
            var userSocialName: String?
            switch networkType {
            case .twitter:
                userSocialName = self?.user?.twitterUserName
            case .instagram:
                userSocialName = self?.user?.instagramUserName
            case .tikTok:
                userSocialName = self?.user?.tikTokUserName
            case .facebook:
                userSocialName = self?.user?.facebookUserName
            }
            
            socialNetworkWebViewController.modalPresentationStyle = .fullScreen
            socialNetworkWebViewController.fill(userSocialNetworkName: userSocialName, socialNetworkType: networkType)
            self?.navigationController?.present(socialNetworkWebViewController, animated: true)
        }
    }
    
    private func selectPost() {
        userPostsView.selectPostCallBack = { [weak self] post in
            let postDetailsVC = PostDetailsViewController()
            postDetailsVC.post = post
            self?.navigationController?.pushViewController(postDetailsVC, animated: true)
        }
    }
    
    private func setVisibleView(selectedSegmentIndex: Int = 0) {
        switch selectedSegmentIndex {
        case 0:
            profileInfoView.isHidden = true
            userPostsView.isHidden = false
            scrollView.isScrollEnabled = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.setContentOffset(.zero, animated: true)
        case 1:
            profileInfoView.isHidden = true
            userPostsView.isHidden = true
        case 2:
            profileInfoView.isHidden = true
            userPostsView.isHidden = true
        case 3:
            profileInfoView.isHidden = false
            userPostsView.isHidden = true
            scrollView.showsVerticalScrollIndicator = true
            scrollView.isScrollEnabled = true
        default:
            break
        }
        segmentControl.setSegmentImages(selectedSegmentIndex: selectedSegmentIndex)
    }

	private func fetchUserData(needTrackProfileOpen: Bool = false) {
        clearPostsLocalData()
        showLoader()
        FirestoreAPI.shared.getUserData(userId: userId) { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                self.hideLoader()
                self.showMessage(message: error.localizedDescription) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else if user == nil {
                self.hideLoader()
                self.showMessage(message: "Invalid profile link") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            } else {
                self.user = user
//                guard let user else { return }
                if needTrackProfileOpen {
//                    MixpanelManager.shared.trackEvent(.userProfile, value: CHAnalyticUser.initFromUser(user: user))
                }
                self.fetchCurrentUser()
            }
        }
    }
	
	private func fetchCurrentUser() {
		guard let currentUserId = Auth.auth().currentUser?.uid else { return }
		showLoader()
		
		FirestoreAPI.shared.getUserData(userId: currentUserId) { [weak self] _, error in
			guard let self = self else { return }
			self.hideLoader()
			if let error = error {
				self.showMessage(message: error.localizedDescription) { _ in
					self.navigationController?.popViewController(animated: true)
				}
			} else {
                self.getUserPosts()
			}
		}
	}
    
    private func setupUserData() {
        guard let user = user else { return }
        if let currentUserId = AccountManager.shared.user?.uid {
            let isUserFollowingYou = (user.followersIds?.compactMap({ $0.userId }) ?? []).contains(currentUserId)
            let followTitle = isUserFollowingYou ? "Following" : "Follow"
            followButton.setTitle(followTitle.uppercased(), for: .normal)
            followButton.backgroundColor = isUserFollowingYou
                ? Constants.Colors.thirdlyButtonBackground
                : .clear
            followButton.setBorder(borderColor: isUserFollowingYou
                ? Constants.Colors.textOnLight.cgColor
                : Constants.Colors.thirdlyButtonBackground.cgColor)
            followButton.tintColor = isUserFollowingYou
                ? Constants.Colors.viewBackground
                : Constants.Colors.thirdlyButtonBackground
            followButton.isHidden = userId == currentUserId
        }
        
        followersLabel.text = String(user.followersIds?.count ?? 0)
        followingLabel.text = String(user.followedUserIds?.count ?? 0)
        possesionsLabel.text = String(posts.count)
        
        firstAndLastNameLabel.text = "\(user.firstName) \(user.lastName)"
        profileInfoView.setupUserData(user: user)
        
        if let avatarUrl = user.avatarImageUrl {
            avatarImageView.sd_setImage(with: URL(string: avatarUrl))
        }
        
        profileInfoView.setSocialNetworkButtonsImagesState(user: user)
		navigationController?.navigationBar.topItem?.title = "@\(user.userName)"
    }
    
    private func getUserPosts() {
        guard let userId = user?.id else { return }
		FirestoreAPI.shared.getPosts(usersIds: [userId]) { [weak self] posts, error  in
            guard let self = self else { return }
            if let error = error {
                self.hideLoader()
                self.showMessage(message: error.localizedDescription)
            } else {
                if posts.isEmpty {
                    self.userPostsView.setPostsToCollectionView(posts: self.posts)
                    self.hideLoader()
                }
                self.posts.append(contentsOf: posts)
                self.userPostsView.setPostsToCollectionView(posts: self.posts)
                self.setupUserData()
            }
        }
    }
    
    private func clearPostsLocalData() {
        posts = [Post]()
        userPostsView.setPostsToCollectionView(posts: posts)
    }
    
    @objc func showMenu() {
        present(menu, animated: true)
    }
    
    @objc private func shareButtonImageViewTaped() {
        guard let user else { return }
        share(deepLink: DeepLink(type: .profile, value: user.id))
//        MixpanelManager.shared.trackEvent(.shareProfile, value: CHAnalyticUser.initFromUser(user: user))
    }
    
    private func followButtonAction() {
        UserFollowingManager.shared.switchFollowState(userId: userId) { user in
            self.user = user
            self.setupUserData()
        }
    }
    
    @IBAction func changeSegmentControl(_ sender: UISegmentedControl) {
        setVisibleView(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
    
    @IBAction func followButtonClicked(_ sender: Any) {
        followButtonAction()
    }
}

extension ProfilePageViewController: ScreenLoaderDelegate, ScreenAlertDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error)
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}
