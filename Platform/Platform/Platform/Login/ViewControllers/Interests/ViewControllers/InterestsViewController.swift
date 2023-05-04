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
    
//    var selectedInterestsCallBack: (([String]) -> Void)?
//    var isCustomCategoryAdded = false
    var editLocalImageFirst: LocalImage?
    var editLocalImageSecond: LocalImage?
    var editLocalImageThird: LocalImage?
    var post: Post!
    var state: InterestVCState = .register
    var interestsViewModel: InterestsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterestViewModel()
        drawInterestTree()
        interestsViewModel.setupUserInterests()
    }
    
    override func prepareUI() {
        super.prepareUI()
        scrollView.contentSize = stackView.frame.size
        interestsSearchBar.prepareSearchBar(plaseholder: Constants.InterestsScreen.searchBarPlaceholder)
        interestsSearchBar.delegate = self
        noSearchResultLabel.isHidden = true
        
        cancelButton.isHidden = state != .postCreate
        switch state {
        case .register:
            topLabel.text = Constants.InterestsScreen.topLabelTitleForRegisterState
            descriptionLabel.text = Constants.InterestsScreen.descriptionForRegisterState
            chooseButton.setTitle("Finish", for: .normal)

        case .account:
            topLabel.text =  Constants.InterestsScreen.topLabelTitleForAccountState
            descriptionLabel.text = Constants.InterestsScreen.descriptionForAccountState
            title = Constants.InterestsScreen.titleForAccountState
        case .postCreate:
            topLabel.text = Constants.InterestsScreen.topLabelTitleForcCreatePostState
            descriptionLabel.text = Constants.InterestsScreen.topLabelTitleForcCreatePostState
            title = Constants.InterestsScreen.titleForCreatePostState
        }
        if state == .register {
            let skipBarButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipClicked))
            skipBarButton.tintColor = Constants.Colors.textOnLight
            navigationItem.rightBarButtonItem = skipBarButton
        }
    }
    
    private func setupInterestViewModel() {
        interestsViewModel = InterestsViewModel()
        interestsViewModel.showMessageDelegate = self
        interestsViewModel.screenLoaderDelegate = self
        interestsViewModel.updateInterestsScreenDelegate = self
        interestsViewModel.showToastDelegate = self
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
        guard interestsViewModel.getInterestsTree() != nil else { return }
        
        if interestsViewModel.getFilteredInterestsResponse() == nil {
            interestsViewModel.getInterestTreeCategories().forEach { [weak self] superCategory in
                guard let self else { return }
                let superCatView = InterestSuperCategoryView()
                superCatView.setup(superCategory: superCategory,
                                   interestChangesDelegate: self)
                superCatView.drawInterestTreeCallBack = { self.drawInterestTree() }
                stackView.addArrangedSubview(superCatView)
            }
        } else {
            interestsViewModel.getFilteredInterestsResponseCategories()!.forEach { [weak self] superCategory in
                guard let self else { return }
                let superCatView = InterestSuperCategoryView()
                superCatView.setup(superCategory: superCategory,
                                   interestChangesDelegate: self,
                                   filteredCategories: interestsViewModel.getFilteredInterestsResponseCategories() ?? [])
                stackView.addArrangedSubview(superCatView)
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: AppButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseButtonClicked(_ sender: Any) {
        if state == .postCreate {
            interestsViewModel.setupImageUploadManagerDelegates(self)
            interestsViewModel.createPost(post: post,
                                          editLocalImageFirst: editLocalImageFirst,
                                          editLocalImageSecond: editLocalImageSecond,
                                          editLocalImageThird: editLocalImageThird) { [weak self] in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let createPostVC = self.navigationController?.viewControllers.first as? CreatePostViewController {
                        createPostVC.cleanFields()
                    }
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            interestsViewModel.setOrUpdateUserInterests(state: state)
        }
    }
    
    @objc func skipClicked(_ sender: Any) {
        switch BuildManager.shared.buildType {
        case .release:
            interestsViewModel.updateOwnerData()
        case .dev:
            interestsViewModel.moveToHomeScreen()
        }
    }
}

extension InterestsViewController: InterestChangedDelegate {
    func visibleChanged() {
        drawInterestTree()
    }
    
    func selectSuperCategory(superCategory: Category) {
        interestsViewModel.switchSelection(item: superCategory)
	   drawInterestTree()
    }
    
    func selectCategory(category: Category) {
        interestsViewModel.switchSelection(item: category)
        drawInterestTree()
    }
}

extension InterestsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interestsViewModel.searchCategory(text: searchText) { [weak self] in
            self?.setInterestsVisualState(result: self?.interestsViewModel.getFilteredInterestsResponseCategories())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interestsSearchBar.endEditing(true)
    }
}

extension InterestsViewController: ScreenLoaderDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}

extension InterestsViewController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension InterestsViewController: UpdateInterestsScreenDelegate {
    func updateScreen() {
        drawInterestTree()
    }
}

extension InterestsViewController: ScreenToastDelegate {
    func showInfo(message: String, completion: (() -> Void)?) {
        showToast(message: message)
    }
}
