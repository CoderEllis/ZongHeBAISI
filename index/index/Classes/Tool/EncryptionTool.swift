//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
// 
//  Converted to Swift 5.1 by Swiftify v5.1.30744 - https://objectivec2swift.com/
class EncryptionTool {
    
}

import CommonCrypto
//import CryptoKit

extension String {
    ///散列函数
    func md5String() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
//        CC_MD5(str!, (CC_LONG)(strlen(str!)), result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    func sha1String() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_SHA1(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes { 
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        _ = digest.map { String(format: "%02x", $0) }
        return hexBytes.joined()
    }
    
    func sha256String() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    func sha512String() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA512(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
        
    }
    
    /**
     *  返回二进制 Bytes 流的字符串表示形式
     *
     *  @param bytes  二进制 Bytes 数组
     *  @param length 数组长度
     *
     *  @return 字符串表示形式
     */
    private func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.deallocate()
        return String(hash)
    }
    
    /**复杂的加密
     parama1:上面的枚举值 MD5, SHA1, SHA224, SHA256, SHA384, SHA512
     parama2: 加密的字符串
     */
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let keyStr = key.cString(using: .utf8)
        let keyLen = Int(key.lengthOfBytes(using: .utf8))
        
        let str = self.cString(using: .utf8)
        let strLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        let digest = stringFromResult(result: result, length: digestLen)
        result.deallocate()
        return digest
    }
    
    func hmacc(algorithm: CryptoAlgorithm, key: String) -> String {
        let cKey = key.cString(using: .utf8)
        
        let cData = self.cString(using: .utf8)
        var result = [CUnsignedChar](repeating: 0, count: algorithm.digestLength)
        CCHmac(algorithm.HMACAlgorithm, cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        
        let hmacData = Data(bytes: result, count: algorithm.digestLength)
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength76Characters)
        
        return hmacBase64
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    ///Base64编码 s->d->s
    func encodeToBase64() -> String {
        guard let data = self.data(using: .utf8) else {
            print("加密失败")
            return ""
        }
        return data.base64EncodedString(options: .init(rawValue: 0))
    }
    
    ///Base64解码 
    func decodeBase64() -> String {
        guard let data = Data(base64Encoded: self, options: .init(rawValue: 0)) else {
            print("解密失败")
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }
    
    
}




import UIKit
import Foundation
let FileHashDefaultChunkSizeForReadingData = 4096

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

// MARK: - 散列函数
extension String  {
        ///读取md5文件 path路径转字符串调用
    func fileMD5Hash() -> String? {
        let url = URL.init(fileURLWithPath: self)
        let bufferSize = 1024*1024
        
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            
            defer {
                file.closeFile()
            }
          
             //初始化内容
            var hashCtx = CC_MD5_CTX()
            CC_MD5_Init(&hashCtx)
            
             //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&hashCtx, $0, CC_LONG(data.count))
                }
            }
             //计算Md5摘要
            var digest = Data(count:Int(CC_MD5_DIGEST_LENGTH))
            
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &hashCtx)
            }
            
            return digest.map{String(format: "%02hhx", $0)}.joined()
            
        } catch  {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
        
    }
    
}
 
class SignUtil{
    var waitSignStr = String()
    init(datas: inout [String:String]){
        let keys = datas.sorted(by: {$0.0 < $1.0})
        //        let values = datas.sorted(by: {$0.1 < $1.1})//对value排序
        for(mkey , mvalue) in keys {
            if waitSignStr.isEmpty {
                if !mvalue.isEmpty {
                    waitSignStr = mkey + "=" + mvalue
                }else{
                    datas.removeValue(forKey: mkey)
                }
                
            } else {
                if !mvalue.isEmpty {
                    waitSignStr = waitSignStr + "&" + mkey + "=" + mvalue
                }else{
                    datas.removeValue(forKey: mkey)
                }
            }
        }
        waitSignStr = waitSignStr + "&key=uUwUCQTvZ70$a37Pf!CJhodg0u0$!Uw9"
        
        print("加密串:\(waitSignStr)")
    }
}

extension SignUtil {
    func signInfo() -> String{
        let hmacStr = waitSignStr.hmac(algorithm: .SHA1, key: "key")
        return hmacStr
    }
    
}
//使用,我这边是网络请求的时候加密参数用的,所以传的是字典,使用时根据实际情况而定
 



extension String {
    
    var sha12: String {
        guard let data = data(using: .utf8, allowLossyConversion: false) else {
            // Here you can just return empty string or execute fatalError with some description that this specific string can not be converted to data
            return "转换失败"
            
        }
        return data.digestSHA1.hexString
    }
    
}

fileprivate extension Data {
    
    var digestSHA1: Data {
        var bytes: [UInt8] = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(count), &bytes)
        }
        
        return Data(bytes: bytes)
    }
    
    var hexString: String {
        return map { String(format: "%02x", UInt8($0)) }.joined()
    }
    
}
