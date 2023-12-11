//
//  SignalType.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import Foundation

enum SignalType: String, Equatable {
    /// 100%
    case sexy
    /// 75%
    case love
    /// 50%
    case ambiguous
    /// 25%
    case refuse
    /// 0%
    case tired
}

extension SignalType {
    func mapping(_ rawValue: String) -> SignalType? {
        if let type = SignalType(rawValue: rawValue) {
            switch type {
            case .sexy:
                return .sexy
            case .love:
                return .love
            case .ambiguous:
                return .ambiguous
            case .refuse:
                return .refuse
            case .tired:
                return.tired
            }
        }
        
        return nil
    }
}
