//
//  UIImage.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/7.
//
//

import UIKit

extension UIImage {

    public enum JPEGQuality {
        public typealias RawValue = CGFloat

        case lowest
        case low
        case medium
        case high
        case highest
        case custom(rate: CGFloat)

        public var rawValue: CGFloat {
            switch self {
            case .lowest: return 0
            case .low: return 0.25
            case .medium: return 0.5
            case .high: return 0.75
            case .highest: return 1
            case let .custom(rate):
                return max(0, min(1, rate))
            }
        }
    }

    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    public var png: Data? { return UIImagePNGRepresentation(self) }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    public func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }

    /// Returns compressed image to rate from 0 to 1
    public func compressImage(rate: JPEGQuality) -> Data! {
        let hasAlpha = self.hasAlpha()
        let data = hasAlpha ? self.png : self.jpeg(rate)
        return data
    }

    /// Returns Image size in Bytes
    public func getSizeAsBytes() -> Int {
        return compressImage(rate: .highest).count
    }

    /// Returns resized image with width. Might return low quality
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// Returns resized image with height. Might return low quality
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }

    /// Returns cropped image from CGRect
    public func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage
    }

    public class func color(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {

        let scale = UIScreen.main.scale
        let fillRect = CGRect(x: 0, y: 0, width: size.width / scale, height: size.height / scale)
        UIGraphicsBeginImageContextWithOptions(fillRect.size, false, scale)

        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color.cgColor)
        graphicsContext?.fill(fillRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }

    public func hasAlpha() -> Bool {
        if  let alpha = (self.cgImage)?.alphaInfo {
            switch alpha {
            case .first, .last, .premultipliedFirst, .premultipliedLast, .alphaOnly:
                return true
            case .none, .noneSkipFirst, .noneSkipLast:
                return false
            }
        }
        return false
    }

    /// fix image orientation
    public func fixOrientation() -> UIImage {

        if (self.imageOrientation == .up) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }

}
