//
//  KeychainAuthTokenStore.swift
//  FeelTalk
//
//  Concrete implementation of AuthTokenStore.
//
//  Created by 전성규 on 2/24/26.
//

import Foundation

final class KeychainAuthTokenStore: AuthTokenStore {
    
    // MARK: - Save
    @discardableResult
    func saveAccessToken(_ token: String) -> Bool { KeychainRepository.addItem(value: "accessToken", key: token) }
    
    @discardableResult
    func saveRefreshToken(_ token: String) -> Bool { KeychainRepository.addItem(value: "refreshToken", key: token) }
    
    @discardableResult
    func saveExpiredTime(_ expiredTime: String) -> Bool { KeychainRepository.addItem(value: "expiredTime", key: expiredTime) }
    
    @discardableResult
    func saveUserState(_ stateRawValue: String) -> Bool { KeychainRepository.addItem(value: "userState", key: stateRawValue) }
    
    // MARK: - Load
    func loadAccessToken() -> String? { KeychainRepository.getItem(key: "accessToken") as? String }
    
    func loadRefreshToken() -> String? { KeychainRepository.getItem(key: "refreshToken") as? String }
    
    func loadExpiredTime() -> String? { KeychainRepository.getItem(key: "expiredTime") as? String }
    
    func loadUserStateRawValue() -> String? { KeychainRepository.getItem(key: "userState") as? String }
    
    // MARK: - Clear
    @discardableResult
    func clearTokens() -> Bool {
        let accessDeleted = KeychainRepository.deleteItem(key: "accessToken")
        let refreshDeleted = KeychainRepository.deleteItem(key: "refreshToken")
        let expiredDeleted = KeychainRepository.deleteItem(key: "expiredTime")
        let stateDeleted = KeychainRepository.deleteItem(key: "userState")
        
        return accessDeleted && refreshDeleted && expiredDeleted && stateDeleted
    }
    
}
