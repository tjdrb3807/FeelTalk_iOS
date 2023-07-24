//
//  CoupleRegistrationObserver.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/23.
//

import Foundation

class CoupleRegistrationObserver {
    static let shared = CoupleRegistrationObserver()
    
    
    var isCoupleRegistrationCompleted: Bool = false {
        didSet {
            if isCoupleRegistrationCompleted {
                onCompleted()
            }
        }
    }
    var onCompleted: () -> Void = {}

    
    func registerCompletedListener(_ onCompleted: @escaping () -> Void) {
        self.onCompleted = onCompleted
    }
    
    func set(isCoupleRegistrationCompleted: Bool) {
        self.isCoupleRegistrationCompleted = isCoupleRegistrationCompleted
    }
}
