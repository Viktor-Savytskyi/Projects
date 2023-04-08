//
//  PostTableViewCell.swift
//  Choosi
//
//  Created by Developer on 09.09.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class PostTableViewCell: UITableViewCell {
	
	static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstForSaleMark: UIImageView!
    @IBOutlet weak var secondForSaleMark: UIImageView!
    @IBOutlet weak var thirdForSaleMark: UIImageView!

    func setup(with post: Post, and user: CHUser?) {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yy"
        let createDate = formater.string(from: post.createdAt)
        
        if let user {
			topTitleLabel.textColor = Constants.Colors.textOnLight.withAlphaComponent(0.4)
            topTitleLabel.setupColorAttributesForText(
               title: "\(user.userName) added \(post.title) to their collection • \(createDate)",
                textForRecolor: [user.userName, post.title],
                colorForHighlight: Constants.Colors.textOnLight)
            
            if let avatar = user.avatarImageUrl {
                userImageView.sd_setImage(with: URL(string: avatar))
            } else {
                userImageView.image = UIImage(named: "noAvatar")
            }
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        descriptionLabel.text = post.description
        
        firstForSaleMark.isHidden = true
        secondForSaleMark.isHidden = true
        thirdForSaleMark.isHidden = true
        
        secondImageView.isHidden = post.secondImage == nil
        thirdImageView.isHidden = post.thirdImage == nil
        
        firstImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        firstImageView.sd_setImage(with: URL(string: post.firstImage.imageUrl)) { _, _, _, _ in
            self.firstForSaleMark.isHidden = !post.isForSale
        }
       
        if let secondImage = post.secondImage {
            secondImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            secondImageView.sd_setImage(with: URL(string: secondImage.imageUrl))
            secondForSaleMark.isHidden = !post.isForSale
        }
        if let thirdImage = post.thirdImage {
            thirdImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            thirdImageView.sd_setImage(with: URL(string: thirdImage.imageUrl))
            thirdForSaleMark.isHidden = !post.isForSale
        }
        
        firstImageView.setCorners(radius: 20)
        secondImageView.setCorners(radius: 20)
        thirdImageView.setCorners(radius: 20)
    }
}
