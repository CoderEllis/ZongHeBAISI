//
//  ELTopicModel.swift
//  index
//
//  Created by Soul on 9/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import HandyJSON

enum ELTopicType: Int {
    case all = 1
    case picture = 10
    case voice = 31
    case video = 41
    case word = 29
}

struct ELTopicModel: HandyJSON {
    ///用户的名字
    var name : String?
    ///用户的头像
    var profile_image : String?
    ///帖子的文字内容
    var text : String = ""
    ///帖子审核通过的时间
    var passtime : String?
    
    ///顶数量
    var ding : Int = 0
    ///踩数量
    var cai : Int = 0
    ///转发\分享数量
    var repost : Int = 0
    ///评论数量
    var comment : Int = 0
    
    ///帖子的类型 10为图片 29为段子 31为音频 41为视频 
    var type : Int?
    
    ///宽度(像素)
    var width : Int = 0
    ///高度(像素)
    var height : Int = 0
    
    ///最热评论
    var top_cmt : [CommentModel]?
    
    ///小图
    var image0 : String?
    ///中图
    var image2 : String?
    ///大图
    var image1 : String?
    var is_gif: Bool = false
    
    /// 音频时长
    var voicetime: Int = 0
    /// 视频时长
    var videotime: Int = 0
    /// 音频\视频的播放次数
    var playcount: Int = 0
    /// 视频的url
    var videouri: String?
    
    var voiceuri: String?
    
    var videoPlaying: Bool = false
    
}

extension ELTopicModel {
    /* 额外增加的属性（并非服务器返回的属性，仅仅是为了提高开发效率） */
    /** 根据当前模型计算出来的cell高度 */
    ///  cellHeight     是否为超长图片   中间内容的frame
    var array : (cellHeight: CGFloat, bigPicture: Bool, middleFrame: CGRect) {
        var _cellHeight : CGFloat = 0.0
        var bigPicture = false
        var middleFrame :CGRect = .zero
        
        // 文字的Y值
        _cellHeight += 55.0
        
        let textMaxsize = CGSize(width: ScreenWidth - ELMarin * 2, height: CGFloat(MAXFLOAT))
        // 正文的高度
        _cellHeight += (text as NSString).boundingRect(with: textMaxsize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)], context: nil).size.height + ELMarin
        
        //中间内容
        if type != ELTopicType.word.rawValue {
            let middleW = textMaxsize.width
            var middleH = middleW * CGFloat(height) / CGFloat(width)
            
            
            let middleY = _cellHeight
            let middleX = ELMarin
            
            if type == 41 || type == 31 {
                if middleH > middleW {
                    middleH = middleW
                }
                middleFrame = CGRect(x: middleX, y: middleY, width: middleW, height: middleH)
                _cellHeight += middleH + ELMarin
            } else {
                if middleH >= ScreenHeight {
                    bigPicture = true
                    middleH = middleW
                }
                middleFrame = CGRect(x: middleX, y: middleY, width: middleW, height: middleH) //按比例缩放
                _cellHeight += middleH + ELMarin
            }
            
        }
        
        // 最热评论
        if top_cmt?.count != 0 {
            printLog("最热评论有数据->>>>>>>")
            // 标题
            _cellHeight += 25
            let cmt = top_cmt?.first
            if cmt != nil {
                var content = cmt?.content
                if content?.count == 0 {
                    content = "[语音评论]"
                }
                let cmtText = String(format: "%@ : %@", (cmt?.user.username)!,content!)
                _cellHeight += (cmtText as NSString).boundingRect(with: textMaxsize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil).size.height + ELMarin
            }
            
        }
        
        // 工具条
        _cellHeight += 35 + ELMarin
        
        return (_cellHeight, bigPicture, middleFrame)
    }
    
    
    
}


struct CommentModel: HandyJSON {
    var id: String = ""
    var voicetime: Int = 0
    var voiceurl: String = ""
    var content: String = ""
    var like_count = 0
    var ctime : String = ""
    var user: UserModel!
}

struct UserModel: HandyJSON {
    var username: String = ""
    var sex: String = ""
    var profile_image: String = ""
    var weibo_uid : String = ""
    var qzone_uid: String = ""
    var is_vip : Bool?
    var personal_page : String = ""
    var id : String = ""
}




enum TopStyle : String, Codable {
    case all = "1"
    case picture = "10"
    case voice = "31"
    case video = "41"
    case word = "29"
}


struct EssenceModel: Codable {
    
    var info : Info
    struct Info: Codable {
        var maxid : String
        var vendor : String
        var maxtime : String
        var count : Int
        var page : Int
    }
    
    var list : [user]
    
    
    
}

