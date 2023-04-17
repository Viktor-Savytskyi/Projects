//
//  MenuListControllerEnum.swift
//  Platform
//
//  Created by 12345 on 17.04.2023.
//

import Foundation

protocol MenuItems {
    var title: String { get }
}

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
    var items: [MenuItems] {
        switch self {
        case .account:
            return [AccountItems.profileSettings, AccountItems.personalInfo, AccountItems.shippingInfo, AccountItems.interests]
        case .support:
            return [SupportItems.privacyPolicy, SupportItems.termsOfService]
        case .actions:
            return [ActionsItems.contactUs, ActionsItems.reportAConcern, ActionsItems.logOut]
        }
    }
}

    enum AccountItems: Int, MenuItems, CaseIterable {
        case profileSettings
        case personalInfo
        case shippingInfo
        case interests
        
        var title: String {
            switch self {
            case .profileSettings:
                return "Profile Settings"
            case .personalInfo:
                return "Personal Info"
            case .shippingInfo:
                return "Shipping Info"
            case .interests:
                return "Interests"
            }
        }
    }
    
    enum SupportItems: Int, MenuItems, CaseIterable {
        case privacyPolicy
        case termsOfService

        var title: String {
            switch self {
            case .privacyPolicy:
                return "Privacy Policy"
            case .termsOfService:
                return "Terms of Service"
            }
        }
    }

    enum ActionsItems: Int, MenuItems, CaseIterable {
        case contactUs
        case reportAConcern
        case logOut

        var title: String {
            switch self {
            case .contactUs:
                return "Contact Us"
            case .reportAConcern:
                return "Report a Concern"
            case .logOut:
                return "Log out"
            }
        }
    }
