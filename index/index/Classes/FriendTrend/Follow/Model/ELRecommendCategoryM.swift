//
//  ELRecommendCategoryM.swift
//  index
//
//  Created by Soul on 2/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import HandyJSON

struct ELRecommendCategoryM: HandyJSON {
    var id : NSInteger?
    var count : NSInteger?
    var name : String?
    
    var users = [ELRecommendUserM]()
    var total : NSInteger?
    var currentPage : NSInteger = 0
}

struct ELRecommendUserM: HandyJSON {
    var header : String?
    var screen_name : String?
    var fans_count : NSInteger?
}




struct ELRecommendCategoryM1: Codable {
    var list : [ELRecommendUserM1]
//    var total : Int
//    var size : Int
//    var info : infoM1
}

struct ELRecommendUserM1: Codable {
    var id : Int
    var count : Int
    var name : String
}

struct infoM1: Codable {
    var count : Int
    var np : Int
}
