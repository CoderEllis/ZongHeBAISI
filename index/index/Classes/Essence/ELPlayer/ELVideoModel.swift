//
//  ELVideoModel.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELVideoModel: NSObject {
    /// 视频播放地址
//    var playAddress: String = "http://uvideo.spriteapp.cn/video/2019/0715/5d2c5d5d962d6_wpd.mp4" 
//    
//    /// 视频标题
//    var title: String = "正在播放 0_0" 
    
    @objc var play_address: String = "" // 视频播放地址
    
    @objc var title: String = "" // 视频标题
    
    init(_ playAddress: String, title: String) {
        super.init()
        self.play_address = playAddress
        self.title = title
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
