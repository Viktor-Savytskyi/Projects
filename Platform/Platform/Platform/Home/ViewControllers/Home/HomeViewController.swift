import UIKit
import FirebaseAuth
import FirebaseFirestore

enum SortFilter {
	case forYou, following, searchByPostTitle
}

class HomeViewController: BaseViewController, UITabBarControllerDelegate {

    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var folowingButton: UIButton!
    @IBOutlet weak var forYouButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var emptyPostsLabel: UILabel!
    @IBOutlet weak var searchDropDownTableView: UITableView!
    @IBOutlet weak var searchTableViewHeightConstraint: NSLayoutConstraint!

	var closeSearchImageView: UIImageView?

    private var posts: [Post] = []
    private let usersStorage = UsersStorage.shared

	private var textForSearchPosts: String = ""
	private var searchedPosts: [Post] {

		let filtered = posts.filter {
			$0.title.lowercased().contains(textForSearchPosts.lowercased())
            || $0.description.lowercased().contains(textForSearchPosts.lowercased())
		}
		return filtered
	}

	private var followedPosts: [Post] {
		guard let currentUser = AccountManager.shared.currentUser else { return [] }
		let followedIds = currentUser.followedUserIds?.map { $0.userId } ?? []
		return posts.filter { followedIds.contains($0.userId) }
	}

	var postForCollection: [Post] {
		postsFilter == .searchByPostTitle
			? searchedPosts
			: (postsFilter == .following ? followedPosts : posts)
	}

    private var users: [CHUser]?
	private var searchedUsers: [CHUser]?

    private var buttonsArray = [UIButton]()
	private var postsFilter: SortFilter = .forYou {
		didSet {
			emptyPostsLabel.isHidden = true
			updateFollowEmptyLabel()
			changeSelectedButton()
			postsTableView.reloadData()
		}
	}
    private let refreshControl = UIRefreshControl()
    private let searchTableViewCellHeight = 50
    private let maxVisibleSearchRows = 6

    private var seachResultRows: Int {
        (searchedUsers?.count ?? 0) + 1
    }

	private var isSearching: Bool {
		searchBar.text!.filter { $0 != "@" }.count > 0
	}
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Create several posts
//        FirestoreAPI.shared.createSeveralPosts(count: 6)
//        FirestoreAPI.shared.setInterests(interest: demoResponse)
        
        // need to check mabe state is it need to change?
        if usersStorage.users == nil {
			fetchCurrentUser()
		} else {
			if isSearching {
				onSearchTextChanged()
			} else {
				loadAllPostsAndUsers()
			}
		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.setAnimationsEnabled(true)
        setNavigationVisible(tabBarIsHidden: false, navigationBarIsHidden: true)
        tabBarController?.delegate = self
		if AccountManager.shared.shouldUpdateHomeScreenOnAppear {
			refresh(refreshControl)
			AccountManager.shared.shouldUpdateHomeScreenOnAppear = false
		}
        
        if postsFilter != .searchByPostTitle {
            setupRefreshContol()
        }
		updateFollowEmptyLabel()
		postsTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
    }
    
    override func prepareUI() {
        super.prepareUI()
		postsFilter = .forYou
		prepateTableViews()
		prepareButtons()
		prepareSearchBar()
        searchDropDownTableView.isHidden = true
		//		Temp fix crash with font when open deleted profile
		_ = UIFont.boldFont
		_ = UIFont.regularFont
    }
	
	private func updateFollowEmptyLabel() {
		if postsFilter == .following {
			let followedIds = AccountManager.shared.currentUser?.followedUserIds ?? []
			emptyPostsLabel.isHidden = !followedIds.isEmpty
			if followedIds.isEmpty {
				emptyPostsLabel.text = "You aren’t following \nany users yet."
			}
		}
	}
    
    private func setupRefreshContol() {
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
    }
    
    private func removeRefreshControl() {
        refreshControl.removeTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.removeFromSuperview()
    }
    
