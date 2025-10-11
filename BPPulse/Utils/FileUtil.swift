//
//  PLFileUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

@propertyWrapper
public struct CodableUserDefaults<T: Codable> {
    public let key: String
    public let defaultValue: T

    public var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Error decoding value for key \(key): \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: key)
                UserDefaults.standard.synchronize()
            } catch {
                print("Error encoding value for key \(key): \(error)")
            }
        }
    }

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension KeyedDecodingContainer {

    public func decodeStringIfPresentAndIsStringOrInt(forKey key: KeyedDecodingContainer<K>.Key) -> String? {
        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let intValue = try? self.decodeIfPresent(Int.self, forKey: key) {
            return String(intValue)
        }

        return nil
    }
    
    public func decodeStringIfPresentAndIsStringOrInt64(forKey key: KeyedDecodingContainer<K>.Key) -> String? {
        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let intValue = try? self.decodeIfPresent(Int64.self, forKey: key) {
            return String(intValue)
        }

        return nil
    }

    public func decodeIntIfPresentAndIsStringOrInt(forKey key: KeyedDecodingContainer<K>.Key) -> Int? {
        if let intValue = try? self.decodeIfPresent(Int.self, forKey: key) {
            return intValue
        }

        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return Int(stringValue)
        }

        return nil
    }
    
    public func decodeInt64IfPresent(forKey key: KeyedDecodingContainer<K>.Key) -> Int64? {
        if let intValue = try? self.decodeIfPresent(Int64.self, forKey: key) {
            return intValue
        }

        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return Int64(stringValue)
        }

        return nil
    }
    
    public func decodeCGFloatIfPresent(forKey key: KeyedDecodingContainer<K>.Key) -> CGFloat? {
        if let floatValue = try? self.decodeIfPresent(CGFloat.self, forKey: key) {
            return floatValue
        }
        
        if let intValue = try? self.decodeIfPresent(Int.self, forKey: key) {
            return intValue.cgFloat
        }

        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return stringValue.cgFloat()
        }

        return nil
    }
    
    public func decodeDoubleIfPresent(forKey key: KeyedDecodingContainer<K>.Key) -> Double? {
        if let doubleValue = try? self.decodeIfPresent(Double.self, forKey: key) {
            return doubleValue
        }
        
        if let intValue = try? self.decodeIfPresent(Int64.self, forKey: key) {
            return Double(intValue)
        }

        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            return Double(stringValue)
        }

        return nil
    }

    /// decode `Bool`
    /// true: Bool(true), Int(1), String("true"), String("1")
    /// false: Bool(false), Int(0), String("false"), String("0")
    public func decodeBoolIfPresentAndIsBoolOrStringOrInt(forKey key: KeyedDecodingContainer<K>.Key) -> Bool? {

        if let boolValue = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        }

        if let intValue = try? self.decodeIfPresent(Int.self, forKey: key) {
            switch intValue {
            case 0:
                return false
            case 1:
                return true
            default:
                break
            }
        }

        if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            switch stringValue {
            case "0", "false":
                return false
            case "1", "true":
                return true
            default:
                break
            }
        }

        return nil
    }

    public func decodeString(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: String = "") -> String {
        if let stringValue = self.decodeStringIfPresentAndIsStringOrInt(forKey: key) {
            return stringValue
        }

        return defaultValue
    }

    public func decodeStringExceptBlanksapce(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: String = "") -> String {
        if let stringValue = self.decodeStringIfPresentAndIsStringOrInt(forKey: key) {
            return stringValue == " " ? defaultValue : stringValue
        }

        return defaultValue
    }

    public func decodeStringWithoutNull(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: String = "") -> String {
        if let stringValue = self.decodeStringIfPresentAndIsStringOrInt(forKey: key), stringValue != "null" {
            return stringValue
        }

        return defaultValue
    }

    public func decodeInt(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: Int = 0) -> Int {
        if let intValue = self.decodeIntIfPresentAndIsStringOrInt(forKey: key) {
            return intValue
        }

        return defaultValue
    }
    
    public func decodeInt64(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: Int64 = 0) -> Int64 {
        if let intValue = self.decodeInt64IfPresent(forKey: key) {
            return intValue
        }

        return defaultValue
    }
    
    public func decodeCGFloat(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: CGFloat = 0) -> CGFloat {
        if let floatValue = self.decodeCGFloatIfPresent(forKey: key) {
            return floatValue
        }

        return defaultValue
    }
    
    public func decodeDouble(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: Double = 0) -> Double {
        if let doubleValue = self.decodeDoubleIfPresent(forKey: key) {
            return doubleValue
        }

        return defaultValue
    }

    public func decodeBool(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: Bool = false) -> Bool {
        if let boolValue = self.decodeBoolIfPresentAndIsBoolOrStringOrInt(forKey: key) {
            return boolValue
        }

        return defaultValue
    }

    
    public func decodeDateIfPresentGMTTimestamp(forKey key: KeyedDecodingContainer<K>.Key) -> Date? {
        if let timestamp = self.decodeIntIfPresentAndIsStringOrInt(forKey: key) {
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        return nil
    }
}

extension KeyedEncodingContainer {

    public mutating func encodeGMTTimestampIfPresent(_ value: Date?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try self.encodeIfPresent(value.timeIntervalSince1970, forKey: key)
        }
    }
}

/// 判断是否是数字
///
/// - Parameter string:
/// - Returns:
func isPurnInt(string: String) -> Bool {
    let scan: Scanner = Scanner(string: string)
    var val:Int = 0
    return scan.scanInt(&val) && scan.isAtEnd
}


extension Dictionary {
    var jsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
    
    var data: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
    
    var encoding: Data? {
        guard let str = self.jsonString else {
            return nil
        }

        guard let base64 = str.encodBase64() else {
            return nil
        }
        
        var ret: String = ""
        for uni in base64.unicodeScalars {
            var val = uni.value
            if val >= 0x41 && val <= 0x5A { // If in the range "A -"..."Y", just as an example
                val += 1 // or whatever ...
            }
            ret.append(Character(UnicodeScalar(val)!))
        }
        
        guard let data = ret.data(using: .utf8) else {
            return nil
        }
        
        return data
    }
    
}

extension String {
      //Base64编码
      func encodBase64() -> String? {
          if let data = self.data(using: .utf8) {
              return data.base64EncodedString()
          }
          return nil
      }
 
     //Base64解码
     func decodeBase64() -> String? {
         if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
             return String(data: data, encoding: .utf8)
         }
         return nil
     }
 }

extension Data {
    
    var decoding: Data? {
        
        guard let codeStr = String(data: self, encoding: .utf8) else {
            return nil
        }
        
        var ret: String = ""
        for uni in codeStr.unicodeScalars {
            var val = uni.value
            if val >= 0x42 && val <= 0x5B { // B - Z
                val -= 1 // or whatever ...
            }
            ret.append(Character(UnicodeScalar(val)!))
        }
        
        guard let base64Str = ret.decodeBase64() else {
            return nil
        }
        
        guard let data = base64Str.data(using: .utf8) else {
            return nil
        }
        
        return data
    }
    
}
