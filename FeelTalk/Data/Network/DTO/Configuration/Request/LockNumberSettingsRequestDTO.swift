//
//  LockNumberSettingsRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/12.
//

import Foundation

struct LockNumberSettingsRequestDTO: Encodable {
    let lockNumber: String
    let hintType: String
    let correctAnswer: String
    
    init(lockNumber: String, lockNumberHintType: LockNumberHintType, correctAnswer: String) {
        self.lockNumber = lockNumber
        self.hintType = lockNumberHintType.rawValue
        self.correctAnswer = correctAnswer
    }
}
