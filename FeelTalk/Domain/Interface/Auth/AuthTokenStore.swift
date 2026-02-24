//
//  AuthTokenStore.swift
//  FeelTalk
//
//  Domain Layer interface for token persistence.
//  Created by 전성규 on 2/24/26.
//

import Foundation

protocol AuthTokenStore {
    // MARK: - Save
    @discardableResult
    func saveAccessToken(_ token: String) -> Bool
    
    @discardableResult
    func saveRefreshToken(_ token: String) -> Bool
    
    // Example: "2026-02-24 12:34:56" (existing code stores String)
    @discardableResult
    func saveExpiredTime(_ expiredTime: String) -> String
    
    @discardableResult
    func saveUserState(_ stateRawValue: String) -> Bool
    
    // MARK: - Load
    func loadAccessToken() -> String?
    func loadRefreshToken() -> String?
    func loadExpiredTime() -> String?
    func loadUserStateRawValue() -> String?
    
    // MARK: - Clear
    @discardableResult
    func clearTokens() -> Bool
}
