import UIKit
import DropDown

class ProfileSettingsViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var userNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var tikTokButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var saveChangesButton: AppButton!
    @IBOutlet weak var cancelButton: AppButton!
    @IBOutlet weak var userSocialNetworkNameView: TextFieldViewWithButtons!
    @IBOutlet weak var socialNetworkButtonsStackView: UIStackView!
    @IBOutlet weak var themeButtonsView: ThemeButtonsView!
    @IBOutlet weak var themeTextFieldWithDropDownView: TextFieldViewWithButtons!
    
    private let dropDown = DropDown()
    private let picker = ImagePickerController()
    private var buttonsArray = [UIButton]()
    private var editedAvatarImage: Data?
    private var socialNetworkType: SocialNetworkType?
    private var visibleViewType: VisibleViewType?
    private let userSocialNetworkNameMaxLenght = 50
    private let themeMaxLenght = 30
    private let bioMaxLenght = 255
    private var localUser: CHUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        prepareButtons()
        fetchUserData()
        prepareDropDown()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        setWhichViewIsVisible()
    }
    
    override func prepareUI() {
        super.prepareUI()
        navigationItem.title = "Profile Settings"
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        userNameTextFieldView.placeholder = "Username"
        userNameTextFieldView.errorText = nil
        userNameTextFieldView.textField.delegate = self
        userNameTextFieldView.textField.returnKeyType = .next
        userNameTextFieldView.textField.autocapitalizationType = .words
        userNameTextFieldView.textField.addTarget(self, action: #selector(userNameTextFieldDidChange), for: .editingChanged)
        bioTextView.placeholder = "Bio (optional)"
        bioTextView.layer.cornerRadius = 5
        bioTextView.delegate = self
        userSocialNetworkNameView.isHidden = true
        userSocialNetworkNameView.textFieldView.textField.delegate = self
        userSocialNetworkNameView.buttonsDelegate = self
        userSocialNetworkNameView.textFieldView.textField.returnKeyType = .done
        userSocialNetworkNameView.textFieldView.textField.addPermanentSymbolOnLeft(symbol: " @", customFontSize: 25)
        userSocialNetworkNameView.textFieldView.textField.addTarget(self, action: #selector(userSocialNetworkNameTextFieldDidChange), for: .editingChanged)
        themeTextFieldWithDropDownView.textFieldView.textField.placeholder = "{LIVE TEXT}"
        themeTextFieldWithDropDownView.isHidden = true
        themeTextFieldWithDropDownView.buttonsDelegate = self
        themeTextFieldWithDropDownView.textFieldView.textField.delegate = self
        themeTextFieldWithDropDownView.textFieldView.textField.addPermanentSymbolOnLeft(leftViewWidth: 15)
        themeTextFieldWithDropDownView.textFieldView.textField.addTarget(self, action: #selector(themeTextFieldDidChange), for: .editingChanged)
        themeTextFieldWithDropDownView.textFieldView.textField.returnKeyType = .done
        themeTextFieldWithDropDownView.textFieldView.errorText = nil
        themeButtonsView.themeButtonDelegate = self
    }
    
    private func prepareButtons() {
        buttonsArray = [
            twitterButton,
            instagramButton,
            tikTokButton,
            facebookButton
        ]
        buttonsArray.forEach { $0.setTitle("", for: .normal) }
    }
    
    private func prepareDropDown() {
        dropDown.anchorView = themeTextFieldWithDropDownView.textFieldView.textField
        dropDown.dataSource = ["Kawaii", "Retro", "Creepy", "Tiny", "Lorem"]
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)! )
        dropDown.backgroundColor = Constants.Colors.viewBackground
        dropDown.separatorColor = Constants.Colors.textOnLight
        dropDown.textFont = .standartText ?? .systemFont(ofSize: 17)
        dropDown.textColor = Constants.Colors.textOnLight
        dropDown.cancelAction = { [unowned self] in
            dropDown.hide()
        }
        dropDown.dismissMode = .automatic
        dropDown.direction = .bottom
        dropDown.cornerRadius = 5
        dropDown.shadowRadius = 0
        dropDown.cellNib = UINib(nibName: DropDownThemesListCell.identifire, bundle: nil)
        dropDown.customCellConfiguration = { (index, _, cell) in
            guard let cell = cell as? DropDownThemesListCell else { return }
            cell.optionLabel.text = self.dropDown.dataSource[index]
        }
        dropDown.selectionBackgroundColor = .clear
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            themeTextFieldWithDropDownView.textFieldView.textField.text = item
            dropDown.deselectRow(at: index)
        }
    }
    
    @objc func hideAllVisibleViews() {
        visibleViewType = nil
        setWhichViewIsVisible()
    }
    
    @objc private func userSocialNetworkNameTextFieldDidChange() {
        guard let text = userSocialNetworkNameView.textFieldView.textField.text else { return }
        userSocialNetworkNameView.setButton.isEnabled = text.trim().count > 2 || text.isEmpty
        userSocialNetworkNameView.textFieldView.errorText = userSocialNetworkNameView.setButton.isEnabled ? nil : Constants.ErrorTitle.socialUserNameError
    }
    
    @objc private func themeTextFieldDidChange() {
        guard let text = themeTextFieldWithDropDownView.textFieldView.textField.text else { return }
        themeTextFieldWithDropDownView.setButton.isEnabled = text.trim().count > 2 || text.isEmpty
        themeTextFieldWithDropDownView.textFieldView.errorText = themeTextFieldWithDropDownView.setButton.isEnabled ? nil : Constants.ErrorTitle.themeNameError

        if text.count == 0 {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    @objc private func userNameTextFieldDidChange() {
        updateSaveButtonState()
    }
    
    @objc private func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        hideAllVisibleViews()
        
        picker.pickImage(self, with: .circular) { [weak self] images, _ in
            guard let self = self else { return }
            if let image = images.first {
                guard let imageData = image.compressTo() else {
                    self.showMessage(message: "Invalid image format")
                    return
                }
                self.avatarImageView.image = image
                self.editedAvatarImage = imageData
                self.updateSaveButtonState()
            }
        }
    }
    
    private func updateSaveButtonState() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        saveChangesButton.isEnabled = !(
            userNameTextFieldView.textField.text == currentUser.userName
            && bioTextView.text == currentUser.bio
            && localUser?.twitterUserName == currentUser.twitterUserName
            && localUser?.instagramUserName == currentUser.instagramUserName
            && localUser?.tikTokUserName == currentUser.tikTokUserName
            && localUser?.facebookUserName == currentUser.facebookUserName
            && editedAvatarImage == nil
            && localUser?.firstTheme == currentUser.firstTheme
            && localUser?.secondTheme == currentUser.secondTheme
            && localUser?.thirdTheme == currentUser.thirdTheme
        )
    }
    
    private func setSocialNetworkButtonsImagesState() {
        let twitterUserName = localUser?.twitterUserName
        let instagramUserName = localUser?.instagramUserName
        let tikTokUserName = localUser?.tikTokUserName
        let facebookUserName = localUser?.facebookUserName
        twitterButton.setImage(UIImage(named: twitterUserName != nil && twitterUserName != "" ? "twitterSelected" : "twitter"), for: .normal)
        instagramButton.setImage(UIImage(named: instagramUserName != nil && instagramUserName != "" ? "instagramSelected" : "instagram"), for: .normal)
        tikTokButton.setImage(UIImage(named: tikTokUserName != nil && tikTokUserName != "" ? "tikTokSelected" : "tikTok"), for: .normal)
        facebookButton.setImage(UIImage(named: facebookUserName != nil && facebookUserName != "" ? "facebookSelected" : "facebook"), for: .normal)
    }
    
    private func setThemeButtonsNames() {
        let firstTheme = localUser?.firstTheme
        let secondTheme = localUser?.secondTheme
        let thirdTheme = localUser?.thirdTheme
        themeButtonsView.firstThemeButton.setTitle(firstTheme != nil && firstTheme != "" ? localUser?.firstTheme : "Add+", for: .normal)
        themeButtonsView.secondThemeButton.setTitle(secondTheme != nil && secondTheme != "" ? localUser?.secondTheme : "Add+", for: .normal)
        themeButtonsView.thirdThemeButton.setTitle(thirdTheme != nil && thirdTheme != "" ? localUser?.thirdTheme : "Add+", for: .normal)
    }
    
    private func setSocialNetworkButtonsImagesStateOrThemeButtonsNames() {
        switch visibleViewType {
        case .userSocialNameView:
            setSocialNetworkButtonsImagesState()
        case .themeView:
            setThemeButtonsNames()
        default:
            setSocialNetworkButtonsImagesState()
            setThemeButtonsNames()
        }
    }
    
    private func addGestureRecognizers() {
        let tapGestureRecognizerForAvatarView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapGestureRecognizerForEditView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapGestureRecognizerForScreenView = UITapGestureRecognizer(target: self, action: #selector(hideAllVisibleViews))
        
        avatarImageView.isUserInteractionEnabled = true
        editImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizerForAvatarView)
        editImageView.addGestureRecognizer(tapGestureRecognizerForEditView)
        view.addGestureRecognizer(tapGestureRecognizerForScreenView)
    }
    
    private func fetchUserData() {
        guard let user = AccountManager.shared.user else { return }
        showLoader()
        
        FirestoreAPI.shared.getUserData(userId: user.uid) { [weak self] user, error in
            guard let self = self else { return }
			self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
                self.localUser = user?.copy()
                self.setupUserData()
            }
        }
    }
    
    private func setupUserData() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        userNameTextFieldView.textField.text = currentUser.userName
        bioTextView.text = currentUser.bio
        localUser?.twitterUserName = currentUser.twitterUserName
        localUser?.instagramUserName = currentUser.instagramUserName
        localUser?.tikTokUserName = currentUser.tikTokUserName
        localUser?.facebookUserName = currentUser.facebookUserName
        localUser?.firstTheme = currentUser.firstTheme
        localUser?.secondTheme = currentUser.secondTheme
        localUser?.thirdTheme = currentUser.thirdTheme

        editedAvatarImage = nil
        
        if let avatarUrl = currentUser.avatarImageUrl {
            avatarImageView.sd_setImage(with: URL(string: avatarUrl))
        }
        
        setSocialNetworkButtonsImagesStateOrThemeButtonsNames()
        updateSaveButtonState()
    }
    
    private func setupSocialNetworkUserNameOrTheme() {
        switch visibleViewType {
        case .userSocialNameView:
            setupSocialNetworkUserName()
        case .themeView:
            setupTheme()
        default:
            return
        }
    }
    
    private func setupSocialNetworkUserName() {
        switch socialNetworkType {
        case .twitter:
            userSocialNetworkNameView.textFieldView.textField.text = localUser?.twitterUserName
        case .instagram:
            userSocialNetworkNameView.textFieldView.textField.text = localUser?.instagramUserName
        case .tikTok:
            userSocialNetworkNameView.textFieldView.textField.text = localUser?.tikTokUserName
        case .facebook:
            userSocialNetworkNameView.textFieldView.textField.text = localUser?.facebookUserName
        default:
            break
        }
        userSocialNetworkNameView.textFieldView.errorText = nil
    }
    
    private func setupTheme() {
        switch themeButtonsView.numberOfTheme {
        case .firstTheme:
            themeTextFieldWithDropDownView.textFieldView.textField.text = localUser?.firstTheme
        case .secondTheme:
            themeTextFieldWithDropDownView.textFieldView.textField.text = localUser?.secondTheme
        case .thirdTheme:
            themeTextFieldWithDropDownView.textFieldView.textField.text = localUser?.thirdTheme
        default:
            break
        }
        themeTextFieldWithDropDownView.textFieldView.errorText = nil
    }
    
    private func saveUserDataChanges() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        currentUser.bio = bioTextView.text
        currentUser.userName = userNameTextFieldView.textField.text ?? ""
        currentUser.twitterUserName = localUser?.twitterUserName
        currentUser.instagramUserName = localUser?.instagramUserName
        currentUser.tikTokUserName = localUser?.tikTokUserName
        currentUser.facebookUserName = localUser?.facebookUserName
        currentUser.firstTheme = localUser?.firstTheme
        currentUser.secondTheme = localUser?.secondTheme
        currentUser.thirdTheme = localUser?.thirdTheme

        if editedAvatarImage == nil {
            FirestoreAPI.shared.saveUserData(user: currentUser) { [weak self] error in
                guard let self = self else { return }
				self.hideLoader()
                if let error = error {
                    self.showMessage(message: error.localizedDescription)
                } else {
                    self.showToast(message: "Profile updated")
//					MixpanelManager.shared.trackEvent(.updateProfile, value: CHAnalyticUser.initFromUser(user: currentUser))
                    self.updateSaveButtonState()
                }
            }
        } else {
            StorageAPI.shared.setProfileImage(profilePicImageData: editedAvatarImage ?? Data(count: 0)) { [weak self] error, url  in
				guard let self = self else { return }
                if let error = error {
                    self.hideLoader()
                    self.showMessage(message: error.localizedDescription)
                } else {
                    currentUser.avatarImageUrl = url
                    FirestoreAPI.shared.saveUserData(user: currentUser) { [weak self] error in
                        guard let self = self else { return }
						self.hideLoader()
                        if let error = error {
                            self.showMessage(message: error.localizedDescription)
                        } else {
                            self.showToast(message: "Profile updated")
//							MixpanelManager.shared.trackEvent(.updateProfile, value: CHAnalyticUser.initFromUser(user: currentUser))
                            self.editedAvatarImage = nil
                            self.updateSaveButtonState()
                        }
                    }
                }
            }
        }
    }
    
    private func clearError() {
        if userNameTextFieldView.textField.isFirstResponder && userNameTextFieldView.errorText != nil {
            userNameTextFieldView.errorText = nil
        }
    }
    
    private func setWhichViewIsVisible() {
        switch visibleViewType {
        case .userSocialNameView:
            userSocialNetworkNameView.isHidden = false
            socialNetworkButtonsStackView.isUserInteractionEnabled = false
            themeTextFieldWithDropDownView.isHidden = true
        case .themeView:
            userSocialNetworkNameView.isHidden = true
            socialNetworkButtonsStackView.isUserInteractionEnabled = true
            themeTextFieldWithDropDownView.isHidden = false
            themeTextFieldWithDropDownView.clearOffensiveWordsEnteredError()
        default:
            userSocialNetworkNameView.isHidden = true
            socialNetworkButtonsStackView.isUserInteractionEnabled = true
            themeTextFieldWithDropDownView.isHidden = true
        }
    }
    
    private func validate() {
        var error = false
        
        let userNameError = Validator.shared.userNameValidated(userNameTextFieldView.textField.text!)
        if userNameError != nil {
            userNameTextFieldView.errorText = userNameError
            error = true
        }
        
        view.endEditing(true)
        if !error {
			showLoader()
            if AccountManager.shared.currentUser?.userName != userNameTextFieldView.textField.text {
                FirestoreAPI.shared.checkUserData(localFieldText: userNameTextFieldView.textField.text ?? "", userFieldName: "userName") { [weak self] (isExist, error) in
                    guard let self else { return }
                    if let error = error {
                        self.hideLoader()
                        self.showMessage(message: error.localizedDescription)
                    } else if isExist {
                        self.hideLoader()
                        self.userNameTextFieldView.errorText = "User name already exist"
                    } else {
                        self.saveUserDataChanges()
                    }
                }
			} else {
				self.saveUserDataChanges()
			}
        }
    }
    
    private func setSocialNetworkUserNameOrThemesChanges() {
        switch visibleViewType {
        case .userSocialNameView:
            setSocialNetworkUserNameOrThemesChanges()
        case .themeView:
            setThemesChanges()
        default:
            return
        }
        
        setSocialNetworkButtonsImagesStateOrThemeButtonsNames()
        updateSaveButtonState()
        hideAllVisibleViews()
    }
    
    private func setSocialNetworkUserNameChanges() {
        guard let text = userSocialNetworkNameView.textFieldView.textField.text else { return }
        switch socialNetworkType {
        case .twitter:
            localUser?.twitterUserName = text.isEmpty ? nil : text
        case .instagram:
            localUser?.instagramUserName = text.isEmpty ? nil : text
        case .tikTok:
            localUser?.tikTokUserName = text.isEmpty ? nil : text
        case .facebook:
            localUser?.facebookUserName = text.isEmpty ? nil : text
        default:
            break
        }
        view.endEditing(true)
    }
    
    private func setThemesChanges() {
        guard let text = themeTextFieldWithDropDownView.textFieldView.textField.text else { return }
        if !OffensiveWords.list.contains(text.lowercased()) {
            switch themeButtonsView.numberOfTheme {
            case .firstTheme:
                localUser?.firstTheme = text.isEmpty ? nil : text
            case .secondTheme:
                localUser?.secondTheme = text.isEmpty ? nil : text
            case .thirdTheme:
                localUser?.thirdTheme = text.isEmpty ? nil : text
            default:
                break
            }
        } else {
            themeTextFieldWithDropDownView.showOffensiveWordsEnteringError(errorIn: "Theme") {
                self.dropDown.show()
                self.view.endEditing(true)
            }
            return
        }
    }
        
    @IBAction func saveChangesBtnClicked(_ sender: Any) {
        validate()
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        clearError()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choseSocialNetwork(_ sender: UIButton) {
        visibleViewType = .userSocialNameView
        setWhichViewIsVisible()

        switch sender {
        case twitterButton:
            socialNetworkType = .twitter
        case instagramButton:
            socialNetworkType = .instagram
        case tikTokButton:
            socialNetworkType = .tikTok
        case facebookButton:
            socialNetworkType = .facebook
        default:
            break
        }
        
        setupSocialNetworkUserNameOrTheme()
        userSocialNetworkNameView.textFieldView.textField.becomeFirstResponder()
    }
    
    private enum VisibleViewType {
        case userSocialNameView
        case themeView
    }
}

