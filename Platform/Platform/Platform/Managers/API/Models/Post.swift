import Foundation

class Post: Codable {
	var firstImage: ImageWithStatus
	var secondImage: ImageWithStatus?
	var thirdImage: ImageWithStatus?
	var title: String
	var description: String
	var isForSale: Bool
	var price: Double?
    var shippingPrice: Double?
	var createdAt: Date
	var updatedAt: Date
	let userId: String
	var id: String?
	var interestCodes: [String]?
    var likes: [NotificationInfo]
    var themes: [String]?
    var saleStatus: PostSaleStatus?
	var deletedAt: Date?
	var isDeleted: Bool = false
    var taggedUserIds: [String]?
	
    init(firstImage: ImageWithStatus,
         secondImage: ImageWithStatus?,
         thirdImage: ImageWithStatus?,
         title: String,
         description: String,
         isForSale: Bool,
         price: Double?,
         shippingPrice: Double?,
         userId: String,
         interestCodes: [String]?,
         likes: [NotificationInfo] = [],
         themes: [String]? = nil,
         saleStatus: PostSaleStatus?,
		 deletedAt: Date? = nil,
		 isDeleted: Bool = false,
         taggedUserIds: [String] = []) {
		self.firstImage = firstImage
		self.secondImage = secondImage
		self.thirdImage = thirdImage
		self.title = title
		self.description = description
		self.isForSale = isForSale
		self.price = price
        self.shippingPrice = shippingPrice
        self.userId = userId
        self.interestCodes = interestCodes
        self.createdAt = Date()
        self.updatedAt = Date()
        self.likes = likes
        self.themes = themes
        self.saleStatus = saleStatus
		self.deletedAt = deletedAt
		self.isDeleted = isDeleted
        self.taggedUserIds = taggedUserIds
	}

	enum CodingKeys: String, CodingKey {
		case id
		case firstImage
		case secondImage
		case thirdImage
		case title
		case description
		case isForSale
		case price
        case shippingPrice
		case createdAt
		case updatedAt
		case userId
		case interestCodes
        case likes
        case themes
        case saleStatus
		case deletedAt
		case isDeleted
        case taggedUserIds
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		firstImage = try values.decode(ImageWithStatus.self, forKey: .firstImage)
		secondImage = try values.decodeIfPresent(ImageWithStatus.self, forKey: .secondImage)
		thirdImage = try values.decodeIfPresent(ImageWithStatus.self, forKey: .thirdImage)
		title = try values.decode(String.self, forKey: .title)
		description = try values.decode(String.self, forKey: .description)
		isForSale = try values.decode(Bool.self, forKey: .isForSale)
		price = try values.decodeIfPresent(Double.self, forKey: .price)
        shippingPrice = try values.decodeIfPresent(Double.self, forKey: .shippingPrice)
		let timeIntervalUpdateAt = try values.decode(Double.self, forKey: .updatedAt)
		updatedAt = Date(timeIntervalSince1970: timeIntervalUpdateAt)
		let timeIntervalCreateAt = try values.decode(Double.self, forKey: .createdAt)
		createdAt = Date(timeIntervalSince1970: timeIntervalCreateAt)
		userId = try values.decode(String.self, forKey: .userId)
		interestCodes = try values.decodeIfPresent([String].self, forKey: .interestCodes)
		if let likesDecoded = try? values.decodeIfPresent([NotificationInfo].self, forKey: .likes) {
			likes = likesDecoded
		} else {
			let likesDecoded = try? values.decodeIfPresent([String].self, forKey: .likes)
			likes = likesDecoded?.map { NotificationInfo(userId: $0, date: Date(timeIntervalSince1970: 0)) } ?? []
		}
        themes = try values.decodeIfPresent([String].self, forKey: .themes)
        saleStatus = try values.decodeIfPresent(PostSaleStatus.self, forKey: .saleStatus)
        let deleteDate = try values.decodeIfPresent(Double.self, forKey: .deletedAt)
        deletedAt = Date(timeIntervalSince1970: deleteDate ?? 0)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        taggedUserIds = try values.decodeIfPresent([String].self, forKey: .taggedUserIds)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(firstImage, forKey: .firstImage)
		try container.encode(secondImage, forKey: .secondImage)
		try container.encode(thirdImage, forKey: .thirdImage)
		try container.encode(title, forKey: .title)
		try container.encode(description, forKey: .description)
		try container.encode(isForSale, forKey: .isForSale)
		try container.encode(price, forKey: .price)
        try container.encode(shippingPrice, forKey: .shippingPrice)
		try container.encode(updatedAt.timeIntervalSince1970, forKey: .updatedAt)
		try container.encode(createdAt.timeIntervalSince1970, forKey: .createdAt)
		try container.encode(userId, forKey: .userId)
		try container.encode(interestCodes, forKey: .interestCodes)
        try container.encode(likes, forKey: .likes)
        try container.encode(themes, forKey: .themes)
        try container.encode(saleStatus, forKey: .saleStatus)
        try container.encode(deletedAt?.timeIntervalSince1970, forKey: .deletedAt)
		try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(taggedUserIds, forKey: .taggedUserIds)
	}
}

