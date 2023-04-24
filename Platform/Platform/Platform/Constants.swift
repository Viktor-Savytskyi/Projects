import Foundation
import UIKit

struct Constants {
    
    struct Colors {
        static let background = UIColor(named: "background")!
        static let buttonBackground = UIColor(named: "buttonBackground")!
        static let secondaryButtonBackground = UIColor(named: "secondaryButtonBackground")!
        static let thirdlyButtonBackground = UIColor(named: "thirdlyButtonBackground")!
        static let textOnLight = UIColor(named: "text")!
		static let green = UIColor(named: "green")!
        static let viewBackground = UIColor(named: "viewBackground")!
        static let viewBackgroundSecond = UIColor(named: "viewBackgroundSecond")!
        static let error = UIColor(named: "error")!
        static let tabBarBackgroundColor = UIColor(named: "tabBarBackgroundColor")!
    }
    
    struct URLs {
        static let privacyPolicy = ""
		static let termsOfUse = ""
		
		static let productionServerUrl = ""
		static let devServerUrl = ""
    }
    
    struct ErrorTitle {
        static let emailError = "Invalid email address"
        static let emailExistError = "This email is already connected to an account.\nPlease log in to your account"
        static let phoneNumberError = "Invalid phone number"
        static let firstNameError = "First name should contain at least 2 symbols and maximum 100"
        static let lastNameError = "Last name should contain at least 2 symbols and maximum 100"
        static let zipCodeError = "Zip code should contain 5 numbers"
        static let userNameError = "Username should contain at least 3 symbols and maximum 100"
        static let passwordError = "Password should contain at least 6 characters at least one number and letter and maximum 100 symbols"
        static let userNameAlreadyExist = "User name already exist"
        static let confirmPasswordError = "Passwords must match"
		static let invalidUrl = "Invalid url"
        static let streetAddressError = "Street address must contain at least 2 symbols and maximum 255"
        static let cityError = "The city name should contain at least 2 symbols and maximum 255"
        static let stateError = "State name should contain at least 2 symbols and maximum 255"
		static let requiredFieldError = "This is a required field"
        static let themeNameError = "Theme should contain at least 3 symbols and maximum 30"
        static let socialUserNameError = "Username should contain at least 2 symbols and maximum 50"
		
		static let cannotPurchasePost = "Post is already sold or not selling anymore"
    }
    
    struct AppOwnerInfo {
        static let id = ""
    }
    
    struct Validator {
        static let minPhoneNumberSymbols = 6
        static let maxPhoneNumberSymbols = 12
        static let minFirstLastLocationNameSymbols = 2
        static let maxFirstLastUserNameSymbols = 100
        static let zipCodeSymbolsCount = 5
        static let minUserNameSymbols = 3
        static let maxLocationSymbols = 255
    }
    
    struct Font {
        static let regularFont = "ABC Marfa Unlicensed Trial"
        static let boldFont = "ABC Marfa Unlicensed Trial Bold"
    }
    
    struct MenuListController {
        static let contactUsUrl = "https://www.google.de/?hl=de"
        static let heightOfTableViewHeader: CGFloat = 40
        static let heightOfTableViewFooter: CGFloat = 20
        static let menuCornerRadius: CGFloat = 70
    }
    
    struct AccountManager {
       static let signOutString = "signing out: %@,"
    }
    
    struct NavigationManager {
        static let tabBarTitleName = ""
        static let tabBarImageNameHome = "home"
        static let tabBarImageNameCreatePost = "add"
        static let tabBarImageNameNotifications = "notifications"
        static let tabBarImageNameProfile = "profile"
    }

    struct ImageUploadManager {
        static let imageFormatError = "Invalid image format"
    }
    
    struct NotificationManager {
        static let badgeValue = "●"
    }
    
    struct NotificationTimer {
        static let timeInterval: Double = 180
    }
    
    struct BuildManager {
        static let cFBundleVersion = "CFBundleVersion"
        static let releaseInfoPlistName = "GoogleService-Prod-Info"
        static let devInfoPlistName = "GoogleService-Dev-Info"
        static let plistType = "plist"
    }
    
    struct MixPanel {
        static let devTypeBuild = "01be9e9e389d22b5ce8372243dd87efa"
        static let releaseTypeBuild = "bb59be2d198b83ad45a316d8058ebf27"
    }
    
    struct DeepLinkManager {
        static let deletedPostMessage = "The post has been removed"
        static let invalidPostLinkMessage = "Invalid post link"
    }
    
    struct Firebase {
        //FireStore
        static let usersCollectionName = "Users"
        static let interestNewCollectionName = "InterestNew"
        static let transactionCollectionName = "Transaction"
        
        static let interestsDocumentName = "Interests"

        static let emailFieldName = "email"
        static let idFieldName = "id"
        static let isDeletedFieldName = "isDeleted"
        static let updatedAtFieldName = "updatedAt"
        static let userIdFieldName = "userId"
        
        // Storage
        static let avatarsStorageKey = "avatars"
        static let postsStorageKey = "posts"
    }
    
    struct InterestsScreen {
        static let searchBarPlaceholder = "Search Categories"
        // register secreen state
        static let topLabelTitleForRegisterState = "Create account"
        static let descriptionForRegisterState = "Tell us what your obsessions are!\nWe’ll be able to show you more of what love."
        // account secreen state
        static let topLabelTitleForAccountState = "What’s your obsession?"
        static let descriptionForAccountState = "Tell us the things you love!"
        static let titleForAccountState = "Interests"
        // create post screen state
        static let topLabelTitleForcCreatePostState = "Where does this go?"
        static let descriptionForCreatePostState = "Tell us what category your item belongs to."
        static let titleForCreatePostState = "Add to Collection"
    }
}
