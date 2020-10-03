//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
// 
//  Converted to Swift 5.1 by Swiftify v5.1.30744 - https://objectivec2swift.com/



import UIKit
import Foundation
import CommonCrypto
//import CryptoKit


class EncryptionTool {
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
}


extension String {
    //MD5,SHA1,SHA224,SHA256,SHA384,SHA512 加密
    func crypto(type: EncryptionTool.CryptoAlgorithm) -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:type.digestLength)
        switch type {
        case .MD5:
            data.withUnsafeBytes { 
                _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
            }
        case .SHA1:
            data.withUnsafeBytes { 
                _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
            }
        case .SHA224:
            data.withUnsafeBytes { 
                _ = CC_SHA224($0.baseAddress, CC_LONG(data.count), &digest)
            }
        case .SHA256:
            data.withUnsafeBytes { 
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
        case .SHA384:
            data.withUnsafeBytes { 
                _ = CC_SHA384($0.baseAddress, CC_LONG(data.count), &digest)
            }
        case .SHA512:
            data.withUnsafeBytes { 
                _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
            }
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }.joined()
        return hexBytes
    }
    
    
    // MARK: - 散列函数
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
            while autoreleasepool(invoking: {
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes{
                        _ = CC_MD5_Update(&hashCtx, $0.baseAddress, numericCast(data.count))
                    }
                    return true // Continue
                } else {
                    return false // End of file
                }
            }) {
                
            }
            
            
            //计算Md5摘要
            var digest = Data(count:Int(CC_MD5_DIGEST_LENGTH))
            
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0.bindMemory(to: UInt8.self).baseAddress, &hashCtx)
            }
            
            return digest.map{String(format: "%02hhx", $0)}.joined()
            
        } catch  {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
        
    }
    
    
    
    /**复杂的加密
     parama1:上面的枚举值 MD5, SHA1, SHA224, SHA256, SHA384, SHA512
     parama2: 加密的字符串
     */
    func hmac(algorithm: EncryptionTool.CryptoAlgorithm, key: String) -> String {
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
    
    func hmacc(algorithm: EncryptionTool.CryptoAlgorithm, key: String) -> String {
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
        waitSignStr += "&key=uUwUCQTvZ70$a37Pf!CJhodg0u0$!Uw9"
        
        printLog("加密串:     \(waitSignStr)")
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
    ///链式加密
    var sha1: String {
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
            _ = CC_SHA1($0.baseAddress, CC_LONG(count), &bytes)
        }
        return Data(bytes: bytes, count: bytes.count)
    }
    
    var hexString: String {
        return map { String(format: "%02x", UInt8($0)) }.joined()
    }
    
}











///Swift 5的一个版本，该版本在iOS 13上使用CryptoKit，否则回落到CommonCrypto：
import CommonCrypto
import CryptoKit
extension Data {
    public var sha1: String {
        if #available(iOS 13.0, *) {
            return hexString2(Insecure.SHA1.hash(data: self).makeIterator())
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            self.withUnsafeBytes { bytes in
                _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
            }
            return hexString2(digest.makeIterator())
        }
    }
    
    private func hexString2(_ iterator: Array<UInt8>.Iterator) -> String {
        return iterator.map { String(format: "%02x", $0) }.joined()
    }
    
}

//用法：
//let string = "The quick brown fox jumps over the lazy dog"
//let hexDigest = string.data(using: .ascii)!.sha1
//assert(hexDigest == "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12")
