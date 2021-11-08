//
//  UIImageExtensions.swift
//  UIImageDownsampling
//
//  Created by Alper Öztürk on 8.11.2021.
//

import UIKit

extension UIImage {
    func toData() -> Data? {
        return pngData()
    }
    
    var sizeInBytes: Int {
        if let data = toData() {
            return data.count
        } else {
            return 0
        }
    }
    
    var sizeInMB: Double {
        return Double(sizeInBytes) / 1_000_000
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage = self
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = AppConst.quality
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
