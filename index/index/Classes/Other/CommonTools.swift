
import UIKit

// MARK: - Size - UI常量

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenBounds = UIScreen.main.bounds
let ScreenScale = UIScreen.main.scale
let PlayerViewHeight: CGFloat = ScreenWidth * (750/1334)

///状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
///导航栏高度
let navigationHeight = statusBarHeight + 44
///tabbar高度
let tabBarHeight = CGFloat(statusBarHeight == 44 ? 83 : 49)

///顶部的安全距离
let topSafeAreaHeight = CGFloat(statusBarHeight == 44 ? 44 : 0)
///底部的安全距离
let bottomSafeAreaHeight = CGFloat(tabBarHeight - 49)

// MARK: - Color

let WHITE = RGB(r: 0xff, g: 0xff, b: 0xff, alpha: 1)
let BLUE = RGB(r: 0x00, g: 0x56, b: 0xff, alpha: 1)

// MARK: - String

private let ResourcePath = Bundle.main.path(forResource: "Resource", ofType: "bundle")

/// 加载 Resource.bundle 存放的图片
func ELPlayerImage(named: String) -> UIImage? {
    let imageName = ResourcePath?.appending("/\(named)")
    let image = UIImage(named: imageName!)
    return image
}

/// RGB 颜色
func RGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}

func RGBcolor(RGB : CGFloat) -> UIColor {
    return UIColor(red: RGB / 255.0, green: RGB / 255.0, blue: RGB / 255.0, alpha: 1)
}

/// 随机颜色
func randomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)
}

///16位颜色
public extension UIColor {
    public convenience init(colorHex : UInt32, alpha : CGFloat = 1.0) {
        let red = CGFloat((colorHex & 0xFF0000)   >> 16) / 255.0
        let green = CGFloat((colorHex & 0x00FF00) >> 8 ) / 255.0
        let blue = CGFloat((colorHex & 0x0000FF)       ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

/// 秒数转换为时间
func secondsConverToTimeStr(seconds: Int) -> String {
    if seconds >= 3600 {
        let hour = seconds / 3600
        let minute = (seconds - 3600*hour) / 60
        let second = seconds % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    } else {
        let minute = seconds / 60
        let second = seconds % 60
        return String(format: "%02d:%02d", minute, second)
    }
}

///大于一万播放次数格式化
func playCount(_ count : Int) -> String {
    if count >= 10000 {
        return String(format: "%.1f万播放", CGFloat(count) / 10000.0)
    } else {
        return String(format: "%zd次播放", count)
    }
}

// 自定义 Log
func printLog(_ message: Any, file: String = #file, line: Int = #line, function: String = #function)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(function): \(message)\n")
    #endif
}

///读取本地的文件
///
/// - Parameters:
///   - fileNameStr: 文件名称
///   - type: 文件类型
/// - Returns: 文件的数据
func readLocalData(fileNameStr:String,type:String) -> Any? {
    
    //读取本地的文件
    let path = Bundle.main.path(forResource: fileNameStr, ofType: type);
    let url = URL(fileURLWithPath: path!)
    // 带throws的方法需要抛异常
    do {
        /*
         * try 和 try! 的区别
         * try 发生异常会跳到catch代码中
         * try! 发生异常程序会直接crash
         */
        let data = try Data(contentsOf: url)
        let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return jsonData;
        
    } catch let error as Error? {
        return error!.localizedDescription;
    }
}

//let returnData=readLocalData(fileNameStr: "HeWeather", type: "json");
//print("返回的数据：\(returnData)");

///随机字符串
func randomSmallCaseString(length :Int) -> String {
    var output = ""
    for _ in 0..<length {
        let randomNumber = arc4random() % 26 + 97
        let randomChar = Character(UnicodeScalar(randomNumber)!)
        output.append(randomChar)
    }
    return output
}

/// 把时间戳和当前时间做比较，转换为xxx天前
func compareNowTimeToStr(time: Int) -> String {
    let nowTime = Int(Date().timeIntervalSince1970)
    let diffSecond = nowTime - time
    
    if diffSecond < 60 {
        return "\(diffSecond)秒前"
        
    } else if diffSecond < 3600 {
        let minute = diffSecond / 60
        return "\(minute)分钟前"
        
    } else if diffSecond < 3600*24 {
        let hour = diffSecond / 3600
        return "\(hour)小时前"
        
    } else {
        let day = diffSecond / (3600*24)
        return "\(day)天前"
    }
}

/// 时间转换
func convertToDate(time: Int) -> String {
    let timeDouble = Double(time)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    let date = Date(timeIntervalSince1970: timeDouble)
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

/// 获取时间长度
func getTimeLengthStr(length : Int) -> String {
    let minute = length / 60
    let second = length % 60
    
    return String(format: "%02d:%02d", minute, second)
}
