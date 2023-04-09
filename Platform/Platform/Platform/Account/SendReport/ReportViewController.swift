import Foundation
import UIKit
import MessageUI

class ReportViewController: BaseViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sendReportButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let picker = ImagePickerController()
    private let descriptionMaxLenght = 255
    private let descriptionMinLenght = 1
    private let imagePlaceHolder = UIImage(named: "uploadPhoto")
    
    override func prepareUI() {
        super.prepareUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        photoImageView.addGestureRecognizer(gesture)
        photoImageView.layer.cornerRadius = 10
        photoImageView.isUserInteractionEnabled = true
        photoImageView.image = imagePlaceHolder
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.placeholder = "Enter your text"
        errorLabel.isHidden = true
    }
    
    @objc private func onPressed() {
        picker.pickImage(self, with: .default) { listImages, _ in
            if let image = listImages.first {
                self.photoImageView.image = image
            }
        }
    }
    
    func sendReport() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["vinilla2@ukr.net"])
            mailComposeVC.setSubject("Report")
            mailComposeVC.setMessageBody(descriptionTextView.text, isHTML: false)
            
            guard let photoImage = photoImageView.image else { return }
            guard let placeholderImage = imagePlaceHolder else { return }
            
            if !imageCompare(photoImage, isEqualTo: placeholderImage) {
				if let lockalImageData = photoImageView.image?.compressTo() {
					mailComposeVC.addAttachmentData(lockalImageData, mimeType: "image/jpg", fileName: "image")
                } else {
                    showMessage(message: "Failed to attach image")
                    photoImageView.image = imagePlaceHolder
                    return
                }
            }
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            showMessage(message: "Cannot send emails")
        }
    }
    
    func imageCompare(_ image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let imageData1: NSData = image1.pngData()! as NSData
        let imageData2: NSData = image2.pngData()! as NSData
        return imageData1.isEqual(imageData2)
    }
    
    @IBAction func sendReportClick(_ sender: Any) {
        if descriptionTextView.text.count < descriptionMinLenght || descriptionTextView.text.count >= descriptionMaxLenght {
            errorLabel.isHidden = false
        } else {
            sendReport()
        }
    }
}

extension ReportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var resultText: String?
        switch result {
        case .cancelled:
            resultText = "Mail cancelled"
        case .saved:
            resultText = "Mail saved"
        case .sent:
            resultText = "Mail sent"
        case .failed:
            resultText = "Mail sent failure: \(String(describing: error?.localizedDescription))"
        default:
            break
        }
        
        if let resultText {
            dismiss(animated: true) { self.showMessage(title: "", message: resultText) }
        } else {
            dismiss(animated: true)
        }
    }
}

extension ReportViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        errorLabel.isHidden = newText.count < descriptionMinLenght || newText.count >= descriptionMaxLenght ? false : true
        return true
    }
}
