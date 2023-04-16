//
//  SecondViewController.swift
//  sideMenuTest
//
//  Created by 12345 on 13.09.2022.
//

import UIKit
import MessageUI

enum MenuSections: Int, CaseIterable {
    case account
    case support
    case actions

    var title: String {
        switch self {
        case .account:
            return "Account"
        case .support:
            return "Support"
        case .actions:
            return "Actions"
        }
    }
    var items: [String] {
        switch self {
        case .account:
            return ["Profile Settings", "Personal Info", "Shipping Info", "Interests"]
        case .support:
            return ["Privacy Policy", "Terms of Service"]
        case .actions:
            return ["Contact Us", "Report a Concern", "Log out"]
        }
    }
}

class MenuListController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
        
    let heightOfTableViewHeader: CGFloat = 40
    let heightOfTableViewFooter: CGFloat = 20
    let menuCornerRadius: CGFloat = 70
    let email = "https://www.google.de/?hl=de"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewConfigurations()
        setScreenDelegate()

    }
    override func prepareUI() {
        view.setCorners(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: menuCornerRadius)
    }
    
    private func moveToWebViewContorller(index: Int) {
        let webVC = WebViewController()
        webVC.url = index == 0
        ? Constants.URLs.privacyPolicy
        : Constants.URLs.termsOfUse
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func moveToInterestsViewController() {
        let interestVC = InterestsViewController()
        interestVC.state = .account
        navigationController?.pushViewController(interestVC, animated: true)
    }
    
    private func moveToContactUsOrReportViewController(index: Int) {
        if index == 0 {
            guard let url = URL(string: email) else { return }
            UIApplication.shared.open(url)
        } else if index == 1 {
            let reportVC = ReportViewController()
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    private func moveToScreenDependOf(indexPath: IndexPath) {
        guard let section = MenuSections(rawValue: indexPath.section) else { return }
        switch section {
        case .account:
            if indexPath.row == 0 {
                navigationController?.pushViewController(ProfileSettingsViewController(), animated: true)
            } else if indexPath.row == 1 {
                navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
            } else if indexPath.row == 2 {
                navigationController?.pushViewController(ShippingInfoViewController(), animated: true)
            } else if indexPath.row == 3 {
                moveToInterestsViewController()
            }
        case .support:
            moveToWebViewContorller(index: indexPath.row)
        case .actions:
            if indexPath.row == 2 {
                AccountManager.shared.logout()
            } else {
                moveToContactUsOrReportViewController(index: indexPath.row)
            }
        }
    }
    
    private func setScreenDelegate() {
        AccountManager.shared.screenAlertDelegate = self
    }
    
    func setTableViewConfigurations() {
        //MARK: nibName
        menuTableView.register(UINib(nibName: RawTableViewCell.getTheClassName(), bundle: nil),
                               forCellReuseIdentifier: RawTableViewCell.getTheClassName())
        menuTableView.register(UINib(nibName: HeaderTableViewCell.getTheClassName(), bundle: nil),
                               forCellReuseIdentifier: HeaderTableViewCell.getTheClassName())
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
}

extension MenuListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RawTableViewCell.getTheClassName(), for: indexPath) as! RawTableViewCell // swiftlint:disable:this force_cast
        cell.categoryNameLabel.text = MenuSections(rawValue: indexPath.section)?.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuSections(rawValue: section)!.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MenuSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightOfTableViewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightOfTableViewFooter
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.getTheClassName()) as! HeaderTableViewCell // swiftlint:disable:this force_cast
        headerCell.fill(with: MenuSections(rawValue: section)!.title)
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK:  replace switch
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

extension MenuListController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error)
    }
}