struct user: Codable {
    //        var codingPath: [CodingKey]
    //        
    //        var userInfo: [CodingUserInfoKey : Any]
    //        
    //        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    //            <#code#>
    //        }
    //        
    //        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    //            <#code#>
    //        }
    //        
    //        func singleValueContainer() throws -> SingleValueDecodingContainer {
    //            <#code#>
    //        }
    
    enum CodingKeys : String, CodingKey {
        case name
        case profile_image
        case text
        case passtime
        
        case ding
        case cai
        case repost
        case comment
        
        case type
        case width
        case height
        case top_cmt
        case image0
        case image2
        case image1
        case voicetime
        case videotime
        case playcount
        case videouri
        case voiceuri
        
    }
    
    ///用户的名字
    var name : String?
    ///用户的头像
    var profile_image : String?
    ///帖子的文字内容
    var text : String = ""
    ///帖子审核通过的时间
    var passtime : String?
    
    ///顶数量
    var ding : TStrInt?
    ///踩数量
    var cai : TStrInt?
    ///转发\分享数量
    var repost : TStrInt?
    ///评论数量
    var comment : TStrInt?
    
    ///帖子的类型 10为图片 29为段子 31为音频 41为视频 
    var type : TopStyle
    //    
    ///宽度(像素)
    var width : TStrInt?
    ///高度(像素)
    var height : TStrInt?
    
    ///最热评论
    var top_cmt : [CommentModelTop]?
    
    ///小图
    var image0 : String?
    ///中图
    var image2 : String?
    ///大图
    var image1 : String?
    
    //    var is_gif: Bool = false
    
    /// 音频时长
    var voicetime: TStrInt?
    /// 视频时长
    var videotime: TStrInt?
    /// 音频\视频的播放次数
    var playcount: TStrInt?
    /// 视频的url
    var videouri: String?
    
    var voiceuri: String?
    
    //    var videoPlaying: Bool = false
    var cellhhh : CGFloat? {
        return array.cellHeight
    }
    
}

extension user {
    /* 额外增加的属性（并非服务器返回的属性，仅仅是为了提高开发效率） */
    /** 根据当前模型计算出来的cell高度 */
    ///  cellHeight     是否为超长图片   中间内容的frame
    var array : (cellHeight: CGFloat, bigPicture: Bool, middleFrame: CGRect) {
        var _cellHeight : CGFloat = 0.0
        var bigPicture = false
        var middleFrame :CGRect = .zero
        
        // 文字的Y值
        _cellHeight += 55.0
        
        let textMaxsize = CGSize(width: ScreenWidth - ELMarin * 2, height: CGFloat(MAXFLOAT))
        // 正文的高度
        _cellHeight += (text as NSString).boundingRect(with: textMaxsize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)], context: nil).size.height + ELMarin
        
        //中间内容
        if type != TopStyle.word {
            let middleW = textMaxsize.width
            var middleH = middleW * CGFloat(height?.int ?? 0) / CGFloat(width?.int ?? 0)
            
            let middleY = _cellHeight
            let middleX = ELMarin
            
            if type == .video || type == .voice {
                if middleH > middleW {
                    middleH = middleW
                }
                middleFrame = CGRect(x: middleX, y: middleY, width: middleW, height: middleH)
                _cellHeight += middleH + ELMarin
            } else {
                if middleH >= ScreenHeight {
                    bigPicture = true
                    middleH = middleW
                }
                middleFrame = CGRect(x: middleX, y: middleY, width: middleW, height: middleH) //按比例缩放
                _cellHeight += middleH + ELMarin
            }
            
        }
        
        // 最热评论
        if top_cmt?.count != 0 {
            printLog("最热评论有数据->>>>>>>")
            // 标题
            _cellHeight += 25
            let cmt = top_cmt?.first
            if cmt != nil {
                var content = cmt?.content
                if content?.count == 0 {
                    content = "[语音评论]"
                }
                let cmtText = String(format: "%@ : %@", (cmt?.user.username)!,content!)
                _cellHeight += (cmtText as NSString).boundingRect(with: textMaxsize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil).size.height + ELMarin
            }
            
        }
        
        // 工具条
        _cellHeight += 35 + ELMarin
        
        return (_cellHeight, bigPicture, middleFrame)
    }
    

}


struct CommentModelTop: Codable {
    var id: String
    var voicetime: Int
    var voiceurl: String
    var content: String
    var like_count: Int
    var ctime : String
    var user: UserModelTop
}

struct UserModelTop: Codable {
    var username: String
    var sex: String
    var profile_image: String
    var weibo_uid : String
    var qzone_uid: String
    var is_vip : Bool?
    var personal_page : String
    var id : String
}


extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
