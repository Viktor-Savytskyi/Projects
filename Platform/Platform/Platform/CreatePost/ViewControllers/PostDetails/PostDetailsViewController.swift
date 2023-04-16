import UIKit
import SDWebImage
import FirebaseAuth

class PostDetailsViewController: BaseViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var numberInsideHeartLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabelWithLinks!
    @IBOutlet weak var seeMoreOrLessButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var forShippingLabel: UILabel!
    @IBOutlet weak var buyItButton: AppButton!
    @IBOutlet weak var saveToWishListOrEditPostButton: AppButton!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var featureComingSoonWithArrow: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var shippingStackView: UIStackView!
    @IBOutlet weak var infoForUserStackView: UIStackView!
    @IBOutlet weak var shippingInfoRequiredLabel: UILabel!
    
    var post: Post?
	var owner: CHUser?
    var arrayOfPhotos: [ImageWithStatus] = []
    var fullDescriptionIsHidden = true
    var postIsLiked = false
    var postType: PostType?
    var saleStatus: SaleStatus = .new

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPostOwnerData()
        setCollectionViewConfigurations()
        addGestureRecognizers()
    }
    
    override func prepareUI() {
        super.prepareUI()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        heartImageView.layer.cornerRadius = heartImageView.frame.width / 2
        ratingView.setCorners(radius: ratingView.frame.height / 2)
        ratingView.setBorder()
        ratingView.ratingView.settings.updateOnTouch = false
        buyItButton.backgroundColor = Constants.Colors.thirdlyButtonBackground
        buyItButton.tintColor = Constants.Colors.viewBackground
        saveToWishListOrEditPostButton.backgroundColor = Constants.Colors.thirdlyButtonBackground
        saveToWishListOrEditPostButton.tintColor = Constants.Colors.viewBackground
        buttonsStackView.isHidden = true
        forShippingLabel.isHidden = true
        showInfoForUserFirstTime(isFirstTime: false)
        shippingInfoRequiredLabel.isHidden = true
        shippingInfoRequiredLabel.setUnderlinedText()
        
        // for deleting
        ratingView.alpha = 0
        featureComingSoonWithArrow.isHidden = true
        saveToWishListOrEditPostButton.isEnabled = featureComingSoonWithArrow.isHidden
    }
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationVisible(tabBarIsHidden: true, navigationBarIsHidden: true)
        setScreenStateConfigurations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = false
        UIView.setAnimationsEnabled(false)
    }
    
    private func addGestureRecognizers() {
        let tapGestureForNumberInsideHeartLabel = UITapGestureRecognizer(target: self,
                                                                                   action: #selector(imageTapped(_:)))
        let tapGestureForHeartImageView = UITapGestureRecognizer(target: self,
                                                                           action: #selector(imageTapped(_:)))
        let tapGestureForAvatarImageView = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        let tapGestureRecognizerForRatingView = UITapGestureRecognizer(target: self,
                                                                       action: #selector(ratingTapped))
        let tapGestureForShippingInfoRequiredLabel = UITapGestureRecognizer(target: self,
                                                                            action: #selector(shippingInfoRequiredLabelTaped))
        let tapGestureForShareImageView = UITapGestureRecognizer(target: self,
                                                                           action: #selector(shareImageViewTaped))

        numberInsideHeartLabel.isUserInteractionEnabled = true
        heartImageView.isUserInteractionEnabled = true
        avatarImageView.isUserInteractionEnabled = true
        ratingView.isUserInteractionEnabled = true
        shippingInfoRequiredLabel.isUserInteractionEnabled = true
        shareImageView.isUserInteractionEnabled = true
        numberInsideHeartLabel.addGestureRecognizer(tapGestureForNumberInsideHeartLabel)
        heartImageView.addGestureRecognizer(tapGestureForHeartImageView)
		avatarImageView.addGestureRecognizer(tapGestureForAvatarImageView)
        ratingView.addGestureRecognizer(tapGestureRecognizerForRatingView)
        shippingInfoRequiredLabel.addGestureRecognizer(tapGestureForShippingInfoRequiredLabel)
        shareImageView.addGestureRecognizer(tapGestureForShareImageView)
    }
    
    @objc private func ratingTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        print("rating review taped")
    }
    
    @objc private func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        togglePostLike()
    }
    
	@objc private func avatarTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
		if let id = post?.userId {
			let profileVC = ProfilePageViewController()
			profileVC.userId = id
			navigationController?.pushViewController(profileVC, animated: true)
		}
	}
    
    @objc private func shippingInfoRequiredLabelTaped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let userShippingInfoVC = ShippingInfoViewController()
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(userShippingInfoVC, animated: true)
    }
    
    @objc private func shareImageViewTaped(_ tapGestureRecognizer: UITapGestureRecognizer) {
		guard let post, let postId = post.id else { return }
        share(deepLink: DeepLink(type: .post, value: postId))
//        MixpanelManager.shared.trackEvent(.shareItem, value: MixpanelPost.initFromPost(post: post))
    }
	
    private func setCollectionViewConfigurations() {
        imagesCollectionView.register(UINib(nibName: PostDetailsCollectionViewCell.getTheClassName(), bundle: nil), forCellWithReuseIdentifier: PostDetailsCollectionViewCell.getTheClassName())
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.collectionViewLayout = CustomCollectionViewLayout.createDetailsViewControllerCustomLayout()
    }
    
    private func setScreenStateConfigurations() {
        guard let post = post,
              let currentUser = AccountManager.shared.currentUser else { return }
        priceLabel.isHidden = !post.isForSale
        forShippingLabel.isHidden = !post.isForSale
        buttonsStackView.isHidden = false
		buyItButton.isHidden = currentUser.id == post.userId || !post.isForSale
        
        if !buyItButton.isHidden {
            if post.saleStatus?.saleStatus == .pendingSale {
                setBuyButtonDisabledState()
            } else if currentUser.shippingInfo == nil {
                setBuyButtonDisabledState(isCurrentUserShippingInfoAvailable: false)
            } else if currentUser.shippingInfo != nil {
                buyItButton.isEnabled = true
                buyItButton.backgroundColor = Constants.Colors.thirdlyButtonBackground.withAlphaComponent(1)
                shippingInfoRequiredLabel.isHidden = true
            }
        }
        
        if currentUser.id == post.userId {
            postType = .ownersPost
            featureComingSoonWithArrow.isHidden = true // for deleting
			saveToWishListOrEditPostButton.setTitle("EDIT POST", for: .normal)
           
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75).isActive = true
			saveToWishListOrEditPostButton.isEnabled = post.saleStatus?.buyerId == nil
        } else {
            postType = .otherUserPost
            featureComingSoonWithArrow.isHidden = false // for deleting
            saveToWishListOrEditPostButton.isEnabled = featureComingSoonWithArrow.isHidden // for deleting
            saveToWishListOrEditPostButton.backgroundColor = Constants.Colors.thirdlyButtonBackground.withAlphaComponent(0.5) // for deleting
            if post.isForSale {
                saveToWishListOrEditPostButton.setTitle("SAVE TO\nWISH LIST", for: .normal)
                saveToWishListOrEditPostButton.titleLabel?.lineBreakMode = .byWordWrapping
                saveToWishListOrEditPostButton.titleLabel?.numberOfLines = 2
                saveToWishListOrEditPostButton.titleLabel?.textAlignment = .center
            } else {
                saveToWishListOrEditPostButton.setTitle("SAVE TO WISH LIST", for: .normal)
                buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
                buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
                buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75).isActive = true
            }
        }
    }
    
    private func setBuyButtonDisabledState(isCurrentUserShippingInfoAvailable: Bool = true) {
        buyItButton.isEnabled = false
        buyItButton.backgroundColor = Constants.Colors.thirdlyButtonBackground.withAlphaComponent(0.5)
        
        if isCurrentUserShippingInfoAvailable {
            buyItButton.setTitle("PENDING SALE", for: .disabled)
        } else {
            shippingInfoRequiredLabel.isHidden = false
        }
    }
    
    private func showInfoForUserFirstTime(isFirstTime: Bool) {
        priceStackView.isHidden = isFirstTime
        shippingStackView.isHidden = isFirstTime
        infoForUserStackView.isHidden = !isFirstTime
    }
    
    private func fetchPostOwnerData() {
        guard let postOwnerID = post?.userId else { return }
        showLoader()
        FirestoreAPI.shared.getUserData(userId: postOwnerID) { [weak self] owner, error in
            guard let self = self else { return }
            if let error = error {
				self.hideLoader()
				self.showMessage(message: error.localizedDescription) { _ in
					self.navigationController?.popViewController(animated: true)
				}
            } else {
				if AccountManager.shared.currentUser == nil, let currentUserId = Auth.auth().currentUser?.uid {
					FirestoreAPI.shared.getUserData(userId: currentUserId) { _, error in
						if let error = error {
                            self.hideLoader()
							self.showMessage(message: error.localizedDescription) { _ in
								self.navigationController?.popViewController(animated: true)
							}
						} else {
							self.fillWith(owner: owner)
						}
					}
				} else {
					self.fillWith(owner: owner)
				}
            }
        }
    }
	
	private func fillWith(owner: CHUser?) {
		hideLoader()
		self.owner = owner
		setupPostOwnerData(postOwner: owner)
		fillWithPost()
		setScreenStateConfigurations()
		changeSeeMoreOrLessButtonState()
	}
    
    private func setupPostOwnerData(postOwner: CHUser?) {
        guard let postOwner = postOwner else { return }
        if let avatarUrl = postOwner.avatarImageUrl {
            avatarImageView.sd_setImage(with: URL(string: avatarUrl))
        }
    }
    
    func fillWithPost() {
        guard let currentUser = AccountManager.shared.currentUser, let post = post else { return }
        
        arrayOfPhotos.append(post.firstImage)
        if let secondImage = post.secondImage {
            arrayOfPhotos.append(secondImage)
            if let thirdImage = post.thirdImage {
                arrayOfPhotos.append(thirdImage)
            }
        }
		imagesCollectionView.reloadData()
        postIsLiked = post.likes.contains(where: { $0.userId == currentUser.id })
        heartImageView.image = UIImage(named: postIsLiked ? "heartLiked" : "heart")
        numberInsideHeartLabel.text = "\(post.likes.count)"
        postTitleLabel.text = post.title
        postDescriptionLabel.addTextWithTaggedUsersNames(post.description)
		
        if post.isForSale {
			let price = post.price ?? 0
			let shippingPrice = post.shippingPrice ?? 0
			priceLabel.text = "$ \(NSNumber(value: price).description)"
			shippingPriceLabel.text = "+ $ \(NSNumber(value: shippingPrice).description)"
        }
    }
	
	private func changeSeeMoreOrLessButtonState() {
		seeMoreOrLessButton.isHidden = postDescriptionLabel.actualNumberOfLines() <= 2
		seeMoreOrLessButton.setUnderlinedTitle(title: fullDescriptionIsHidden ? "See more" :  "See less")
		postDescriptionLabel.numberOfLines = fullDescriptionIsHidden ? 2 : 0
	}
    
	private func sendChanges(existingPost: Post, isBuying: Bool = false) {
		guard let postId = existingPost.id else { return }
		showLoader()
        FirestoreAPI.shared.editPost(post: existingPost) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
				self.hideLoader()
                self.showMessage(message: error.localizedDescription)
			} else {
				if isBuying {
					let transaction = Transaction(sellerId: existingPost.userId, buyerId: AccountManager.shared.userId ?? "", postId: postId)
					FirestoreAPI.shared.createTransaction(transaction: transaction) { error in
						if let error = error {
							self.hideLoader()
							self.showMessage(message: error.localizedDescription)
						} else {
							self.hideLoader()
//							MixpanelManager.shared.trackEvent(.buyEvent, value: transaction)
							self.setBuyButtonDisabledState()
						}
					}
				} else {
					self.hideLoader()
//					MixpanelManager.shared.trackEvent(.likePost, value: MixpanelPost.initFromPost(post: existingPost))
					self.numberInsideHeartLabel.text = "\(existingPost.likes.count)"
				}
			}
        }
    }
    
    private func togglePostLike() {
        guard let post = post,
              let currentUser = AccountManager.shared.currentUser else { return }
        
        postIsLiked
            ? (heartImageView.image = UIImage(named: "heart"))
            : (heartImageView.image = UIImage(named: "heartLiked"))
        
        if postIsLiked {
            post.likes.removeAll { $0.userId == currentUser.id }
        } else {
            post.likes.append(NotificationInfo(userId: currentUser.id))
        }
        
        postIsLiked = post.likes.contains(where: { $0.userId == currentUser.id })
        sendChanges(existingPost: post)
    }
    
    @IBAction func backClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeMoreOrLessClick(_ sender: Any) {
        fullDescriptionIsHidden = !fullDescriptionIsHidden
        changeSeeMoreOrLessButtonState()
    }
    
    @IBAction func saveToWishListOrEditPostAction(_ sender: Any) {
        switch postType {
        case .ownersPost:
            let editPostVC = CreatePostViewController()
            editPostVC.existingPost = post
            navigationController?.pushViewController(editPostVC, animated: true)
        case .otherUserPost:
            print("save to wish list")
        default:
            break
        }
    }
    
    @IBAction func buyItClick(_ sender: Any) {
		guard let post, let postId = post.id else { return }
        if buyItButton.currentTitle == "BUY IT" {
//			MixpanelManager.shared.trackEvent(.buyIt, value: BuyIt(postId: post.id ?? "", userId: post.userId))
            buyItButton.setTitle("CONFIRM?", for: .normal)
        } else {
			showLoader()
			FirestoreAPI.shared.getPostById(postId: postId) { [weak self] loadedPost, error in
				guard let self else { return }
				self.hideLoader()
				if let error {
					self.showMessage(message: error.localizedDescription)
				} else if let loadedPost {
					if loadedPost.saleStatus?.buyerId == nil, loadedPost.isForSale {
						post.saleStatus = PostSaleStatus(saleStatus: .pendingSale, buyerId: AccountManager.shared.currentUser?.id)
						self.showInfoForUserFirstTime(isFirstTime: true)
						self.sendChanges(existingPost: post, isBuying: true)
					} else {
						self.showMessage(message: Constants.ErrorTitle.cannotPurchasePost) { _ in
							AccountManager.shared.shouldUpdateHomeScreenOnAppear = true
							self.navigationController?.popViewController(animated: true)
						}
					}
				}
			}
        }
    }
    
// MARK: - Helping structure
    enum PostType {
        case ownersPost
        case otherUserPost
    }
}

extension PostDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: PostDetailsCollectionViewCell.getTheClassName(),
                                 for: indexPath)
                as? PostDetailsCollectionViewCell else { return UICollectionViewCell() }
        
        !(arrayOfPhotos.isEmpty)
            ? cell.fill(with: arrayOfPhotos[indexPath.row], index: indexPath.row, isForSale: post?.isForSale ?? false)
            : nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewImageViewController = PreviewImageViewController()
        previewImageViewController.imageURL = arrayOfPhotos[indexPath.row].imageUrl
        previewImageViewController.modalPresentationStyle = .fullScreen
        present(previewImageViewController, animated: true)
    }
}
