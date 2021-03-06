//
//  UIImage.swift
//  LXExtension
//
//  Created by luan on 9/21/17.
//
//

import UIKit

extension UIImage {
    var bytes: Int {
        if let data = UIImageJPEGRepresentation(self, 0.8) {
            return data.count
        }
        return 0
    }
    
    var ratio: CGFloat {
        return size.width / size.height
    }
    
    func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func crop(with rect: CGRect) -> UIImage? {
        let rectTransform : CGAffineTransform
        switch (imageOrientation) {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(90.0).radians).translatedBy(x: 0, y: -size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(-90).radians).translatedBy(x: -size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat(-180).radians).translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        let transformedCropSquare = rect.applying(rectTransform)
        let imageRef: CGImage? = cgImage!.cropping(to: transformedCropSquare)
        
        return (imageRef != nil) ? UIImage(cgImage: imageRef!, scale: 1.0, orientation: imageOrientation): nil
    }
    
    // MARK: Resize image
    fileprivate func resize(with size: CGSize, transform: CGAffineTransform, drawTransposed: Bool, quality: CGInterpolationQuality) -> UIImage? {
        let newRect = CGRect(origin: CGPoint.zero, size: size).integral
        let transposedRect = CGRect(origin: CGPoint.zero, size: newRect.size)
        guard let imageRef = cgImage else {
            return nil
        }
        
        let width = Int(newRect.size.width)
        let height = Int(newRect.size.height)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0, space: imageRef.colorSpace!, bitmapInfo: imageRef.bitmapInfo.rawValue)
        guard let bitmap = context else {
            return nil
        }
        
        bitmap.concatenate(transform)
        bitmap.interpolationQuality = quality
        bitmap.draw(imageRef, in: drawTransposed ? transposedRect : newRect)
        
        let newImageRef = bitmap.makeImage()
        return newImageRef != nil ? UIImage(cgImage: newImageRef!) : nil
    }
    
    func resize(with size: CGSize, interpolationQuality: CGInterpolationQuality = .high) -> UIImage? {
        let drawTransposed = imageOrientation == .left || imageOrientation == .leftMirrored || imageOrientation == .right || imageOrientation == .rightMirrored
        
        let transform = transformForOrientation(size)
        
        return resize(with: size, transform: transform, drawTransposed: drawTransposed, quality: interpolationQuality)
    }
    
    fileprivate func transformForOrientation(_ newSize: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        if imageOrientation == .down || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: newSize.width, y: newSize.height)
            transform = transform.rotated(by: CGFloat(180).radians)
        } else if imageOrientation == .left || imageOrientation == .leftMirrored {
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: CGFloat(90).radians)
        } else if imageOrientation == .right || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: CGFloat(-90).radians)
        }
        
        if  imageOrientation == .upMirrored || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        } else if imageOrientation == .leftMirrored || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: newSize.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        return transform
    }
}
