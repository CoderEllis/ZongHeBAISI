//
//  codableTest.swift
//  index
//
//  Created by Soul on 31/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import Foundation
  
//数据编码 Encoder  
//先来看一个实例，我们先声明一个实体类 Person
//Codable  String,Int,Double,Date,URL,Data 这些类都是实现了Codable
//如果你的自定义属性是其他类型，则需要注意一下它是否也实现了 Codable
struct Person : Codable {
    var name : String
    var gender : String
    var age : Int
}


//创建对应的model
//let dic = ["name":"wall" , "age":"22" , "h":"170"]
//转为data数据,这里其实要判断data是否为nil
//let data = try? JSONSerialization.data(withJSONObject: dic, options: [])


//除了声明Codable之外，这个实体类并没有其他代码，只有几个属性声明。 如果我们需要把他的实例编码成 JSON 字符串，可以这样：
let person = Person(name: "swift", gender: "male", age: 24)
//编码: Encoder
let encoder = JSONEncoder()
let data = try! encoder.encode(person)
let encodedString = String(data: data, encoding: .utf8)!
//print(encodedString) // 输出 {"name":"swift","age":24,"gender":"male"}
   //如上所示，首先初始化了一个  Person实例。 然后初始化了一个 JSONEncoder。 再调用它的encode 方法，把 person 实例进行编码。 让后整个 JSON 编码操作就完成了。
//if let jsonData = try? JSONEncoder().encode(person) {
//    if let jsonString = String(data: jsonData, encoding: .utf8) {
//        print(jsonString)
//    }
//}

///解码：Decoder 
//json字符串
let jsonString = "{\"name\":\"swift\",\"age\":22,\"gender\":\"female\"}"
let jsonData = jsonString.data(using: .utf8)!

let decoder = JSONDecoder()
let result = try! decoder.decode(Person.self, from: jsonData)

//print(result) // 输出： Person(name: "swift", gender: "female", age: 22)
//解析的时候用的是 JSONDecoder 对象，给他的 decode 方法传入要解析的实例类型 - Person.self,再加上要解析的数据对象jsonData就完成了 JSON 数据的解析

//plist  PropertyListDecoder 解码
//Swift 还为其他类型的数据提供了编解码能力， 比如 PropertyListEncoder可以编码 plist 数据格式。



///对指定属性编码
//默认情况下，如果声明继承了 Codable协议，这个实例中的所有属性都会被算作编码范围内。 如果你只想对一部分属性进行编解码，也是有办法的，可以在你的自定义类中声明一个 CodingKeys 枚举属性：
struct Person2 : Codable {
    
    var name: String
    var gender: String = ""
    var age: Int
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case age
        
    }
    //还是之前的 Person类，这次我们加入了 CodingKeys 属性，并且定义了两个枚举值 name和 age，只有在 CodingKeys 中指定的属性名才会进行编码，如果我们再次对 Person进行编码，得到的将会是这样的结果：{"name":"swift","age":24}
    //可以看到， gender 属性由于没有在 CodingKeys 中声明，所以不会被编码。
    //另外如果使用了 CodingKeys，那些没有在 CodingKeys中声明的属性就必须要要有一个默认值，我们上面的代码中其实给 gender 属性也声明了默认值。
}



//改变键值
//由于后台系统使用的命名规则有可能与前端不一致，比如后台字段返回下划线命名法，而一般我们使用驼峰命名法，所以在字段映射的时候就需要修改一下。
//主要有两种方式, 1 实现CodingKey协议 进行枚举映射。  2 通过Decoder的keyDecodingStrategy中convertFromSnakeCase统一转化
//我们还可以使用 CodingKeys改变编码属性的名称：
struct Person3 : Codable {
    
    var name: String
    var gender: String = ""
    var age: Int
    
    
    /// 自定义字段属性
    /// 注意 1.需要遵守Codingkey  2.每个字段都要枚举
    enum CodingKeys: String, CodingKey {
        
