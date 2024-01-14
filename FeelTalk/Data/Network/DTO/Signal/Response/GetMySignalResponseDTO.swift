//
//  GetMySignalResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation

struct GetMySignalResponseDTO: Decodable {
    let mySignal: Int
    
    enum CodingKeys: String, CodingKey {
        case mySignal
    }
}

extension GetMySignalResponseDTO {
    func toDomain() -> Signal {
        var type: SignalType
        
        if mySignal == 100 {
            type = .sexy
        } else if mySignal == 75 {
            type = .love
        } else if mySignal == 50 {
            type = .ambiguous
        } else if mySignal == 25 {
            type = .refuse
        } else {
            type = .tired
        }
        
        return .init(type: type)
    }
}
