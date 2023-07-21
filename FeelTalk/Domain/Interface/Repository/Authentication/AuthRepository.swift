//
//  AuthRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/11.
//

import Foundation

protocol AuthRepository {
    @discardableResult
    func create(token: String, key: String) -> Bool
    
    func read(key: String) -> String?
    
    @discardableResult
    func update(token: String, key: String) -> Bool
    
    @discardableResult
    func delete(key: String) -> Bool
}