        case name = "title"
        case age
        
    }
    //还是以 Person 为例，这次我们在 CodingKeys 枚举中讲 name 属性重新定义为 title。 这个意思就是说，虽然在 Person 类中，这个属性名还是 name， 但在编码后的 JSON 中，它的属性名就应该是 title    。对上面这个类运行编码后，得到的结果是这样: {"title":"swift","age":24} JSON 中的第一个属性名变成了 title， 它对应 Person 类中的 name 属性。
}


///自定义编码过程
//你还可以自定义整个编码和解码过程。 对于稍复杂一些的数据结构，这个能力还是会经常用到的。 比如我们想给 Person 再加上身高和体重两个属性：
struct Persons4 : Codable {
    
    var name: String
    var gender: String = ""
    var age: Int
    
    var height: Int
    var weight: Int 
    
    enum CodingKeys: String, CodingKey {
        
        case name = "title"
        case age
        case body
        
    }
    
    enum BodyKeys: String, CodingKey {
        
        case height
        case weight
        
    }
    
}

//这里面新增的 height 和 width 属性，分别对应体重和身高。 并且还增加了另外一个属性 BodyKeys    。 为什么要添加这个属性呢？ 是因为我们这次准备把 height 和 width 放到一个单独的对象中。 下面这样解释可能会更直观一些，如果我们不添加 BodyKeys 属性，而是把他们直接定义到 CodingKeys 里面，那么生成的 JSON 结构大致是这样：
/*   
{
    "name" : xxx
    "age": xxx
    "height" : xxx
    "weight": xxx
}
 */

//但我们单独为 height 和 weight 定义了 BodyKeys 枚举属性。 并且把它有声明到了 CodingKeys 中。 这次 CodingKeys 多了一个 body 属性，它对应的就是 BodyKeys 这个枚举。 至于这个对应关系怎么确立的，稍后会讲到学什么技术好。
/*
{
    "name" : xxx
    "age": xxx
    "body": {
        "height" : xxx
        "weight": xxx
    }
}
 */


//这样我想应该就说明了 BodyKeys 的作用了。 这样声明完还不行，我们还需要手动的确立他们之间的对应关系，这就要重载 Codable 的两个方法：
extension Persons4 {
    // 用于解析数据
    init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try vals.decode(String.self, forKey: CodingKeys.name)
        age = try vals.decode(Int.self, forKey: CodingKeys.age)
        
        let body = try vals.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        height = try body.decode(Int.self, forKey: .height)
        weight = try body.decode(Int.self, forKey: .weight)
        //decoder.container()  方法首先获取 CodingKey 的对应关系，这里我们首先传入 CodingKeys.self  表示我们先前声明的类型。 然后调用 vals.decode()  方法，用于解析某个单独的属性。
        //接下来调用 vals.nestedContainer()  方法获取内嵌的层级，也就是我们先前声明的 BodyKeys。然后继续解析。
    }
    
    //用于编码数据
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        
        var body = container.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        try body.encode(weight, forKey: .weight)
        try body.encode(height, forKey: .height)
    }
    //如果我们对新的 Person 实例再进行编码，得到的将会是这样的结果：
    // {"title":"swift","age":24,"body":{"weight":80,"height":180}}
     
}

//model嵌套 
//假如要转换的数据结构如下
// let dic = ["name":"wall" , "age":"22" , "h":"170" , "school":["name":"北大"]] as [String : Any]
//school是一个单独的字典，所有model也要进行嵌套，model写法如下，跟一个model写法类似，小model也要遵循Codable协议。
struct Person5 :Codable {
    var name:String
    var age:Int
    var height:Int
    var school:School
    
    private enum CodingKeys : String , CodingKey {
        case name
        case age
        case height = "h"
        case school
    }
}

struct School : Codable {
    var name:String?    /// 不能确定一定会返回值或者可能返回null 时 建议使用可选
}


