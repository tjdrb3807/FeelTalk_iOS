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

extension Int {
    func toSignalType() -> SignalType? {
        switch self {
        case 100:
            return .sexy
        case 75:
            return .love
        case 50:
            return .ambiguous
        case 25:
            return .refuse
        case 0:
            return .tired
        default:
            return nil
        }
    }
}

extension SignalType {
    func mapping(percentStr: String) -> SignalType? {
        switch percentStr {
        case "100":
            return .sexy
        case "75":
            return .love
        case "50":
            return .ambiguous
        case "25":
            return .refuse
        case "0":
            return .tired
        default:
            break
        }
        
        return nil
    }
    
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
