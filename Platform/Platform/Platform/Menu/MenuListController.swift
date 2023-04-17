//
//  SecondViewController.swift
//  sideMenuTest
//
//  Created by 12345 on 13.09.2022.
//

import UIKit
import MessageUI

class MenuListController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewConfigurations()
    }
    override func prepareUI() {
        view.setCorners(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: Constants.MenuListController.menuCornerRadius)
    }
    
    private func moveToSupportScreen(with item: MenuItems) {
        guard let item = item as? SupportItems else { return }
        let webVC = WebViewController()
        webVC.setUrl(url: item == .privacyPolicy
                        ? Constants.URLs.privacyPolicy
                        : Constants.URLs.termsOfUse)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func moveToAccountScreen(with item: MenuItems) {
        guard let item = item as? AccountItems else { return }
        switch item {
        case .profileSettings:
            navigationController?.pushViewController(ProfileSettingsViewController(), animated: true)
        case .personalInfo:
            navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
        case .shippingInfo:
            navigationController?.pushViewController(ShippingInfoViewController(), animated: true)
        case .interests:
            let interestVC = InterestsViewController()
            interestVC.state = .account
            navigationController?.pushViewController(interestVC, animated: true)
        }
    }
    
    private func moveToActionsScreen(with item: MenuItems) {
        guard let item = item as? ActionsItems else { return }
        switch item {
        case .contactUs:
            guard let url = URL(string: Constants.MenuListController.contactUsUrl) else { return }
            //MARK:
            UIApplication.shared.open(url)
        case .reportAConcern:
            let reportVC = ReportViewController()
            navigationController?.pushViewController(reportVC, animated: true)
        case .logOut:
            AccountManager.shared.logout { error in
                self.showMessage(message: error)
            }
        }
    }
    
    private func moveToScreenDependOf(indexPath: IndexPath) {
        guard let section = MenuSections(rawValue: indexPath.section) else { return }
        let item = section.items[indexPath.row]
        switch section {
        case .account:
            moveToAccountScreen(with: item)
        case .support:
            moveToSupportScreen(with: item)
        case .actions:
            moveToActionsScreen(with: item)
        }
    }
    
    func setTableViewConfigurations() {
        menuTableView.register(UINib(nibName: RawTableViewCell.getTheClassName(), bundle: nil),
                               forCellReuseIdentifier: RawTableViewCell.getTheClassName())
        menuTableView.register(UINib(nibName: HeaderTableViewCell.getTheClassName(), bundle: nil),
                               forCellReuseIdentifier: HeaderTableViewCell.getTheClassName())
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
}

extension MenuListController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Use enum for section building
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RawTableViewCell.getTheClassName(), for: indexPath) as! RawTableViewCell // swiftlint:disable:this force_cast
        cell.categoryNameLabel.text = MenuSections(rawValue: indexPath.section)?.items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuSections(rawValue: section)!.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MenuSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.MenuListController.heightOfTableViewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.MenuListController.heightOfTableViewFooter
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.getTheClassName()) as! HeaderTableViewCell // swiftlint:disable:this force_cast
        headerCell.fill(with: MenuSections(rawValue: section)!.title)
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToScreenDependOf(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
//        switch indexPath.section {
//        case 0:
//            if indexPath.row == 0 {
//                navigationController?.pushViewController(ProfileSettingsViewController(), animated: true)
//            } else if indexPath.row == 1 {
//                navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
//            } else if indexPath.row == 2 {
//                navigationController?.pushViewController(ShippingInfoViewController(), animated: true)
//            } else {
//                let interestVC = InterestsViewController()
//                interestVC.state = .account
//                navigationController?.pushViewController(interestVC, animated: true)
//            }
//        case 1:
//            let webVC = WebViewController()
//            webVC.url = indexPath.row == 0
//                ? Constants.URLs.privacyPolicy
//                : Constants.URLs.termsOfUse
//            navigationController?.pushViewController(webVC, animated: true)
//        case 2:
//            if indexPath.row == 0 {
//                if let url = URL(string: "vinilla2@ukr.net") {
//                    UIApplication.shared.open(url)
//                }
//            } else if indexPath.row == 1 {
//                let reportVC = ReportViewController()
//                navigationController?.pushViewController(reportVC, animated: true)
//            } else {
//                AccountManager.shared.logout()
//            }
//        default:
//            return
//        }
    }
}