//重写Decode 和Encode 方法 
//多级嵌套字段属性转化

//如下json 直接获取二级字段作为属性

/// 示例json
let json = """
{
    "order":
    {
        "product_name": "Bananas",
        "product_cost": 10,
        "description": null
    }
}
""".data(using: .utf8)!
//模型定义，指明对应的CodingKey, 实现Encodable 和Decodable协议方法

/// 对象模型
struct GroceryProduct: Codable {
    var productName: String  // 第二层字段
    var productCost: Int     // 第二层字段
    
    /// 定义第一层嵌套 编码键
    private enum OrderKeys: CodingKey {
        case order
    }
    /// 定义第二层嵌套 编码键
    private enum CodingKeys: String, CodingKey {
        case productName
        case productCost
    }
    /// 实现 Decodable 协议 【tip: 代码提示不会显示init方法，建议进入协议内复制过来】
    /// 实现 键与属性的映射赋值
    init(from decoder: Decoder) throws{
        // 获取对应的容器
        let orderContainer = try decoder.container(keyedBy: OrderKeys.self)
        let container = try orderContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: OrderKeys.order)
        
        // 对属性赋值
        productName = try container.decode(String.self, forKey: .productName)
        productCost = try container.decode(type(of: productCost), forKey: .productCost)
    }
    
    func encode(to encoder: Encoder) throws{
        var orderContainer =  encoder.container(keyedBy: OrderKeys.self)
        var container = orderContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: OrderKeys.order)
        try container.encode(productName, forKey: .productName)
        try container.encode(productCost, forKey: .productCost)
    }











//下划线转化与自定义
//某些时候后台使用的是下划线命名法（比如mysql和python）,返回的字段名就是下滑线的。swift4.1之后可以自动将下划线命名转化为驼峰命名法。
//当然也可以用自定义属性来改变，但是如果字段过多怎很麻烦。

/// 示例json
let json = """
[
    {
        "product_name": "Bananas",
        "product_cost": 200,
        "description": "A banana grown in Ecuador."
    },
    {
        "product_name": "Oranges",
        "product_cost": 100,
        "description": "A juicy orange."
    }
]
""".data(using: .utf8)!
/// 对象模型
struct GroceryProduct: Codable {
    var productName: String
    var productCost: Int  // 不允许部分转化 部分不转 如product_cost会报错异常
    var description: String?
}

//let decoder = JSONDecoder()
/// 通过keyDecodingStrategy 来控制
//decoder.keyDecodingStrategy = .convertFromSnakeCase  // 编码策略  使用从蛇形转化为大写 encode时同样也可降驼峰命名法转化为下划线
//let products = try decoder.decode([GroceryProduct].self, from: json)
//其他自定义字段规则
//字段转化策略除了使用默认的和下划线转驼峰之外，还可以自定义转化规则。



/// 定义模型
struct Address: Codable {
    var street: String
    var zip: String
    var city: String
    var state: String
}

/// 重点  实现CodingKey协议
struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}


//转化模型
//let jsonString = """
//{"State":"California","Street":"Apple Bay Street","Zip":"94608","City":"Emeryville"}
//"""
//
//let decoder = JSONDecoder()
///// 建议custom 使用扩展KeyDecodingStrategy [方便管理]
//decoder.keyDecodingStrategy = .custom({ (keys) -> CodingKey in
//    // 转化规则
//    let lastKey = keys.last!
//    guard lastKey.intValue == nil else { return lastKey }
//    let stringValue = lastKey.stringValue.prefix(1).lowercased() + lastKey.stringValue.dropFirst()  /// 将首字母大写的转化为小写的
//    return AnyKey(stringValue: stringValue)!
//})
//
//if let jsonData = jsonString.data(using: .utf8), let address = try? decoder.decode(Address.self, from: jsonData) {
//    print(address)
//}

/*
 prints:
 Address(street: "Apple Bay Street", zip: "94608", city: "Emeryville", state: "California")
*/
}
