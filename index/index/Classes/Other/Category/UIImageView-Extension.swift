//
//  UIImageView-Extension.swift
//  index
//
//  Created by Soul on 27/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

extension UIImageView {
    
    ///设置圆形头像
    func setHeader(headerUrl: String) {
        if headerUrl == "" {
            return
        }
        
        let placeholder = UIImage(named: "defaultUserIcons")?.circleImage()
        // cacheMemoryOnly 只从缓存获取，不会下载
        kf.setImage(with: URL(string: headerUrl), placeholder: placeholder, options: [.cacheMemoryOnly], progressBlock: nil) { (result) in
            switch result {
            case .success(let value):
                
                self.image = value.image.circleImage()
            //                printLog("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                printLog("Job failed: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func el_setOriginImage(originImageURL: String, thumbnailImageURL: String, placeholder: UIImage? = nil, completionHandler: ((RetrieveImageResult) -> Void)? = nil) {
        let net = NetworkReachabilityManager()
        
        let originImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: originImageURL, options: [.originalCache(.default)])
        
        if (originImage != nil) { // 原图已经被下载过 options:callbackQueue:completionHandler
            print("原图已经被下载过")
            kf.setImage(with: URL(string: originImageURL), placeholder: placeholder, options: [], progressBlock: nil) { (result) in
                switch result {
                case .success(let value):
                    completionHandler?(value)
                case .failure(_): 
                    break
                }
            }
            
        } else {// 原图并未下载过
//            print("未下载过")
            if net?.isReachable ?? false {
                if net?.isReachableOnEthernetOrWiFi ?? false {
                    //用渐变的方式显示出来
                    kf.setImage(with: URL(string: originImageURL), placeholder: placeholder, options: [.transition(ImageTransition.fade(1)), .cacheOriginalImage], progressBlock: nil) { (result) in
                        switch result {
                        case .success(let value):
                            completionHandler?(value)
                        case .failure(_): 
                            break
                        }
                    }
                    
                    
                } else if net?.isReachableOnWWAN ?? false {
                    // #warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
                    // 3G\4G网络下时候要下载原图
                    let downloadOriginImageWhen3GOr4G : Bool? = true
                    if downloadOriginImageWhen3GOr4G! {
                        print("wifi")
                        kf.setImage(with: URL(string: originImageURL), placeholder: placeholder, options: [.cacheOriginalImage], progressBlock: nil) { (result) in
                            switch result {
                            case .success(let value):
                                completionHandler?(value)
                            case .failure(_): 
                                break
                            }
                        }
                        
                    } else {
                        
                        kf.setImage(with: URL(string: thumbnailImageURL), placeholder: placeholder, options: [.cacheOriginalImage], progressBlock: nil) { (result) in
                            switch result {
                            case .success(let value):
                                completionHandler?(value)
                            case .failure(_): 
                                break
                            }
                        }
                    }
                    
                }
                
                
            } else { // 没有可用网络
                let thumbnailImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: thumbnailImageURL)
                print("没有可用网络")
                if (thumbnailImage != nil) { // 缩略图已经被下载过
                    kf.setImage(with: URL(string: thumbnailImageURL), placeholder: placeholder, options: [.onlyFromCache], progressBlock: nil) { (result) in
                        switch result {
                        case .success(let value):
                            completionHandler?(value)
                        case .failure(_): 
                            break
                        }
                    }
                    print("缩略图已经被下载过")
                } else {// 没有下载过任何图片
                    // 占位图片
                    kf.setImage(with: URL(string: ""), placeholder: placeholder, options: [.onlyFromCache], progressBlock: nil) { (result) in
                        switch result {
                        case .success(let value):
                            completionHandler?(value)
                        case .failure(_): 
                            break
                        }
                    }
                    print("没有下载过任何图片")
                    
                }
                
            }
        }
        
        
    }
    
    
    
}
