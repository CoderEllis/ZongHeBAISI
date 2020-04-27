//
//  coderTest.swift
//  index
//
//  Created by Soul on 2/8/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

enum BeerStyle : String, Codable {
    case ipa
    case stout
    case kolsch
    // ...
}

struct Beers: Mappable {
    
    var arrs : [Beer]
    var name : String
    
    mutating func structMapFinished() {
        name = "ngdgdfg"
    }
    
    struct Beer: Mappable {
        
        var name: String = "swift"
        var brewery: String = "nods"
        var style: BeerStyle = .ipa
        var score: Double = 0.00
        var p: Person?
        
        enum CodingKeys : String, CodingKey {
            case name = "name_a"
            case brewery
            case p
            case score
        }
        
        class Person: Mappable {
            var name : String = ""
            var age : Int = 0
        }
        
    }
}


//let dict1 = ["name_a":"nckjs","brewery":"gdfge","style":"stout","score":60.3,"p":["name":"jokh","age":10]] as [String : Any]
//let dict2 = ["name_a":"nckjs","brewery":"gdfge","style":"stout","score":60.3,"p":["name":"jokh","age":10]] as [String : Any]
//let dict3 = ["name_a":"nckjs","brewery":"gdfge","style":"stout","score":60.3,"p":["name":"jokh","age":10]] as [String : Any]
//
//let arr = [dict1,dict2,dict3]
//let dict4 = ["arrs" : arr, "name":"fgsdfs"] as [String : Any]
//if let beers = try? Beers.mapFromDict(dict4, Beers.self) {
//    print(beers)
//}


//null的处理 示例
class PersonSon: Codable {
    var name : String = ""
    var age : Int = 0
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //decodeNil(forKey key: KeyedDecodingContainer.Key) throws -> Bool 
        //这个方法就是判断在解析时，对应的属性是否是null值，如果是会返回true，如果不是null就会返回false
        age = try container.decodeNil(forKey: .age) ? 10 : try container.decode(Int.self, forKey: .age)
        name = try container.decode(String.self, forKey: .name)
    }
    
    
}


class ViewC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let str = "{\"name\":\"fdfgdf\",\"age\":null}"
        let jsonData = str.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        if let obj = try? decoder.decode(Person.self, from: jsonData!) {
            print(obj.name,obj.age)
        }else {
            print("解析失败")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




struct GuideModel: Mappable {
    
    var step = ""
    var text_list = GuideTextModel()
    var link_img = ""
    var amount = "0"
    var wb = "0"
    var text_number = ""
    
    struct GuideTextModel: Mappable {
        
        var line1 = ""
        var button1 : String?
        var button2 : String?
        var button3 : String?
    }
}

let dict = [
    "step":"2",
    "text_list":["line1":"完成新手任务还可获得更多现金红包",
                 "button1":"去完成任务",
                 "button2":"去完成任务",
                 "button3":"去完成任务"],
    "link_img":"",
    "amount":"0.5",
    "wb":"5",
    "text_number":"4"
    ] as [String : Any]


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let g = try? GuideModel.mapFromDict(dict, GuideModel.self)
        print(g?.amount as Any)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

