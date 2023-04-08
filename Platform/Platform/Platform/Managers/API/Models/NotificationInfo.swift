import Foundation

class NotificationInfo: Codable {
    
    let userId: String
    var date: Date
    
    required init(userId: String, date: Date = Date()) {
        self.userId = userId
        self.date = date
    }
    
    enum CodingKeys: CodingKey {
        case userId
        case date
    }
    
    required init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        userId = try value.decode(String.self, forKey: .userId)
        let likeTimeInterval = try value.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: likeTimeInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
    }
}
