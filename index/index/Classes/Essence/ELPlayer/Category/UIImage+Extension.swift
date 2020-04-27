//
//  UIImage+Extension.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit


// MARK: - 获取纯色图片
extension UIImage {
    
    ///返回一张圆形图
    func circleImage() -> UIImage {
        // 1.开启图形上下文
        // 比例因素:当前点与像素比例c  opaque不透明的
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        
        // 2.描述裁剪区域  贝塞尔曲线(圆)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        // 3.设置裁剪区域
        path.addClip()
        
        draw(at: CGPoint.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
        
    }
    
    ///获取纯色图片
    class func getScreenImage() -> UIImage {
        let window = UIApplication.shared.keyWindow!
        
        // 开启图片类型上下文
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, 0)
        
        // 把屏幕当前画到图片上下文
        window.drawHierarchy(in: window.frame, afterScreenUpdates: false)
        
        // 从图形上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    /// 通过size、color获得纯色图片
    /// - Parameters:
    ///   - color: 传入色彩
    ///   - size: 传入size
    /// - Returns: 对应size的纯色图片
    class func colorImage(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - 拉伸 / 压缩图片
extension UIImage {
    
    /// 对指定图片进行拉伸
    func resizableImage(name : String) -> UIImage {
        
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        return  normal
    }
    
    func compressImage(image: UIImage, maxLength: Int) -> Data? {
        let newSize = scaleImage(image: image, imageLength: 1242)
        let newImage = resizeImage(image: image, newSize: newSize)
        
        var compress : CGFloat = 0.9
        var data = newImage.jpegData(compressionQuality: compress)
        
        while (data?.count)! > maxLength && compress  > 0.01{
            compress -= 0.02
            data = newImage.jpegData(compressionQuality: compress)
        }
        return data
    }
    
    /// 通过指定图片最长边，获得等比例的图片size
    ///
    /// - Parameters:
    ///   - image: 原始图片
    ///   - imageLength: 图片允许的最长宽度（高度）
    /// - Returns: 获得等比例的size
    func  scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if width > imageLength || height > imageLength {
            if width > height {
                
                newWidth  = imageLength
                newHeight = newWidth * height / width
                
            } else if height > width {
                
                newHeight = imageLength
                newWidth = newHeight * width / height
            } else {
                
                newWidth = imageLength
                newHeight = imageLength
            }
            
            return CGSize(width: newWidth, height: newHeight)
        }
        return image.size
    }
    
    
    /// 获得指定size的图片
    ///
    /// - Parameters:
    ///   - image: 原始图片
    ///   - newSize: 指定的size
    /// - Returns: 调整后的图片
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func addImage(img: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        img.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
}
