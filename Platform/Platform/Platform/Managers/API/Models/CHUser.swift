import Foundation
import FirebaseFirestore

class CHUser: Codable {
	var id: String
    var email: String
    var phone: String
    var firstName: String
    var lastName: String
    var zipCode: String
    var userName: String
	var selectedInterestCodes: [String]?
    var bio: String?
    var instagramUserName: String?
    var twitterUserName: String?
    var facebookUserName: String?
    var tikTokUserName: String?
    var avatarImageUrl: String?
	var followedUserIds: [NotificationInfo]?
    var followersIds: [NotificationInfo]?
    var firstTheme: String?
    var secondTheme: String?
    var thirdTheme: String?
    var customTree: InterestResponse?
    var shippingInfo: UserShippingInfo?
    var lastTimeNotificationsViewed: Date?

    init(id: String,
         email: String,
         phone: String,
         firstName: String,
         lastName: String,
         zipCode: String,
         userName: String,
         selectedInterestCodes: [String]?,
         bio: String? = "",
         instagramUserName: String? = nil,
         twitterUserName: String? = nil,
         facebookUserName: String? = nil,
         tikTokUserName: String? = nil,
         avatarImageUrl: String? = nil,
         followersIds: [NotificationInfo]? = nil,
         followedUserIds: [NotificationInfo]? = nil,
         firstTheme: String? = nil,
         secondTheme: String? = nil,
         thirdTheme: String? = nil,
         customTree: InterestResponse? = nil,
         shippingInfo: UserShippingInfo? = nil,
         lastTimeNotificationsViewed: Date? = Date()) {
        self.id = id
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.zipCode = zipCode
        self.userName = userName
        self.selectedInterestCodes = selectedInterestCodes
        self.bio = bio
        self.instagramUserName = instagramUserName
        self.twitterUserName = twitterUserName
        self.facebookUserName = facebookUserName
        self.tikTokUserName = tikTokUserName
        self.avatarImageUrl = avatarImageUrl
        self.followedUserIds = followedUserIds
        self.followersIds = followersIds
        self.firstTheme = firstTheme
        self.secondTheme = secondTheme
        self.thirdTheme = thirdTheme
        self.customTree = customTree
        self.shippingInfo = shippingInfo
        self.lastTimeNotificationsViewed = lastTimeNotificationsViewed
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phone
        case firstName
        case lastName
        case zipCode
        case userName
        case selectedInterestCodes
        case bio
        case instagramUserName
        case twitterUserName
        case facebookUserName
        case tikTokUserName
        case avatarImageUrl
        case followedUserIds
        case followersIds
        case firstTheme
        case secondTheme
        case thirdTheme
        case customTree
        case shippingInfo
        case lastTimeNotificationsViewed
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        zipCode = try values.decode(String.self, forKey: .zipCode)
        userName = try values.decode(String.self, forKey: .userName)
        selectedInterestCodes = try values.decodeIfPresent([String].self, forKey: .selectedInterestCodes)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        instagramUserName = try values.decodeIfPresent(String.self, forKey: .instagramUserName)
        twitterUserName = try values.decodeIfPresent(String.self, forKey: .twitterUserName)
        facebookUserName = try values.decodeIfPresent(String.self, forKey: .facebookUserName)
        tikTokUserName = try values.decodeIfPresent(String.self, forKey: .tikTokUserName)
        avatarImageUrl = try values.decodeIfPresent(String.self, forKey: .avatarImageUrl)
		if let followedUserIdsDecoded = try? values.decodeIfPresent([NotificationInfo].self, forKey: .followedUserIds) {
			followedUserIds = followedUserIdsDecoded
		} else {
			let followedUserIdsDecoded = try? values.decodeIfPresent([String].self, forKey: .followedUserIds)
			followedUserIds = followedUserIdsDecoded?.map { NotificationInfo(userId: $0, date: Date(timeIntervalSince1970: 0)) }
		}

		if let followersIdsDecoded = try? values.decodeIfPresent([NotificationInfo].self, forKey: .followersIds) {
			followersIds = followersIdsDecoded
		} else {
			let followersIdsDecoded = try? values.decodeIfPresent([String].self, forKey: .followersIds)
			followersIds = followersIdsDecoded?.map { NotificationInfo(userId: $0, date: Date(timeIntervalSince1970: 0)) }
		}
        firstTheme = try values.decodeIfPresent(String.self, forKey: .firstTheme)
        secondTheme = try values.decodeIfPresent(String.self, forKey: .secondTheme)
        thirdTheme = try values.decodeIfPresent(String.self, forKey: .thirdTheme)
        customTree = try values.decodeIfPresent(InterestResponse.self, forKey: .customTree)
        shippingInfo = try values.decodeIfPresent(UserShippingInfo.self, forKey: .shippingInfo)
        let lastViewedDate = try values.decodeIfPresent(Double.self, forKey: .lastTimeNotificationsViewed)
        lastTimeNotificationsViewed = Date(timeIntervalSince1970: lastViewedDate ?? 0)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(userName, forKey: .userName)
        try container.encode(selectedInterestCodes, forKey: .selectedInterestCodes)
        try container.encode(bio, forKey: .bio)
        try container.encode(instagramUserName, forKey: .instagramUserName)
        try container.encode(twitterUserName, forKey: .twitterUserName)
        try container.encode(facebookUserName, forKey: .facebookUserName)
        try container.encode(tikTokUserName, forKey: .tikTokUserName)
        try container.encode(avatarImageUrl, forKey: .avatarImageUrl)
        try container.encode(followedUserIds, forKey: .followedUserIds)
        try container.encode(followersIds, forKey: .followersIds)
        try container.encode(firstTheme, forKey: .firstTheme)
        try container.encode(secondTheme, forKey: .secondTheme)
        try container.encode(thirdTheme, forKey: .thirdTheme)
        try container.encode(customTree, forKey: .customTree)
        try container.encode(shippingInfo, forKey: .shippingInfo)
        try container.encode(lastTimeNotificationsViewed?.timeIntervalSince1970, forKey: .lastTimeNotificationsViewed)
    }

