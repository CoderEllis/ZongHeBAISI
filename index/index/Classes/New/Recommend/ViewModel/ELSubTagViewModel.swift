//
//  ELSubTagViewModel.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ELSubTagViewModel: NSObject {

    var subTagModel: [ELSubTagModel]?

     // Mark: -数据源更新
    typealias AddDataBlock = () -> Void
    var updateDataBlock : AddDataBlock?
    
}

extension ELSubTagViewModel {
    func refreshDataSource() {
        ELSubTagProvider.request(.tuijian) { (result) in
            
            switch result {
            case .success(let data):
                
                if let data = try? data.mapJSON() {
//                    printLog(data)
                    
                    let json = JSON(data)
//                    printLog(json)
                    if let mappedObject = JSONDeserializer<ELSubTagModel>.deserializeModelArrayFrom(json: json.description) {
                        self.subTagModel = mappedObject as? [ELSubTagModel]
                    }
                    self.updateDataBlock?()
                }
                
            case .failure(let error):
                printLog(error)
            }
        }
    }
}
