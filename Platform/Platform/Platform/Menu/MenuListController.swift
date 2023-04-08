//
//  SecondViewController.swift
//  sideMenuTest
//
//  Created by 12345 on 13.09.2022.
//

import UIKit
import MessageUI

struct Section {
    var name: String!
    var items: [String]!
    init(name: String, items: [String]) {
        self.name = name
        self.items = items
    }
}

class MenuListController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    let sections = [Section(name: "Account", items: ["Profile Settings", "Personal Info", "Shipping Info", "Interests"]),
                    Section(name: "Support", items: ["Privacy Policy", "Terms of Service"]),
                    Section(name: "Actions", items: ["Contact Us", "Report a Concern", "Log out"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewConfigurations()

    }
    override func prepareUI() {
        view.setCorners(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 70)
    }
    
    func setTableViewConfigurations() {
        menuTableView.register(UINib(nibName: "RawTableViewCell", bundle: nil),
                               forCellReuseIdentifier: RawTableViewCell.identifier)
        menuTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil),
                               forCellReuseIdentifier: HeaderTableViewCell.identifier)
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
}

extension MenuListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RawTableViewCell.identifier, for: indexPath)
                as? RawTableViewCell else { return RawTableViewCell()}
        if indexPath.section == 0 {
            cell.categoryNameLabel.text = sections[0].items[indexPath.row]
        } else if indexPath.section == 1 {
            cell.categoryNameLabel.text = sections[1].items[indexPath.row]
        } else {
            cell.categoryNameLabel.text = sections[2].items[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sections[0].items.count
        } else if section == 1 {
            return sections[1].items.count
        } else {
            return sections[2].items.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
                as? HeaderTableViewCell else { return HeaderTableViewCell() }
        headerCell.fill(with: sections[section])
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                navigationController?.pushViewController(ProfileSettingsViewController(), animated: true)
            } else if indexPath.row == 1 {
                navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
            } else if indexPath.row == 2 {
                navigationController?.pushViewController(ShippingInfoViewController(), animated: true)
            } else {
                let interestVC = InterestsViewController()
                interestVC.state = .account
                navigationController?.pushViewController(interestVC, animated: true)
            }
        case 1:
            let webVC = WebViewController()
            webVC.url = indexPath.row == 0
                ? Constants.URLs.privacyPolicy
                : Constants.URLs.termsOfUse
            navigationController?.pushViewController(webVC, animated: true)
        case 2:
            if indexPath.row == 0 {
                if let url = URL(string: "mailto:team@choosii.us") {
                    UIApplication.shared.open(url)
                }
            } else if indexPath.row == 1 {
                let reportVC = ReportViewController()
                navigationController?.pushViewController(reportVC, animated: true)
            } else {
                AccountManager.shared.logout()
            }
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
