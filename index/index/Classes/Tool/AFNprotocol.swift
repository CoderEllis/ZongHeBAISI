//
//  protocolAFN.swift
//  index
//
//  Created by Soul on 23/9/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Alamofire

protocol Requestable {
    var URLString : String {get}
    var type : MethodType {get}
    var parameters : [String: Any] {get}
    
    associatedtype ResultData //关联类型
    func parseResult(_ result : Any) //MARK:- result由协议完成
    var parseData : ResultData {get}
}

// swift3.0开始, 如果闭包不是在当前函数中直接使用, 那么需要给该闭包的类型前加上 @escaping
extension Requestable {
    //只传闭包 其他不要了 _ type : MethodType, URLString : String, parameters : [String : Any]? = nil, 此三者由协议完成
    func requestData(finishedCallback : @escaping () -> ()) { //MARK:- (_ result : Any) -> () result由协议parseResult完成
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? " --- 网络请求发生了错误 --- ")
                return
            }
            
            self.parseResult(result) //MARK:- result由协议完成 
            finishedCallback() //MARK:- finishedCallback(result) result由协议完成
        }
    }
    
}

//VM    MVVM模式
class TGGiftViewModel: NSObject,Requestable {
    var URLString: String = "http://qf.56.com/pay/v4/giftList.ios"
    var type: MethodType = .get
    var parameters: [String : Any] = ["type":0,"page":1,"rows":150]
    
    typealias ResultData = [TGGiftPackage] //关联类型
    var parseData: Array<TGGiftPackage> = []
    
}
extension TGGiftViewModel {
    //数据处理
    func parseResult(_ result: Any) {
        guard let resultDict = result as? [String : Any] else { return }
        guard let typesDictData = resultDict["message"] as? [String : Any] else { return }
        
        for i in 0..<typesDictData.count {
            guard let typeDict = typesDictData["type\(i+1)"] as? [String: Any] else { return }
            self.parseData.append(TGGiftPackage(dict: typeDict))
        }
        self.parseData = self.parseData.filter({ $0.t != 0 }).sorted(by: { $0.t > $1.t})
        //数组过滤 和 排序 filter 中是返回的闭包  { $0.t != 0 }  $0表示第一个元素中的t值 sorted 返回的闭包 { $0.t > $1.t }
    }
}

class TGGiftView: UIViewController {
    fileprivate lazy var giftVM = TGGiftViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftVM.requestData { 
            
//            self.pageCollectionView.reloadData()
            var titles : [String] = []
            for (i,v) in self.giftVM.parseData.enumerated() {
                titles.append(v.title == "" ? "租\(i+1)" : v.title)
            }
//            self.pageCollectionView.setTitles(titles: titles)
            
        }
        
    }
    
}


class TGGiftPackage: NSObject {
    var t : Int = 0
    var title : String = ""
    var giftModels : [TGGiftModel] = []
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            if let arr = value as? [[String : Any]]{
                for dict in arr{
                    giftModels.append(TGGiftModel(dict:dict))
                }
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class TGGiftModel: NSObject {
    
    var coin :Int = 0
    var img : String = ""
    var img2 : String = ""
    var gUrl : String = ""
    var subject : String = "" {
        didSet{
            if subject.contains("有声"){
                subject = subject.replacingOccurrences(of: "有声", with: "")
            }
        }
    }
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
