import UIKit
import SwiftUI
import FirebaseAuth

enum PostImageNumber {
	case first, second, third
}

struct LocalImage {
    var image: UIImage
    var isFromCamera: Bool
	let number: PostImageNumber
}

class CreatePostViewController: BaseViewController {

	@IBOutlet weak var uploadFromCameraView: UploadPhotoView!
	@IBOutlet weak var uploadViewSecond: UploadPhotoView!
	@IBOutlet weak var uploadViewThird: UploadPhotoView!
	@IBOutlet weak var uploadDecriptionLabel: UILabel!
	@IBOutlet weak var titleTextField: AppTextFieldView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var saleStackView: UIStackView!
	@IBOutlet weak var saleSwitch: UISwitch!
	@IBOutlet weak var priceTextFieldView: AppTextFieldView!
    @IBOutlet weak var shippingPriceTextFieldView: AppTextFieldView!
	@IBOutlet weak var btnNext: AppButton!
	@IBOutlet weak var btnCancel: AppButton!
    
    private let picker = ImagePickerController()

	private var editLocalImageFirst: LocalImage?
	private var editLocalImageSecond: LocalImage?
	private var editLocalImageThird: LocalImage?
    private var taggedUserIds = [String]()
    private let maximumSymbolsCountOfPrice = 12
	
