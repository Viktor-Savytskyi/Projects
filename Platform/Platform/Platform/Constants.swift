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
        
        static let privacyPolicy = "https://app.termly.io/document/privacy-policy/78771e12-62c0-48ac-b353-90a035461051"
		static let termsOfUse = "https://app.termly.io/document/terms-of-use-for-online-marketplace/d8fb3533-441d-478b-b094-98d209d64f04"
		
		static let productionServerUrl = "https://choosii-staging.vcdev.me"
		static let devServerUrl = "https://choosii.vcdev.me"
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
        static let id = "FrPITBNjbXT9kigW9s0bhDg4Grg1"
    }
}
