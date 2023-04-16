import Foundation
import UIKit

class UserPostsView: ViewFromXib {
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
        
    var posts: [Post] = []
    let numberOfCellsInRow: CGFloat = 3
    let spaceBetweenCells: CGFloat = 4
    let leftAndRightCollectionViewConstrains: CGFloat = 16 * 2
    var selectPostCallBack: ((Post) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        postsCollectionView.register(UINib(nibName: UserPostsCollectionViewCell.getTheClassName(), bundle: nil), forCellWithReuseIdentifier: UserPostsCollectionViewCell.getTheClassName())
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let postCollectionViewWidth = UIScreen.main.bounds.width - leftAndRightCollectionViewConstrains
        let widthCell = (postCollectionViewWidth / numberOfCellsInRow)
        let heightCell = widthCell * 1.15
        layout.itemSize = .init(width: widthCell - spaceBetweenCells, height: heightCell - spaceBetweenCells)
        layout.minimumInteritemSpacing = spaceBetweenCells
        layout.minimumLineSpacing = spaceBetweenCells
        postsCollectionView!.collectionViewLayout = layout
    }
    
    func setPostsToCollectionView(posts: [Post]?) {
        guard let posts else { return }
        self.posts = posts
        postsCollectionView.reloadData()
    }
}

extension UserPostsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostsCollectionViewCell.getTheClassName(), for: indexPath)
                as? UserPostsCollectionViewCell else { return UserPostsCollectionViewCell() }
        cell.setup(with: posts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPostCallBack?(posts[indexPath.item])
    }
}
