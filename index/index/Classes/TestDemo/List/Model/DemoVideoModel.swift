//
//  DemoVideo.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class DemoVideoModel: ELVideoModel {
    
    //    var play_address: String?
    //    
    //    var title: String?
    
    @objc var video_id: Int = 0
    
    @objc var poster: String = ""
    
    @objc var detail: String = ""
    
    @objc var director: String = ""
    
    @objc var actor: String = ""
    
    @objc var comment_number: Int = 0
    
    @objc var like_number: Int = 0
    
    @objc var share_number: Int = 0
    
    @objc var status: Int = 0
    
    @objc var time: Int = 0
    
    @objc var charge: Int = 0
    
    @objc var user_id: Int = 0
    
    @objc var view_number: Int = 0
    
    @objc var length: Int = 0
    
    @objc var play_id: Int = 0
    
    @objc var chapter: Int = 0
    
    @objc var type: Int = 0
    
    
    // MARK: - 处理数据
    
    var typeString: String {
        get {
            switch type {
            case 1:
                return "剧集"
            case 2:
                return "MV"
            case 3:
                return "影视"
            case 4:
                return "自制"
            case 5:
                return "创作"
            case 6:
                return "搞笑"
            default:
                return "其他"
            }
        }
    }
    
    
    // MARK: - init
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
