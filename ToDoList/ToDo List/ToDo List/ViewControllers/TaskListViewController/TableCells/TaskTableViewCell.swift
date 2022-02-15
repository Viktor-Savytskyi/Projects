//
//  TaskTableViewCell.swift
//  ToDo List
//
//  Created by 12345 on 09.11.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Task) {
        titleLabel.text = model.title
        
        if model.status == false {
            checkMarkImage.image = .init(systemName: "square")
        } else {
            checkMarkImage.image = .init(systemName: "checkmark.square")
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yy HH:mm a"
        let taskDateString = formater.string(from: model.taskDate)
        let createDateString = formater.string(from: model.createdDate)
        
        createdDateLabel.text = "create day: \(createDateString)"
        startDateLabel.text = "start day: \(taskDateString)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVisualUiConfigurations()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setVisualUiConfigurations() {
        let contentViewFrame = self.contentView.frame
           let insetContentViewFrame = contentViewFrame.inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 1, right: 5))
           self.contentView.frame = insetContentViewFrame
           self.selectedBackgroundView?.frame = insetContentViewFrame
        
        contentView.setCornerRadius(radius: 15)
    }
    
}
