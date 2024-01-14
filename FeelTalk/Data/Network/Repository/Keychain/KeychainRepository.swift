//
//  KeychainRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation
import Security

final class KeychainRepository {
    static func addItem(value: Any, key: Any) -> Bool {
        print("[CALL]: KeychainRepository.addItem(value:key:)")
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: key,
                                     kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                print("[SUCCESS]: Add \(key) item.")
                return true
            } else if status == errSecDuplicateItem {
                return updateItem(value: value, key: key)
            }
            
            debugPrint("[FAIL]: Add \(key) item error. - \(status.description)")
            return false
        }()
        
        return result
    }
    
    static func getItem(key: Any) -> Any? {
        print("[CALL]: KeychainRepository.getItem(key:)")
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: key,
                              kSecReturnAttributes: true,
                                    kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                print("[SUCCESS]: Get \(key) item.")
                return password
            }
        }
        
        debugPrint("[FIAL]: Get \(key) item - \(result.description)")
        return nil
    }
    
    static func updateItem(value: Any, key: Any) -> Bool {
        print("[CALL]: KeychainRepositroy.updateItem(value:)")
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                          kSecAttrAccount: key]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess {
                print("[SUCCESS]: Update \(key) item.")
                return true
            }
            
            debugPrint("[FAIL]: Update \(key) item - \(status.description)")
            return false
        }()
        
        return result
    }
    
    static func deleteItem(key: String) -> Bool {
        print("[CALL]: KeychainRepository.deleteItem(key:)")
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        if status == errSecSuccess {
            print("[SUCCESS]: Delete \(key) item.")
            return true
        }
        
        debugPrint("[FIAL]: Delete \(key) item - \(status.description) ")
        return false
    }
}

extension KeychainRepository {
    static func setExpiredTime() -> String {
        let expiredTime = Date(timeIntervalSinceNow: 3600)
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let expiredTimeStr = formatter.string(from: expiredTime)
        
        return expiredTimeStr
    }
}
