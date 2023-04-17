import Foundation
import UIKit

class ImageUploadManager {
	
	static let shared = ImageUploadManager()
    //MARK: delegate and managers should not be responsible for UI
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var screenAlertDelegate: ScreenAlertDelegate?
    
    private init() { }
    
    func setupDelegates(_ viewController: BaseViewController) {
        screenLoaderDelegate = viewController as? ScreenLoaderDelegate
        screenAlertDelegate = viewController as? ScreenAlertDelegate
    }
    
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
//                delegate?.viewController.showMessage(message: "Invalid image format")
                screenAlertDelegate?.showAlert(error: Constants.ImageUploadManager.imageFormatError, completion: nil)
                return
            }
            
            uploadImagesGroup.enter()
            guard let screenLoaderDelegate else { return }
            screenLoaderDelegate.showScreenLoader()
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
            self.screenLoaderDelegate?.hideScreenLoader()
            completion(uploadImageError, uploadImageError != nil)
        }
    }
}
