import UIKit

class PostInterestsAndThemesViewController: BaseViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var noDifferentCatergoryButton: UIButton!
    @IBOutlet weak var themesBackgroundView: UIView!
    @IBOutlet weak var themeButtonsView: ThemeButtonsView!
    @IBOutlet weak var noThemesLabel: UILabel!
    @IBOutlet weak var chooseButton: AppButton!
    @IBOutlet weak var cancelButton: AppButton!
    
    var editLocalImageFirst: LocalImage?
    var editLocalImageSecond: LocalImage?
    var editLocalImageThird: LocalImage?
    var post: Post!

    var interestsToShow = [String]()
    var selectedInterests = [String]()
    var selectedThemes = [String]()
    var themeButtons: [UIButton]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionViews()
        prepareThemes()
        prepareInterests()
    }
   
    override func prepareUI() {
        super.prepareUI()
        let gestureRecogniserForImageView = UITapGestureRecognizer(target: self, action: #selector(moveToInterestsList))
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(gestureRecogniserForImageView)
        title = "Add to Collection"
        noDifferentCatergoryButton.setUnderlinedTitle(title: noDifferentCatergoryButton.currentTitle ?? "No, different catergory")
    }
    
    @objc private func moveToInterestsList() {
        let interestVC = InterestsViewController()
        interestVC.state = .postCreate
        interestVC.post = post
        interestVC.editLocalImageFirst = editLocalImageFirst
        interestVC.editLocalImageSecond = editLocalImageSecond
        interestVC.editLocalImageThird = editLocalImageThird
        navigationController?.pushViewController(interestVC, animated: true)
    }
    
    private func prepareCollectionViews() {
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.register(UINib(nibName: InterestCell.getTheClassName(), bundle: nil), forCellWithReuseIdentifier: InterestCell.getTheClassName())
    }
    
    private func prepareInterests() {
        selectedInterests = []
		interestsToShow = AccountManager.shared.currentUser?.selectedInterestCodes ?? []
    }
    
    private func prepareThemes() {
        themeButtonsView.themeButtonDelegate = self
        let firstTheme = AccountManager.shared.currentUser?.firstTheme
        let secondTheme = AccountManager.shared.currentUser?.secondTheme
        let thirdTheme = AccountManager.shared.currentUser?.thirdTheme
        themeButtonsView.firstThemeButton.setTitle(firstTheme, for: .normal)
        themeButtonsView.secondThemeButton.setTitle(secondTheme, for: .normal)
        themeButtonsView.thirdThemeButton.setTitle(thirdTheme, for: .normal)
        themeButtonsView.firstThemeButton.isHidden = firstTheme == nil
        themeButtonsView.secondThemeButton.isHidden = secondTheme == nil
        themeButtonsView.thirdThemeButton.isHidden = thirdTheme == nil
        themeButtonsView.isHidden = themeButtonsView.firstThemeButton.isHidden
            && themeButtonsView.secondThemeButton.isHidden
            && themeButtonsView.thirdThemeButton.isHidden
        noThemesLabel.isHidden = !themeButtonsView.isHidden
        selectedThemes = []
        themeButtons = [themeButtonsView.firstThemeButton, themeButtonsView.secondThemeButton, themeButtonsView.thirdThemeButton]
        
        themeButtons?.forEach {
            $0.backgroundColor = Constants.Colors.background
            $0.setBorder()
            $0.setTitleColor(Constants.Colors.textOnLight, for: .normal)
        }
    }
    
    private func chooseTheme() {
        var themeName = String()
        
        switch themeButtonsView.numberOfTheme {
        case .firstTheme:
            themeName = themeButtonsView.firstThemeButton.titleLabel?.text ?? ""
        case .secondTheme:
            themeName = themeButtonsView.secondThemeButton.titleLabel?.text ?? ""
        case .thirdTheme:
            themeName = themeButtonsView.thirdThemeButton.titleLabel?.text ?? ""
        case .none:
            return
        }
        
        let removeAllThemes: () = selectedThemes.removeAll { $0 == themeName }
        selectedThemes.contains(themeName)
            ? removeAllThemes
            : selectedThemes.append(themeName)
        
        guard let themeButtons else { return }
        themeButtons.forEach {
            if selectedThemes.contains($0.currentTitle ?? "") {
                $0.backgroundColor = Constants.Colors.viewBackgroundSecond
                $0.setTitleColor(Constants.Colors.background, for: .normal)
            } else {
                $0.backgroundColor = Constants.Colors.background
                $0.setTitleColor(Constants.Colors.textOnLight, for: .normal)
            }
        }
    }
	
    @IBAction func chooseButtonClicked(_ sender: Any) {
        post.interestCodes = selectedInterests
        post.themes = selectedThemes
        post.updatedAt = Date()
        
        ImageUploadManager.shared.setupDelegates(self)
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
//					MixpanelManager.shared.trackEvent(.createPost, value: MixpanelPost.initFromPost(post: self.post))
					if self.post.isForSale {
//						MixpanelManager.shared.trackEvent(.markedForSale, value: postId)
					}
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let createPostVC = self.navigationController?.viewControllers.first as? CreatePostViewController {
                            createPostVC.cleanFields()
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
    }
    
    @IBAction func moveToInterests(_ sender: Any) {
        moveToInterestsList()
    }
    
    @IBAction func btnCancelClicked(_ sender: AppButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension PostInterestsAndThemesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  interestsToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestCell.getTheClassName(), for: indexPath)
                as? InterestCell else { return InterestCell() }
            let isSelected = selectedInterests.contains(interestsToShow[indexPath.row])
            cell.setup(name: interestsToShow[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interes = interestsToShow[indexPath.row]
        let removeSelectedInterest: () = selectedInterests.removeAll { $0 == interes }
        selectedInterests.contains(interes)
            ? removeSelectedInterest
            : selectedInterests.append(interes)
        collectionView.reloadData()
    }
}

extension PostInterestsAndThemesViewController: ThemeButtonDelegate {
    func themeButtonTapped() {
        chooseTheme()
    }
}

extension PostInterestsAndThemesViewController: ScreenLoaderDelegate {
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
