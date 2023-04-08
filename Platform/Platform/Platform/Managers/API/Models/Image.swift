import Foundation

class ImageWithStatus: Equatable, Codable {
    var imageUrl: String
    var isFromCamera = false
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl, isFromCamera
    }
    
    init(imageUrl: String, isFromCamera: Bool) {
        self.imageUrl = imageUrl
        self.isFromCamera = isFromCamera
    }
    
    static func == (lhs: ImageWithStatus, rhs: ImageWithStatus) -> Bool {
        lhs.imageUrl == rhs.imageUrl
    }
}
