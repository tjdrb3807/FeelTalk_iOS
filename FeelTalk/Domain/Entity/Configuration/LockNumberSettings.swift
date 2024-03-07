//
//  LockNumberSettings.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/14.
//

import Foundation

struct LockNumberSettings {
    let lockNumber: String
    let hintType: LockNumberHintType
    let correctAnswer: String
}

extension LockNumberSettings {
    public func toDTO() ->LockNumberSettingsRequestDTO {
        .init(lockNumber: self.lockNumber,
              lockNumberHintType: self.hintType,
              correctAnswer: self.correctAnswer)
    }
}
