//
//  Signal.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/28.
//

import Foundation

struct Signal {
    var type: SignalType
}

extension Signal {
    func toDTO() -> ChangeMySignalRequestDTO {
        var mySignal: Int
        
        switch type {
        case .sexy:
            mySignal = 100
        case .love:
            mySignal = 75
        case .ambiguous:
            mySignal = 50
        case .refuse:
            mySignal = 25
        case .tired:
            mySignal = 0
        }
        
        return .init(mySignal: mySignal)
    }
}
