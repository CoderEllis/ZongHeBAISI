//
//  QRCodeTool.swift
//  QR_Code
//
//  Created by Soul Ai on 16/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

import UIKit

class QRCodeTool: NSObject {
    

    ///二维码图片识别
    class func qrCodeString(image: UIImage) -> String? {
        
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        //.1创建一个探测器 设置设别类型和识别质量
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // 2.2利用探测器探测数据
        let results = detector!.features(in: ciImage)

        // 2.3取出探测到的数据
        var resultString: String?
        for result in results {
            resultString = (result as! CIQRCodeFeature).messageString
        }
        
        if resultString != nil {
            return resultString
        } else {
            return nil
        }
        
    }

    
}

// MARK: - 二维码\条形码
extension QRCodeTool {
    ///二维码生成
    class func generatorQRCode(inputStr: String, logoImage: UIImage?) -> UIImage {
        // 1. 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2 恢复滤镜默认设置
        filter?.setDefaults()
        // 3. 设置滤镜输入数据  KVC
        let data = inputStr.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        // 4 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        // 5. 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        // 6.借助这个方法, 处理成为一个高清图片
        let transform = CGAffineTransform(scaleX: 30, y: 30)
        image = image?.transformed(by: transform)
        // 7 图片处理  (23.0, 23.0)
        let result = UIImage(ciImage: image!)
        //8.开始上下文
        UIGraphicsBeginImageContext(result.size)
        //8.1绘制大图片
        result.draw(in: CGRect(x: 0, y: 0, width: result.size.width, height: result.size.height))
        
        //8.2.center logo
        if logoImage != nil {
            let width: CGFloat = 100
            let height: CGFloat = 100
            let x: CGFloat = (result.size.width - width) * 0.5
            let y: CGFloat = (result.size.height - height) * 0.5
            logoImage!.draw(in: CGRect(x: x, y: y, width: width, height: height))
        }
        
        //8.3 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        //8.4 关闭上下文
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    ///条形码生成
    class func generateBarCode128(_ barCodeStr: String,barCodeSize: CGSize, drawText: Bool) -> UIImage {
        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
        qrFilter?.setDefaults()
        let stringData = barCodeStr.data(using: String.Encoding.utf8)
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        let outputImages = qrFilter?.outputImage
        
        guard let outputImage = outputImages else { return UIImage() }
        
        // 消除模糊
        let scaleX = barCodeSize.width/outputImage.extent.size.width
        let scaleY = barCodeSize.height/outputImage.extent.size.height
        let resultImage = outputImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
        var image = UIImage.init(ciImage: resultImage)
        
        if drawText {
            image = addText(image,textName: barCodeStr)
        }
        return image
    }
    
    
    //添加条形码下方文字
    class fileprivate func addText(_ image: UIImage, textName: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions (image.size, false , 0.0 )
        image.draw(at: CGPoint.zero)
        // 获得一个位图图形上下文
        let context = UIGraphicsGetCurrentContext()
        context!.drawPath(using: .stroke)
        //绘制文字
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.alignment = .center
        textName.draw(in: CGRect(x: 0, y: image.size.height - 22, width: image.size.width, height: 30), withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0),NSAttributedString.Key.backgroundColor:UIColor.clear,NSAttributedString.Key.paragraphStyle:textStyle])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
