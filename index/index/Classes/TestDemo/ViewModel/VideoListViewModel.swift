//
//  VideoListViewModel.swift
//  VideoPlayer
//
//  Created by Soul on 19/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoListViewModel: NSObject {
    //video 数组
    
    var videoArr: [DemoVideoModel] = []
    
    //初始化数组
    func setupData(success : () -> ()) {
        let path = Bundle.main.bundlePath
        let filePath = path+"/video"
        
        do {
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
            let dataDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
//            printLog(dataDict)
            
            let dataArray = dataDict["data"] as! Array<[String : Any]>
            for dict in dataArray {
                let video = DemoVideoModel(dict: dict)
                videoArr.append(video)
            }
            success()
            
        } catch {
            printLog(error)
        }
        
    }
}
