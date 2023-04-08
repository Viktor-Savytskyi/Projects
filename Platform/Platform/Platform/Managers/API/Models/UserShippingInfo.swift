import Foundation

class UserShippingInfo: Codable {
    var streetAddress: String
    var aptSuiteOther: String?
    var city: String
    var state: String
    var shippingZipCode: String
    
    init(streetAddress: String, aptSuiteOther: String? = nil, city: String, state: String, shippingZipCode: String) {
        self.streetAddress = streetAddress
        self.aptSuiteOther = aptSuiteOther
        self.city = city
        self.state = state
        self.shippingZipCode = shippingZipCode
    }
}
