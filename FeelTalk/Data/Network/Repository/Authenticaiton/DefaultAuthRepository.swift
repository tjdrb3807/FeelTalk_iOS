//
//  AuthRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/11.
//

import Foundation
import Security

final class DefaultAuthRepository: AuthRepository {
    static let shared = DefaultAuthRepository()
    
    @discardableResult
    func create(token: String, key: String) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: token.data(using: .utf8) as Any]
        let status = SecItemAdd(query as CFDictionary, nil)
        
//        guard status == errSecSuccess else { return false }
        if status == errSecSuccess {
            print("[SUCCESS]: \(key) Keychain created.")
        } else if status == errSecDuplicateItem {
            update(token: token, key: key)
        } else {
            print("[ERROR]: \(key) Keychain create failed.")
        }
        
        return true
    }
    
    func read(key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: true,
                                    kSecReturnAttributes as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            debugPrint("[ERROR]: Keychain item not found.")
            
            return nil
        }
        
        guard status == errSecSuccess else {
            debugPrint("[ERROR]: Keychain read Error.")
            
            return nil
        }
        
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            print("[ERROR]: Keychain get token Faild.")
            
            return nil
        }
        
        return token
    }
    
    @discardableResult
    func update(token: String, key: String) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let attributes: [String: Any] = [kSecAttrAccount as String: key,
                                         kSecValueData as String: token.data(using: .utf8) as Any]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            debugPrint("[ERROR]: \(key) of Keychain item not found.")
            
            return false
        }
        
        guard status == errSecSuccess else {
            debugPrint("[ERROR]: \(key) of Keychain update Error.")
            
            return false
        }
        
        return true
    }
    
    @discardableResult
    func delete(key: String) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            debugPrint("[ERROR]: Keychain delete Error.")
            debugPrint(SecCopyErrorMessageString(status, nil) ?? "")
            
            return false
        }
        
        return true
    }
}
