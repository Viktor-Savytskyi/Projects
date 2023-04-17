import Photos
import PhotosUI
import TOCropViewController
import UIKit

//MARK: use enum
enum ImagePickerSections: String {
    case chooseImage = "Choose image"
    case cancel = "Cancel"
    case camera = "Camera"
    case photoroll = "Choose from library"
}

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    var cropStyle: TOCropViewCroppingStyle?
    var picker = UIImagePickerController()
    var alert: UIAlertController!
    var viewController: BaseViewController?
    var pickImagesCallback: (([UIImage], Bool) -> Void)?
	var isFromCamera = true
    
    func pickImage(_ viewController: BaseViewController,
                   with cropStyle: TOCropViewCroppingStyle? = nil,
                   _ callback: @escaping (([UIImage], Bool) -> Void)) {
        
        alert = UIAlertController(title: ImagePickerSections.chooseImage.rawValue, message: nil, preferredStyle: .actionSheet)
        pickImagesCallback = callback
        self.cropStyle = cropStyle
        self.viewController = viewController
        
        let cameraAction = UIAlertAction(title: ImagePickerSections.camera.rawValue, style: .default) { [weak self] _ in
            self?.openCamera()
        }
        let galleryAction = UIAlertAction(title: ImagePickerSections.photoroll.rawValue, style: .default) { [weak self] _ in
			self?.openGallery()
        }
        let cancelAction = UIAlertAction(title: ImagePickerSections.cancel.rawValue, style: .cancel) { _ in }
        
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        // for iPad
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.viewController!.view.frame.midX, y: self.viewController!.view.frame.midY, width: 0, height: 0)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func getImageFromCamera(_ viewController: BaseViewController, completion: @escaping ([UIImage], Bool) -> Void) {
        pickImagesCallback = completion
        self.viewController = viewController
        openCamera()
        picker.delegate = self
    }
    
    func getImageFromGallery(_ viewController: BaseViewController, completion: @escaping ([UIImage], Bool) -> Void) {
        pickImagesCallback = completion
        self.viewController = viewController
        openGallery()
        picker.delegate = self
    }
    
    func openCamera() {
		isFromCamera = true
        alert?.dismiss(animated: true, completion: nil)
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.picker.modalPresentationStyle = .overFullScreen
                        self.picker.sourceType = .camera
                        self.viewController!.present(self.picker, animated: true, completion: nil)
                    }
                } else {
                    guard let viewController = self.viewController else {
                        return
                    }
                    viewController.showAllowAccessToCameraAlert()
                }
            }
        }
    }
    
    func openGallery() {
		isFromCamera = false
        alert?.dismiss(animated: true, completion: nil)
        alert = UIAlertController(title: ImagePickerSections.chooseImage.rawValue, message: nil, preferredStyle: .actionSheet)
        picker.modalPresentationStyle = .overFullScreen
        picker.sourceType = .photoLibrary
        viewController?.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		if let newImage = info[.originalImage] as? UIImage {
			if cropStyle != nil {
				showCropController(image: newImage)
			} else {
				picker.dismiss(animated: true)
				self.pickImagesCallback?([newImage], isFromCamera)
			}
		}
	}
	
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        var result: [UIImage] = []
        guard !results.isEmpty else { return }
        for provider in results.map({ $0.itemProvider }) where provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self else { return }
                DispatchQueue.main.async { [self] in
                    if let image = image as? UIImage {
                        result.append(image)
                    } else {
                        print(error?.localizedDescription ?? "")
                    }
                    if result.count == results.map({ $0.itemProvider }).count {
                        if let newImage = result.first {
                            if self.cropStyle != nil {
                                self.showCropController(image: newImage)
                            } else {
                                self.picker.dismiss(animated: true)
                                self.pickImagesCallback?(result, self.isFromCamera)
                            }
                        } else {
                            self.picker.dismiss(animated: true)
                            self.pickImagesCallback?(result, self.isFromCamera)
                        }
                    }
                }
            }
        }
    }
	
	private func showCropController(image: UIImage) {
		let cropVC = TOCropViewController(croppingStyle: cropStyle ?? .circular, image: image)
		cropVC.aspectRatioLockEnabled = true
		cropVC.aspectRatioPreset = .presetSquare
		cropVC.delegate = self
		UIView.animate(withDuration: 0.3) {
			self.picker.dismiss(animated: false)
			self.viewController?.present(cropVC, animated: true, completion: nil)
		}
	}
    
}

extension ImagePickerController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with _: CGRect, angle _: Int) {
        cropViewController.dismiss(animated: true) {
			self.pickImagesCallback?([image], self.isFromCamera)
        }
    }
}