    func copy(with zone: NSZone? = nil) -> CHUser {
        let copy = CHUser(id: id,
                          email: email,
                          phone: phone,
                          firstName: firstName,
                          lastName: lastName,
                          zipCode: zipCode,
                          userName: userName,
                          selectedInterestCodes: selectedInterestCodes,
                          bio: bio,
                          instagramUserName: instagramUserName,
                          twitterUserName: twitterUserName,
                          facebookUserName: facebookUserName,
                          tikTokUserName: tikTokUserName,
                          avatarImageUrl: avatarImageUrl,
                          followersIds: followersIds,
                          followedUserIds: followedUserIds,
                          firstTheme: firstTheme,
                          secondTheme: secondTheme,
                          thirdTheme: thirdTheme,
                          customTree: customTree,
                          shippingInfo: shippingInfo,
                          lastTimeNotificationsViewed: lastTimeNotificationsViewed)
        return copy
    }
}

struct CHAnalyticUser: Codable {
	let id: String
	let email: String
	let phone: String
	let firstName: String
	let lastName: String
	let zipCode: String
	let userName: String
	let selectedInterestCodes: [String]?
	let bio: String?
	let instagramUserName: String?
	let twitterUserName: String?
	let facebookUserName: String?
	let tikTokUserName: String?
	let avatarImageUrl: String?
	let followedUserIds: [String]?
	let followersIds: [String]?
	let firstTheme: String?
	let secondTheme: String?
	let thirdTheme: String?
    let lastTimeNotificationsViewed: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phone
        case firstName
        case lastName
        case zipCode
        case userName
        case selectedInterestCodes
        case bio
        case instagramUserName
        case twitterUserName
        case facebookUserName
        case tikTokUserName
        case avatarImageUrl
        case followedUserIds
        case followersIds
        case firstTheme
        case secondTheme
        case thirdTheme
        case lastTimeNotificationsViewed
    }

	static func initFromUser(user: CHUser) -> CHAnalyticUser? {
		guard let data = try? JSONEncoder().encode(user),
			  let copy = try? JSONDecoder().decode(CHAnalyticUser.self, from: data) else { return nil }
		return copy
	}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        zipCode = try values.decode(String.self, forKey: .zipCode)
        userName = try values.decode(String.self, forKey: .userName)
        selectedInterestCodes = try values.decodeIfPresent([String].self, forKey: .selectedInterestCodes)
        bio = try values.decode(String.self, forKey: .bio)
        instagramUserName = try values.decodeIfPresent(String.self, forKey: .instagramUserName)
        twitterUserName = try values.decodeIfPresent(String.self, forKey: .twitterUserName)
        facebookUserName = try values.decodeIfPresent(String.self, forKey: .facebookUserName)
        tikTokUserName = try values.decodeIfPresent(String.self, forKey: .tikTokUserName)
        avatarImageUrl = try values.decodeIfPresent(String.self, forKey: .avatarImageUrl)
        followedUserIds = try values.decodeIfPresent([NotificationInfo].self, forKey: .followedUserIds)?
            .map({ $0.userId})
        followersIds =  try values.decodeIfPresent([NotificationInfo].self, forKey: .followersIds)?.map({ $0.userId })
        firstTheme = try values.decodeIfPresent(String.self, forKey: .firstTheme)
        secondTheme = try values.decodeIfPresent(String.self, forKey: .secondTheme)
        thirdTheme = try values.decodeIfPresent(String.self, forKey: .thirdTheme)
        let lastViewedDate = try values.decodeIfPresent(Double.self, forKey: .lastTimeNotificationsViewed)
        lastTimeNotificationsViewed = Date(timeIntervalSince1970: lastViewedDate ?? 0)
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(email, forKey: .email)
        try values.encode(phone, forKey: .phone)
        try values.encode(firstName, forKey: .firstName)
        try values.encode(lastName, forKey: .lastName)
        try values.encode(zipCode, forKey: .zipCode)
        try values.encode(userName, forKey: .userName)
        try values.encode(selectedInterestCodes, forKey: .selectedInterestCodes)
        try values.encode(bio, forKey: .bio)
        try values.encode(instagramUserName, forKey: .instagramUserName)
        try values.encode(twitterUserName, forKey: .twitterUserName)
        try values.encode(facebookUserName, forKey: .facebookUserName)
        try values.encode(tikTokUserName, forKey: .tikTokUserName)
        try values.encode(avatarImageUrl, forKey: .avatarImageUrl)
        try values.encode(followedUserIds, forKey: .followedUserIds)
        try values.encode(followersIds, forKey: .followersIds)
        try values.encode(firstTheme, forKey: .firstTheme)
        try values.encode(secondTheme, forKey: .secondTheme)
        try values.encode(thirdTheme, forKey: .thirdTheme)
        try values.encode(lastTimeNotificationsViewed?.timeIntervalSince1970, forKey: .lastTimeNotificationsViewed)
    }
}
