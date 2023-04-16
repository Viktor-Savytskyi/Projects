import UIKit
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class PostTableViewCell: UITableViewCell {
	    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    @IBOutlet weak var descriptionLabel: UILabelWithLinks!

    var arrayOfPhotos = [String]()
    var post: Post?
    var moveToPostDetailsCallBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCollectionView()
    }
    
    func setup(with post: Post, and user: CHUser?) {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yy"
        let createDate = formater.string(from: post.createdAt)
        
        if let user {
            let price = "$\(NSNumber(value: post.price ?? 0).description)"
            
            let title = post.isForSale
                ? "\(user.userName) marked \(post.title) for sale for \(price) • \(createDate)"
                : "\(user.userName) added \(post.title) to their collection • \(createDate)"
            
            let stringsForRecolor = post.isForSale
                ?  [user.userName, post.title, price]
                :  [user.userName, post.title]
            
            topTitleLabel.textColor = Constants.Colors.textOnLight.withAlphaComponent(0.4)
            topTitleLabel.setupColorAttributesForText(
                title: title,
                textForRecolor: stringsForRecolor,
                colorForHighlight: Constants.Colors.textOnLight)
            
            if let avatar = user.avatarImageUrl {
                userImageView.sd_setImage(with: URL(string: avatar))
            } else {
                userImageView.image = UIImage(named: "noAvatar")
            }
		} else {
			userImageView.image = UIImage(named: "noAvatar")
			topTitleLabel.text = "No user"
		}
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        descriptionLabel.addTextWithTaggedUsersNames(post.description)
        self.post = post
        setupPhotos(post: post)
        imagesPageControl.numberOfPages = arrayOfPhotos.count
        imagesPageControl.isHidden = arrayOfPhotos.count < 2
        imagesCollectionView.reloadData()
    }
    
    func setupPhotos(post: Post) {
        arrayOfPhotos = []
        arrayOfPhotos.append(post.firstImage.imageUrl)
        if let secondImage = post.secondImage {
            arrayOfPhotos.append(secondImage.imageUrl)
            if let thirdImage = post.thirdImage {
                arrayOfPhotos.append(thirdImage.imageUrl)
            }
        }
    }
    
    func prepareCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: ImagesCollectionViewCell.getTheClassName(), bundle: nil), forCellWithReuseIdentifier: ImagesCollectionViewCell.getTheClassName())
        imagesCollectionView.collectionViewLayout = CustomCollectionViewLayout.createDetailsViewControllerCustomLayout { page in
            self.imagesPageControl.currentPage = page
        }
    }
}

extension PostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.getTheClassName(),
                                                            for: indexPath)
                as? ImagesCollectionViewCell else { return UICollectionViewCell() }
        cell.fill(with: arrayOfPhotos[indexPath.row], isForSale: post?.isForSale ?? false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToPostDetailsCallBack?()
    }
}