    private func prepareSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.prepareSearchBar(plaseholder: "Search")
    }
	
    private func prepateTableViews() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: PostTableViewCell.getTheClassName(), bundle: nil),
                                forCellReuseIdentifier: PostTableViewCell.getTheClassName())
        
        searchDropDownTableView.layer.cornerRadius = 15
        searchDropDownTableView.backgroundColor = Constants.Colors.viewBackground
        searchDropDownTableView.delegate = self
        searchDropDownTableView.dataSource = self
        searchDropDownTableView.register(UINib(nibName: DropDownSearchListCell.getTheClassName(), bundle: nil),
                                         forCellReuseIdentifier: DropDownSearchListCell.getTheClassName())
    }
    
    private func prepareButtons() {
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        filterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        filterButton.isHidden = true // for deleting
        
        buttonsArray = [
            forYouButton,
            folowingButton,
            filterButton
        ]
        for button in buttonsArray {
            button.layer.cornerRadius = 15
            button.backgroundColor = UIColor.clear
            button.tintColor = Constants.Colors.textOnLight
            button.setBorder(borderColor: UIColor.black.withAlphaComponent(0.2).cgColor)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        clearPostsLocalData()
        finishSearch()
        
        switch postsFilter {
        case .forYou:
			loadAllPostsAndUsers { [weak self] in
                self?.refreshControl.endRefreshing()
			}
        case .following:
			loadAllPostsAndUsers { [weak self] in
				self?.filterByFollowing()
				self?.refreshControl.endRefreshing()
			}
        case .searchByPostTitle:
            print("refresh in searchByPostTitle case")
        }
    }

    private func finishSearch(isSearchByPostFinished: Bool = false) {
        searchBar.text = ""
        searchedUsers = nil
        view.endEditing(true)
        searchDropDownTableView.isHidden = true
        
        if isSearchByPostFinished {
            searchBar.isUserInteractionEnabled = true
            closeSearchImageView?.removeFromSuperview()
            setupRefreshContol()
        }
    }
    
    private func clearPostsLocalData() {
        posts = []
		usersStorage.users = []
		searchedUsers = []
		
        postsTableView.reloadData()
    }
    
    private func changeSelectedButton() {
        folowingButton.isSelected = postsFilter == .following
        forYouButton.isSelected = postsFilter == .forYou
    }
    
    private func fetchCurrentUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        showLoader()
        
        FirestoreAPI.shared.getUserData(userId: currentUserId) { [weak self] _, error in
            guard let self = self else { return }
            self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription) { _ in
					self.fetchCurrentUser()
                }
			} else {
				self.loadAllPostsAndUsers()
			}
        }
    }
    
	private func loadPosts(
        followedUsersIds: [String] = [],
        getAllUserPosts: Bool = false,
        completion: (() -> Void)? = nil) {
            
		emptyPostsLabel.isHidden = true
		postsTableView.reloadData()
        FirestoreAPI.shared.getPosts(completion: { [weak self] posts, error  in
            guard let self = self else { return }
            if let error = error {
                completion?()
				self.hideLoader()
                self.showMessage(message: error.localizedDescription)
            } else {
				self.posts = posts
				self.emptyPostsLabel.isHidden = !self.posts.isEmpty
				if posts.isEmpty {
                    self.emptyPostsLabel.text = "No Posts"
					self.postsTableView.reloadData()
					self.hideLoader()
					completion?()
					return
				}
                self.usersStorage.featchUsers(screenAlertDelegate: self, completion: {
                    self.postsTableView.reloadData()
                    self.hideLoader()
                    completion?()
                })
			}
        })
    }
	
	@IBAction func forYouButtonClicked(_ sender: Any) {
		finishSearch(isSearchByPostFinished: true)
		clearPostsLocalData()
		postsFilter = .forYou
		loadAllPostsAndUsers()
	}
	
	@IBAction func followingButtonClick(_ sender: Any) {
		filterByFollowing()
	}
	
    @IBAction func filterButtonClick(_ sender: UIButton) {
		print("filter button tapped")
    }
	
	private func filterByFollowing() {
		finishSearch(isSearchByPostFinished: true)
		postsFilter = .following
	}
	
	private func getAllPosts(completion: (() -> Void)? = nil) {
		showLoader()
        refreshControl.endRefreshing()
		emptyPostsLabel.isHidden = true
		loadPosts(completion: completion)
	}

	private func loadAllPostsAndUsers(completion: (() -> Void)? = nil) {
		showLoader()
		FirestoreAPI.shared.getAllUsers { [weak self] users, error in
			guard let self = self else { return }
			if let error = error {
				self.hideLoader()
				self.showMessage(message: error.localizedDescription) { _ in
					self.loadAllPostsAndUsers(completion: completion)
				}
			} else {
				self.users = users
				self.getAllPosts(completion: completion)
			}
		}
	}
    
    private func moveToUserDetails(index: Int) {
        let profilePageVC = ProfilePageViewController()
        profilePageVC.userId = searchedUsers?[index].id
        navigationController?.pushViewController(profilePageVC, animated: true)
    }
    
	private func moveToPostDetails(post: Post) {
        if postsFilter != .searchByPostTitle {
            finishSearch()
        }
        let postDetailsVC = PostDetailsViewController()
        postDetailsVC.post = post
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    func createCustomSearchCancelButton() {
        closeSearchImageView = UIImageView(image: UIImage())
        guard let closeSearchImageView else { return }
        view.addSubview(closeSearchImageView)
        closeSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        closeSearchImageView.widthAnchor.constraint(equalToConstant: 19).isActive = true
        closeSearchImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        closeSearchImageView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        closeSearchImageView.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -15).isActive = true
        
        let tapGestureForShareButtonImageView = UITapGestureRecognizer(target: self,
                                                                       action: #selector(customCancelButtonTaped))
        closeSearchImageView.isUserInteractionEnabled = true
        closeSearchImageView.addGestureRecognizer(tapGestureForShareButtonImageView)
    }
    
    @objc func customCancelButtonTaped() {
        finishSearch(isSearchByPostFinished: true)
		postsFilter = .forYou
    }

    private func showSearchedPosts() {
        view.endEditing(true)
        searchBar.isUserInteractionEnabled = false
        searchDropDownTableView.isHidden = true
        createCustomSearchCancelButton()
        postsFilter = .searchByPostTitle
        removeRefreshControl()
		setUICongigurationsByFilteredPostsResult()
        postsTableView.reloadData()
    }
    
    private func setUICongigurationsByFilteredPostsResult() {
        if let searchText = searchBar.text {
			textForSearchPosts = searchText
            searchBar.text = "Results for “\(searchText)”"
        }
        emptyPostsLabel.text = "No relevant posts \nwere found."
        emptyPostsLabel.isHidden = !searchedPosts.isEmpty
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case postsTableView:
			return postForCollection.count
        case searchDropDownTableView:
            return seachResultRows
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case postsTableView:
			let postsForShow = postForCollection
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.getTheClassName())
                    as? PostTableViewCell else { return PostTableViewCell() }
			let user = usersStorage.users?.first(where: { $0.id == postsForShow[indexPath.row].userId })
			cell.setup(with: postsForShow[indexPath.row],
					   and: user)
			cell.moveToPostDetailsCallBack = {
				self.moveToPostDetails(post: postsForShow[indexPath.row])
			}
			return cell
        case searchDropDownTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownSearchListCell.getTheClassName())
                    as? DropDownSearchListCell else { return DropDownSearchListCell() }
            if indexPath.row == 0 {
                cell.setWithSearched(text: searchBar.text ?? "")
            } else {
                cell.setWith(user: searchedUsers?[indexPath.row - 1])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case postsTableView:
            moveToPostDetails(post: postForCollection[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        case searchDropDownTableView:
            if indexPath.row == 0 {
                showSearchedPosts()
            } else {
                moveToUserDetails(index: indexPath.row - 1)
            }
            searchDropDownTableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
  
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if postsTableView.isDragging {
            if postsFilter == .forYou || postsFilter == .following {
                finishSearch()
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
	private func onSearchTextChanged() {
		if isSearching {
			let searchedText = searchBar.text!.lowercased().filter { $0 != "@" }
            searchedUsers = usersStorage.users?.filter { $0.userName.lowercased().contains(searchedText) }
		}
        searchDropDownTableView.reloadData()
        searchTableViewHeightConstraint.constant =
            CGFloat(seachResultRows < maxVisibleSearchRows
                ? (seachResultRows) * searchTableViewCellHeight
                : searchTableViewCellHeight * maxVisibleSearchRows)
        searchDropDownTableView.layoutIfNeeded()
        searchDropDownTableView.isHidden = !isSearching
	}
    
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		onSearchTextChanged()
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        finishSearch()
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchTextChanged()
    }
}

extension HomeViewController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error) { _ in
            completion?()
        }
    }
}
