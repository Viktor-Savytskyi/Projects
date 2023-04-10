//
//  NotificationManagerDelegate.swift
//  Platform
//
//  Created by 12345 on 10.04.2023.
//

import Foundation

protocol NotificationManagerDelegate: AnyObject {
    func reloadData()
    func changeNotificationLabelVisible(isHidden: Bool)
}

extension NotificationManagerDelegate {
    func changeNotificationLabelVisible(isHidden: Bool = true) { }
}
