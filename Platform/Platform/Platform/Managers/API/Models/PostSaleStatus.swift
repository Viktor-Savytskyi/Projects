import Foundation

enum SaleStatus: String, Codable {
    case new
    case pendingSale
}

class PostSaleStatus: Codable {
    var saleStatus: SaleStatus
    var buyerId: String?
    
    private enum CodingKeys: String, CodingKey {
        case saleStatus, buyerId
    }
    
    init(saleStatus: SaleStatus = .new, buyerId: String? = nil) {
        self.saleStatus = saleStatus
        self.buyerId = buyerId
    }
}