extension ProfileSettingsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hideAllVisibleViews()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        newText.count >= bioMaxLenght + 1
            ? showMessage(message: "Description max length is 255 symbols")
            : nil
        return newText.count < bioMaxLenght + 1
    }
}

extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextFieldView.textField {
            bioTextView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }
      
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearError()
        if textField == userNameTextFieldView.textField {
            hideAllVisibleViews()
        } else if textField == themeTextFieldWithDropDownView.textFieldView.textField {
            themeTextFieldWithDropDownView.clearOffensiveWordsEnteredError()
        }
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField == userSocialNetworkNameView.textFieldView.textField {
            return newString.length <= userSocialNetworkNameMaxLenght
        } else if textField == themeTextFieldWithDropDownView.textFieldView.textField {
            return newString.length <= themeMaxLenght
        }
        return true
    }
}

extension ProfileSettingsViewController: SetChangesAndCancelButtonTapDelegate {
    func didTapSetButton() {
        setSocialNetworkUserNameOrThemesChanges()
    }
    
    func didTapCancelButton() {
        hideAllVisibleViews()
    }
}

extension ProfileSettingsViewController: ThemeButtonDelegate {
    func themeButtonTapped() {
        visibleViewType = .themeView
        setWhichViewIsVisible()
        dropDown.show()
        setupSocialNetworkUserNameOrTheme()
        view.endEditing(true)
    }
}
