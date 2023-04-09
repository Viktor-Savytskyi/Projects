import UIKit
import FirebaseAuth

enum InterestVCState {
	case register, account, postCreate
}

protocol InterestChangedDelegate: AnyObject {
	func visibleChanged()
	func selectSuperCategory(superCategory: Category)
	func selectCategory(category: Category)
}

class InterestsViewController: BaseViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseButton: AppButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelButton: AppButton!
    @IBOutlet weak var interestsSearchBar: CustomSearchBar!
    @IBOutlet weak var noSearchResultLabel: UILabel!
    
    var selectedInterestsCallBack: (([String]) -> Void)?
    private let interestManager = InterestManager.shared
    private var filteredInterestsResponse: InterestResponse?
    var isCustomCategoryAdded = false
    var editLocalImageFirst: LocalImage?
    var editLocalImageSecond: LocalImage?
    var editLocalImageThird: LocalImage?
    var post: Post!
    var state: InterestVCState = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()
	   interestManager.customInterestsTree = nil
        getInterests()
        loadSelectedInterests()
    }
    
    override func prepareUI() {
        super.prepareUI()
        scrollView.contentSize = stackView.frame.size
        interestsSearchBar.prepareSearchBar(plaseholder: "Search Categories")
        interestsSearchBar.delegate = self
        noSearchResultLabel.isHidden = true
        
        cancelButton.isHidden = state != .postCreate
        switch state {
        case .register:
            topLabel.text = "Create account"
            descriptionLabel.text = "Tell us what your obsessions are!\nWe’ll be able to show you more of what love."
            chooseButton.setTitle("Finish", for: .normal)

        case .account:
            topLabel.text = "What’s your obsession?"
            descriptionLabel.text = "Tell us the things you love!"
            title = "Interests"
        case .postCreate:
            topLabel.text = "Where does this go?"
            descriptionLabel.text = "Tell us what category your item belongs to."
            title = "Add to Collection"
        }
        drawInterestTree()
        if state == .register {
            let skipBarButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipClicked))
            skipBarButton.tintColor = Constants.Colors.textOnLight
            navigationItem.rightBarButtonItem = skipBarButton
        }
    }
    
    private func loadSelectedInterests() {
        showLoader()
        FirestoreAPI.shared.getUserData(userId: Auth.auth().currentUser?.uid ?? "") { [weak self] (user, error) in
            guard let self = self else { return }
            if let error = error {
                self.hideLoader()
                self.showMessage(message: error.localizedDescription) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
			 self.interestManager.selectedCodes = user?.selectedInterestCodes ?? []
                self.drawInterestTree()
            }
        }
    }
    
    private func getInterests() {
        showLoader()
        FirestoreAPI.shared.getInterests { [weak self] response, error in
            guard let self = self else { return }
            self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if AccountManager.shared.currentUser?.customTree == nil {
                    self.interestManager.interestsTree = response
                } else {
                    self.interestManager.customInterestsTree = AccountManager.shared.currentUser?.customTree
                    self.interestManager.interestsTree = self.interestManager.customInterestsTree
                }
                self.drawInterestTree()
            }
        }
    }
    
    private func setInterestsVisualState(result: [Category]?) {
        if result == [] {
            drawInterestTree()
            noSearchResultLabel.isHidden = false
            scrollView.isHidden = true
        } else {
            drawInterestTree()
            noSearchResultLabel.isHidden = true
            scrollView.isHidden = false
        }
    }
    
    private func drawInterestTree() {
        stackView.arrangedSubviews.forEach { subView in
            subView.removeFromSuperview()
        }
        guard interestManager.interestsTree != nil else { return }
        
        if filteredInterestsResponse == nil {
            interestManager.interestsTree!.categories.forEach { superCategory in
                let superCatView = InterestSuperCategoryView()
                superCatView.setup(superCategory: superCategory,
                                   interestChangesDelegate: self)
                superCatView.drawInterestTreeCallBack = { self.drawInterestTree() }
                stackView.addArrangedSubview(superCatView)
            }
        } else {
            filteredInterestsResponse!.categories.forEach { superCategory in
                let superCatView = InterestSuperCategoryView()
                superCatView.setup(superCategory: superCategory,
                                   interestChangesDelegate: self,
                                   filteredCategories: filteredInterestsResponse?.categories ?? [])
                stackView.addArrangedSubview(superCatView)
            }
        }
    }
    
    private func searchCategory(text: String) {
        guard let categoriesForSearch = interestManager.interestsTree else { return }
        filteredInterestsResponse = categoriesForSearch
        filteredInterestsResponse?.categories = []

        if !text.isEmpty {
            categoriesForSearch.categories.forEach { category in
			 if category.code.lowercased().contains(text.lowercased()) {
				filteredInterestsResponse?.categories.append(category)
			 } else if let machingCategories = category.children?.filter({ $0.code.lowercased().contains(text.lowercased()) }), !machingCategories.isEmpty {
				filteredInterestsResponse?.categories.append(Category(code: category.code, children: machingCategories))
			 }
            }
            setInterestsVisualState(result: filteredInterestsResponse?.categories)
        } else {
            filteredInterestsResponse = nil
            setInterestsVisualState(result: filteredInterestsResponse?.categories)
            return
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: AppButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseButtonClicked(_ sender: Any) {
        if state == .postCreate {
            createPost()
        } else {
            setOrUpdateUserInterests()
        }
    }
    
    private func createPost() {
        post.interestCodes = interestManager.selectedCodes
        post.updatedAt = Date()
        
        ImageUploadManager.shared.delegate = self
        ImageUploadManager.shared.uploadImages(post: post,
                                               editLocalImageFirst: editLocalImageFirst,
                                               editLocalImageSecond: editLocalImageSecond,
                                               editLocalImageThird: editLocalImageThird) { [weak self] (error, _)  in
            guard let self = self else { return }
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
                FirestoreAPI.shared.createPost(post: self.post) { [weak self] _, postId in
                    guard let self = self else { return }
                self.post.id = postId
                    self.hideLoader()
//                MixpanelManager.shared.trackEvent(.createPost, value: MixpanelPost.initFromPost(post: self.post))
                if self.post.isForSale {
//                    MixpanelManager.shared.trackEvent(.markedForSale, value: postId)
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let createPostVC = self.navigationController?.viewControllers.first as? CreatePostViewController {
                            createPostVC.cleanFields()
                        }
                        self.tabBarController?.selectedIndex = 0
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func setOrUpdateUserInterests() {
        showLoader()
        FirestoreAPI.shared.getUserData(userId: AccountManager.shared.user?.uid ?? "") { [weak self] (user, error) in
            guard let self = self else { return }
            if let error = error {
                self.hideLoader()
                self.showMessage(message: error.localizedDescription)
            } else if let user = user {
                user.selectedInterestCodes = self.interestManager.selectedCodes
                
                // if customInterestsTree != nil - we save it for user
                if self.interestManager.customInterestsTree != nil {
                    user.customTree = self.interestManager.customInterestsTree
                }
                
                FirestoreAPI.shared.saveUserData(user: user) { error in
                    if let error = error {
                        self.hideLoader()
                        self.showMessage(message: error.localizedDescription)
                    } else {
//                        MixpanelManager.shared.trackEvent(.updateProfile, value: CHAnalyticUser.initFromUser(user: user))
                        if self.state == .register {
                            switch BuildManager.shared.buildType {
                            case .release:
                                self.updateOwnerData()
                            case .dev:
                                self.hideLoader()
                                self.goToHome()
                            }
                        } else {
                            self.hideLoader()
                            self.showToast(message: "Interests updated")
                            self.drawInterestTree()
                        }
                    }
                }
            }
        }
    }
    
    private func updateOwnerData() {
	   // get Shilrey user data
	   FirestoreAPI.shared.getUserData(userId: Constants.AppOwnerInfo.id) { [weak self] (owner, error) in
		  guard let self = self else { return }
		  if let error = error {
			 self.hideLoader()
			 self.showMessage(message: error.localizedDescription)
		  } else if let owner = owner, let currentUserId = AccountManager.shared.user?.uid {
			 if owner.followersIds == nil {
				owner.followersIds = [NotificationInfo(userId: currentUserId)]
			 } else {
				owner.followersIds?.append(NotificationInfo(userId: currentUserId))
			 }
			 // save Shilrey updated data
			 FirestoreAPI.shared.saveUserData(user: owner) { error in
				self.hideLoader()
				if let error = error {
				    self.showMessage(message: error.localizedDescription)
				} else {
				    self.goToHome()
				}
			 }
		  }
	   }
    }
    
    @objc func skipClicked(_ sender: Any) {
        switch BuildManager.shared.buildType {
        case .release:
            updateOwnerData()
        case .dev:
            goToHome()
        }
    }
    
    private func goToHome() {
        Utils.window?.rootViewController = NavigationBuilder.shared.createTabBar()
    }
}

extension InterestsViewController: InterestChangedDelegate {
    func visibleChanged() {
        drawInterestTree()
    }
    
    func selectSuperCategory(superCategory: Category) {
	   interestManager.switchSelection(item: superCategory)
	   drawInterestTree()
    }
    
    func selectCategory(category: Category) {
	   interestManager.switchSelection(item: category)
        drawInterestTree()
    }
}

extension InterestsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCategory(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interestsSearchBar.endEditing(true)
    }
}

extension InterestsViewController: ImageUploadManagerDelegate {
    var viewController: BaseViewController {
        self
    }
}
