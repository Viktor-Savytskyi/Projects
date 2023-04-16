import UIKit

extension UIImage {
    
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
    
    private func convertToBytes(sizeInMb: Int) -> Int {
        sizeInMb * 1024 * 2
    }
    
    func compressTo(expectedSizeInMb: Int = 5) -> Data? {
        //MARK: 1024 * 2
        let sizeInBytes = convertToBytes(sizeInMb: expectedSizeInMb)
        var needCompress = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while needCompress && compressingValue > 0.0 {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.01
                }
            }
        }
        
        if let data = imgData {
            if data.count < sizeInBytes {
                return data
//                return nil
            }
        }
        return nil
    }
}