//struct MixpanelPost: Codable {
//	var firstImageUrl: String?
//	var secondImageUrl: String?
//	var thirdImageUrl: String?
//	let title: String
//	let description: String
//	let isForSale: Bool
//	let price: Double?
//	let shippingPrice: Double?
//	let createdAt: Date
//	let updatedAt: Date
//	let userId: String
//	var id: String?
//	let interestCodes: [String]?
//    var likes: [String]?
//	let themes: [String]?
//	let deletedAt: Date?
//	let isDeleted: Bool
//    let taggedUserIds: [String]?
//
//	static func initFromPost(post: Post) -> MixpanelPost? {
//		do {
//			let data = try JSONEncoder().encode(post)
//            let copy = try JSONDecoder().decode(MixpanelPost.self, from: data)
//			return copy
//		} catch {
//			print(error)
//			return nil
//		}
//	}
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstImage
//        case secondImage
//        case thirdImage
//        case title
//        case description
//        case isForSale
//        case price
//        case shippingPrice
//        case createdAt
//        case updatedAt
//        case userId
//        case interestCodes
//        case likes
//        case themes
//        case deletedAt
//        case isDeleted
//        case taggedUserIds
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        firstImageUrl = try values.decode(ImageWithStatus.self, forKey: .firstImage).imageUrl
//        secondImageUrl = try values.decodeIfPresent(ImageWithStatus.self, forKey: .secondImage)?.imageUrl
//        thirdImageUrl = try values.decodeIfPresent(ImageWithStatus.self, forKey: .thirdImage)?.imageUrl
//        title = try values.decode(String.self, forKey: .title)
//        description = try values.decode(String.self, forKey: .description)
//        isForSale = try values.decode(Bool.self, forKey: .isForSale)
//        price = try values.decodeIfPresent(Double.self, forKey: .price)
//        shippingPrice = try values.decodeIfPresent(Double.self, forKey: .shippingPrice)
//        let timeIntervalUpdateAt = try values.decode(Double.self, forKey: .updatedAt)
//        updatedAt = Date(timeIntervalSince1970: timeIntervalUpdateAt)
//        let timeIntervalCreateAt = try values.decode(Double.self, forKey: .createdAt)
//        createdAt = Date(timeIntervalSince1970: timeIntervalCreateAt)
//        userId = try values.decode(String.self, forKey: .userId)
//        interestCodes = try values.decodeIfPresent([String].self, forKey: .interestCodes)
//        likes = try values.decode([NotificationInfo].self, forKey: .likes).map({ $0.userId })
//        themes = try values.decodeIfPresent([String].self, forKey: .themes)
//        let deleteDate = try values.decodeIfPresent(Double.self, forKey: .deletedAt)
//        deletedAt = Date(timeIntervalSince1970: deleteDate ?? 0)
//        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
//        taggedUserIds = try values.decodeIfPresent([String].self, forKey: .taggedUserIds)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(firstImageUrl, forKey: .firstImage)
//        try container.encode(secondImageUrl, forKey: .secondImage)
//        try container.encode(thirdImageUrl, forKey: .thirdImage)
//        try container.encode(title, forKey: .title)
//        try container.encode(description, forKey: .description)
//        try container.encode(isForSale, forKey: .isForSale)
//        try container.encode(price, forKey: .price)
//        try container.encode(shippingPrice, forKey: .shippingPrice)
//        try container.encode(updatedAt.timeIntervalSince1970, forKey: .updatedAt)
//        try container.encode(createdAt.timeIntervalSince1970, forKey: .createdAt)
//        try container.encode(userId, forKey: .userId)
//        try container.encode(interestCodes, forKey: .interestCodes)
//        try container.encode(likes, forKey: .likes)
//        try container.encode(themes, forKey: .themes)
//        try container.encode(deletedAt?.timeIntervalSince1970, forKey: .deletedAt)
//        try container.encode(isDeleted, forKey: .isDeleted)
//        try container.encode(taggedUserIds, forKey: .taggedUserIds)
//    }
//}
