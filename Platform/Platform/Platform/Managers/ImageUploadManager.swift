import Foundation
import UIKit

protocol ImageUploadManagerDelegate: AnyObject {
    var viewController: BaseViewController { get }
}

class ImageUploadManager {
	
	static let shared = ImageUploadManager()
	
    weak var delegate: ImageUploadManagerDelegate?
    
    private init() { }
    
    func uploadImages(post: Post,
                      editLocalImageFirst: LocalImage?,
                      editLocalImageSecond: LocalImage?,
                      editLocalImageThird: LocalImage?,
                      completion: @escaping ((Error?, Bool) -> Void)) {
        let imagesArray = [editLocalImageFirst, editLocalImageSecond, editLocalImageThird].compactMap { $0 }
        if imagesArray.isEmpty {
            completion(nil, true)
            return
        }
        let uploadImagesGroup = DispatchGroup()
        var uploadImageError: Error?
        for localImage in imagesArray {
            guard let imageData = localImage.image.compressTo() else {
                delegate?.viewController.showMessage(message: "Invalid image format")
                return
            }
            
            uploadImagesGroup.enter()
            guard let delegate = delegate else { return }
            delegate.viewController.showLoader()
            StorageAPI.shared.uploadImage(imageData: imageData) { error, imageUrl in
                if let url = imageUrl {
                    switch localImage.number {
                    case .first:
                        post.firstImage = ImageWithStatus(imageUrl: url, isFromCamera: localImage.isFromCamera)
                    case .second:
                        post.secondImage = ImageWithStatus(imageUrl: url, isFromCamera: localImage.isFromCamera)
                    case .third:
                        post.thirdImage = ImageWithStatus(imageUrl: url, isFromCamera: localImage.isFromCamera)
                    }
                }
                if let error = error {
                    uploadImageError = error
                }
                uploadImagesGroup.leave()
            }
        }
        
        uploadImagesGroup.notify(queue: .main) {
            self.delegate?.viewController.hideLoader()
            completion(uploadImageError, uploadImageError != nil)
        }
    }
}