	var existingPost: Post?
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarLargeTitle()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        removeNavigationBarLargeTitle()
    }
 
	override func prepareUI() {
		super.prepareUI()
		title = existingPost == nil ? "Add Item" : "Edit item"
		tabBarItem.title = ""
		descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 5
		titleTextField.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		titleTextField.textField.returnKeyType = .next
		titleTextField.textField.delegate = self
		
        descriptionTextView.placeholder = "Description (optional): \n  • What’s its story? \n  • Why do you like it? \n  • Who owned this before you?"
        uploadDecriptionLabel.text = "Required: A verification photo of the item via camera capture to validate condition of item & presence of user."
		titleTextField.placeholder = "Title"
		titleTextField.textField.backgroundColor = .white
		priceTextFieldView.textField.backgroundColor = .white
		priceTextFieldView.placeholder = "Price"
		priceTextFieldView.textField.keyboardType = .decimalPad
		priceTextFieldView.textField.leftViewMode = .always
        priceTextFieldView.textField.delegate = self
        priceTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        shippingPriceTextFieldView.textField.backgroundColor = .white
        shippingPriceTextFieldView.placeholder = "Shipping Costs"
        shippingPriceTextFieldView.textField.keyboardType = .decimalPad
        shippingPriceTextFieldView.textField.leftViewMode = .always
        shippingPriceTextFieldView.textField.delegate = self
        shippingPriceTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

		btnCancel.isHidden = (navigationController?.viewControllers ?? []).count == 1
		picker.cropStyle = .default
        uploadViewSecond.waterMarkImageView.isHidden = true
        uploadViewThird.waterMarkImageView.isHidden = true
		
        if let existingPost, existingPost.saleStatus?.buyerId == nil {
         let deleteBarButtonView = createCustomViewForBarButton(imageName: "deletePost", action: #selector(deletePost))
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteBarButtonView)
		}
        
        preapareUploadingViews()
        
		if let existingPost = existingPost {
			filWithExistedPost(post: existingPost)
		} else {
			cleanFields()
		}
	}
    
    private func preapareUploadingViews() {
        uploadFromCameraView.onCliked = {  [weak self] in
            guard let self = self else { return }
#if targetEnvironment(simulator)
            self.picker.pickImage(self, with: .default) { listImages, _ in
                if let image = listImages.first {
                    self.uploadFromCameraView.image = image
                    self.editLocalImageFirst = LocalImage(image: image, isFromCamera: true, number: .first)
                    self.updateButtonsVisability()
                    self.uploadFromCameraView.waterMarkImageView.isHidden = false
                }
            }
#else
            self.picker.getImageFromCamera(self) { listImages, isFromCamera in
                if let image = listImages.first {
                    self.uploadFromCameraView.image = image
                    self.editLocalImageFirst = LocalImage(image: image, isFromCamera: true, number: .first)
                    self.updateButtonsVisability()
                    self.uploadFromCameraView.waterMarkImageView.isHidden = !isFromCamera
                }
            }
#endif
        }
        uploadViewSecond.onCliked = {  [weak self] in
            guard let self = self else { return }
            self.picker.pickImage(self, with: .default) { listImages, isFromCamera in
                if let image = listImages.first {
                    self.uploadViewSecond.image = image
                    self.editLocalImageSecond = LocalImage(image: image, isFromCamera: isFromCamera, number: .second)
                    self.updateButtonsVisability()
                }
            }
        }
        uploadViewThird.onCliked = {  [weak self] in
            guard let self = self else { return }
            self.picker.pickImage(self, with: .default) { listImages, isFromCamera in
                if let image = listImages.first {
                    self.uploadViewThird.image = image
                    self.editLocalImageThird = LocalImage(image: image, isFromCamera: isFromCamera, number: .third)
                    self.updateButtonsVisability()
                }
            }
        }
    }
	
	private func updateButtonsVisability() {
        guard let priceText = priceTextFieldView.textField.text,
              let shippingText = shippingPriceTextFieldView.textField.text else { return }

		btnNext.isEnabled = (editLocalImageFirst != nil || existingPost != nil)
			&& !titleTextField.textField.text!.isEmpty
			&& (saleSwitch.isOn
                ? !priceText.isEmpty && priceText.doubleValue != nil
				: true)
            && (saleSwitch.isOn
                ? !shippingText.isEmpty && shippingText.doubleValue != nil
                : true)
        
		uploadViewSecond.isActive = editLocalImageFirst != nil || existingPost != nil
		uploadViewThird.isActive = editLocalImageSecond != nil || existingPost?.secondImage != nil
		uploadViewSecond.alpha = uploadViewSecond.isActive ? 1 : 0.65
		uploadViewThird.alpha = uploadViewThird.isActive ? 1 : 0.65
		saleStackView.isHidden = !saleSwitch.isOn
	}
	
	func cleanFields() {
		editLocalImageFirst = nil
		editLocalImageSecond = nil
		editLocalImageThird = nil
		
		uploadFromCameraView.waterMarkImageView.isHidden = true
		uploadViewSecond.waterMarkImageView.isHidden = true
		uploadViewThird.waterMarkImageView.isHidden = true
		
		uploadFromCameraView.image = UIImage(named: "uploadPhotoFromCamera")
		let uploadPhoto = UIImage(named: "uploadPhoto")
		uploadViewSecond.image = uploadPhoto
		uploadViewThird.image = uploadPhoto
		
		titleTextField.textField.text = ""
		descriptionTextView.text = ""
		priceTextFieldView.textField.text = ""
		shippingPriceTextFieldView.textField.text = ""
		saleSwitch.isOn = false
		updateButtonsVisability()
	}
	
	func filWithExistedPost(post: Post) {
		editLocalImageFirst = nil
		editLocalImageSecond = nil
		editLocalImageThird = nil
		
        uploadFromCameraView.imgView.sd_setImage(with: URL(string: post.firstImage.imageUrl))
		uploadFromCameraView.waterMarkImageView.isHidden = !post.firstImage.isFromCamera
        
		if let secondImage = post.secondImage {
            uploadViewSecond.imgView.sd_setImage(with: URL(string: secondImage.imageUrl))
			uploadViewSecond.waterMarkImageView.isHidden = !secondImage.isFromCamera
        }
        
		if let thirdImage = post.thirdImage {
            uploadViewThird.imgView.sd_setImage(with: URL(string: thirdImage.imageUrl))
			uploadViewThird.waterMarkImageView.isHidden = !thirdImage.isFromCamera
		}
		
        uploadFromCameraView.isUserInteractionEnabled = false
        uploadFromCameraView.alpha = 0.5
        uploadDecriptionLabel.setupColorAttributesForText(title: "Verification photo can not be changed.", textForRecolor: ["verification"], colorForHighlight: Constants.Colors.green)
		titleTextField.textField.text = post.title
		descriptionTextView.text = reedDescription(post.description)
		if post.isForSale {
			let price = post.price ?? 0
			let shippingPrice = post.shippingPrice ?? 0
			priceTextFieldView.textField.text = "\(NSNumber(value: price).description)"
            shippingPriceTextFieldView.textField.text = "\(NSNumber(value: shippingPrice).description)"
            priceTextFieldView.textField.addPermanentSymbolOnLeft(symbol: "  $")
            shippingPriceTextFieldView.textField.addPermanentSymbolOnLeft(symbol: "  $")
		} else {
			priceTextFieldView.textField.text = ""
            priceTextFieldView.textField.text = ""
		}
		
		saleSwitch.isOn = post.isForSale
		btnNext.setTitle("Save Changes", for: .normal)
		updateButtonsVisability()
	}
    
    private func setupDescription(_ description: String?) -> String {
        taggedUserIds = []
        if var description = description, let users = UsersStorage.shared.users {
            users.forEach {
                let taggedUserName = "@\($0.userName)"
                if description.contains(taggedUserName) {
                    taggedUserIds.append($0.id)
                    description = description.replacingOccurrences(of: taggedUserName, with: "@\($0.id)")
                }
            }
            return description
        } else {
            return ""
        }
    }
    
    private func reedDescription(_ description: String?) -> String? {
        if var description {
            UsersStorage.shared.users?.forEach({
                let taggedUserId = "@\($0.id)"
                if description.contains(taggedUserId) {
                    description = description.replacingOccurrences(of: taggedUserId, with: "@\($0.userName)")
                }
            })
            return description
        }
        return nil
    }
	
	@objc func textFieldDidChange(_ textField: UITextField) {
        addOrHideDolarSymbol(textField: textField)
		updateButtonsVisability()
	}
	
	@objc func deletePost() {
		let popupVC = ConfirmationPopupViewController()
		popupVC.onDelete = { [weak self] in
			guard let self, let existingPost = self.existingPost, let postId = existingPost.id else { return }
			self.showLoader()
			FirestoreAPI.shared.getPostById(postId: postId) { post, error in
				if let error {
					self.hideLoader()
					self.showMessage(message: error.localizedDescription)
				} else if let post {
					guard post.saleStatus?.buyerId == nil else {
						self.hideLoader()
						self.showMessage(message: "Can`t delete post because of sale status")
						AccountManager.shared.shouldUpdateHomeScreenOnAppear = true
						return
					}
					post.deletedAt = Date()
					post.isDeleted = true
					FirestoreAPI.shared.editPost(post: post) { error in
						self.hideLoader()
						if let error {
							self.showMessage(message: error.localizedDescription)
						} else {
							self.onUpdatedPost(post: post, shouldTrackMarkForSale: false)
						}
					}
				}
			}
		}
		popupVC.modalPresentationStyle = .overFullScreen
		present(popupVC, animated: true)
	}
    
    private func addOrHideDolarSymbol(textField: UITextField) {
        if textField == priceTextFieldView.textField {
            if !textField.text!.isEmpty {
                priceTextFieldView.textField.addPermanentSymbolOnLeft(symbol: "  $")
            } else {
                priceTextFieldView.textField.leftView = nil
            }
        } else if textField == shippingPriceTextFieldView.textField {
            if !textField.text!.isEmpty {
                shippingPriceTextFieldView.textField.addPermanentSymbolOnLeft(symbol: "  $")
            } else {
                shippingPriceTextFieldView.textField.leftView = nil
            }
        }
    }
	
	private func createPost() {
        let price = priceTextFieldView.textField.text!.doubleValue
        let shippingPrice = shippingPriceTextFieldView.textField.text!.doubleValue
        let post = Post(firstImage: ImageWithStatus.init(imageUrl: "", isFromCamera: false),
                        secondImage: nil,
                        thirdImage: nil,
						title: titleTextField.textField.text!,
						description: setupDescription(descriptionTextView.text),
                        isForSale: saleSwitch.isOn,
                        price: price,
                        shippingPrice: shippingPrice,
                        userId: Auth.auth().currentUser?.uid ?? "",
                        interestCodes: [],
                        saleStatus: saleSwitch.isOn ? PostSaleStatus() : nil,
                        taggedUserIds: taggedUserIds)
        
        guard let currentUser = AccountManager.shared.currentUser else { return }
        if currentUser.selectedInterestCodes == nil
            || currentUser.selectedInterestCodes == []
            || currentUser.firstTheme == nil && currentUser.secondTheme == nil && currentUser.thirdTheme == nil {
            
            let interestVC = InterestsViewController()
            interestVC.state = .postCreate
			interestVC.post = post
			interestVC.editLocalImageFirst = editLocalImageFirst
			interestVC.editLocalImageSecond = editLocalImageSecond
			interestVC.editLocalImageThird = editLocalImageThird
            navigationController?.pushViewController(interestVC, animated: true)
        } else {
			let postInterestsAndThemesVC = PostInterestsAndThemesViewController()
			postInterestsAndThemesVC.post = post
			postInterestsAndThemesVC.editLocalImageFirst = editLocalImageFirst
			postInterestsAndThemesVC.editLocalImageSecond = editLocalImageSecond
			postInterestsAndThemesVC.editLocalImageThird = editLocalImageThird
            navigationController?.pushViewController(postInterestsAndThemesVC, animated: true)
        }
	}
	
	private func sendChanges(existingPost: Post, shouldTrackMarkForSale: Bool) {
		FirestoreAPI.shared.editPost(post: existingPost) { [weak self] _ in
			guard let self = self else { return }
			self.hideLoader()
			self.onUpdatedPost(post: existingPost, shouldTrackMarkForSale: shouldTrackMarkForSale)
		}
	}
	
	private func onUpdatedPost(post: Post, shouldTrackMarkForSale: Bool) {
//		MixpanelManager.shared.trackEvent(.updatePost, value: MixpanelPost.initFromPost(post: post))
		if shouldTrackMarkForSale {
//			MixpanelManager.shared.trackEvent(.markedForSale, value: post.id ?? "")
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			if let createPostVC = self.navigationController?.viewControllers.first as? CreatePostViewController {
				createPostVC.cleanFields()
			}
			self.navigationController?.popToRootViewController(animated: true)
		}
	}
    
	private func updatePost() {
		guard let existingPost = existingPost else { return }
		existingPost.updatedAt = Date()
		existingPost.title = titleTextField.textField.text!
        existingPost.description = setupDescription(descriptionTextView.text)
        existingPost.taggedUserIds = taggedUserIds
        
		let shouldTrackMarkForSale = !existingPost.isForSale && existingPost.isForSale != saleSwitch.isOn
		existingPost.isForSale = saleSwitch.isOn
        let price = priceTextFieldView.textField.text!.doubleValue
		existingPost.price = price
        let shippingPrice = shippingPriceTextFieldView.textField.text!.doubleValue
		existingPost.shippingPrice = shippingPrice
		
        ImageUploadManager.shared.setupDelegates(self)

		let imagesArray = [editLocalImageFirst, editLocalImageSecond, editLocalImageThird].compactMap { $0 }
		if !imagesArray.isEmpty {
			ImageUploadManager.shared.uploadImages(post: existingPost,
                                                   editLocalImageFirst: editLocalImageFirst,
                                                   editLocalImageSecond: editLocalImageSecond,
                                                   editLocalImageThird: editLocalImageThird) { [weak self] (error, _)  in
                    self?.showMessage(message: "Invalid second image format")
                
				guard let self = self else { return }
				if let error = error {
					self.showMessage(message: error.localizedDescription)
				} else {
					self.sendChanges(existingPost: existingPost, shouldTrackMarkForSale: shouldTrackMarkForSale)
				}
			}
		} else {
			showLoader()
            sendChanges(existingPost: existingPost, shouldTrackMarkForSale: shouldTrackMarkForSale)
		}
	}
    
    private func priceValidation(fullPriceText: String, _ range: NSRange, inputedSymbol: String) -> Bool {
		guard let updatedString = (fullPriceText as NSString?)?.replacingCharacters(in: range, with: inputedSymbol) else { return false }
		
		if updatedString.isEmpty {
			return true
		}
        
        if updatedString.count > maximumSymbolsCountOfPrice || !CharacterSet(charactersIn: "1234567890.,").isSuperset(of: CharacterSet(charactersIn: inputedSymbol)) {
            return false
		} else {
			return updatedString.doubleValue != nil
        }
    }
    
	@IBAction func btnNextClicked(_ sender: UIButton) {
		if titleTextField.textField.text!.count > 100 {
			showMessage(message: "Title max length is 100 symbols")
			return
		}
		if descriptionTextView.text!.count > 255 {
			showMessage(message: "Description max length is 255 symbols")
			return
		}
		if let postId = existingPost?.id {
			FirestoreAPI.shared.getPostById(postId: postId) { [weak self] post, error in
				guard let self = self else { return }
				self.hideLoader()
				if let error {
					self.showMessage(message: error.localizedDescription)
				} else if let post {
					guard post.saleStatus?.buyerId == nil else {
						self.hideLoader()
						self.showMessage(message: "Can`t update post because of sale status") { _ in
							self.navigationController?.popViewController(animated: true)
						}
						return
					}
					self.updatePost()
				}
			}
		} else {
			createPost()
		}
	}
	
	@IBAction func btnCancelClicked(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func saleSwitchChanged(_ sender: UISwitch) {
		saleStackView.isHidden = !sender.isOn
		if !sender.isOn {
			shippingPriceTextFieldView.textField.text = ""
			priceTextFieldView.textField.text = ""
		}
		updateButtonsVisability()
	}
}

extension CreatePostViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		updateButtonsVisability()
	}
}

extension CreatePostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextField.textField == textField {
            descriptionTextView.becomeFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != titleTextField.textField {
            return priceValidation(fullPriceText: textField.text ?? "", range, inputedSymbol: string)
        }
        return true
    }
}

extension CreatePostViewController: ScreenLoaderDelegate, ScreenAlertDelegate {
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
