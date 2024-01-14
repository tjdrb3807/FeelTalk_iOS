//
//  GetPartnerSignalResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation

struct GetPartnerSignalResponseDTO: Decodable {
    let partnerSignal: Int
    
    enum CodingKeys: String, CodingKey {
        case partnerSignal
    }
}

extension GetPartnerSignalResponseDTO {
    func toDomain() -> Signal {
        var type: SignalType
        
        if partnerSignal == 100 {
            type = .sexy
        } else if partnerSignal == 75 {
            type = .love
        } else if partnerSignal == 50 {
            type = .ambiguous
        } else if partnerSignal == 25 {
            type = .refuse
        } else {
            type = .tired
        }
        
        return .init(type: type)
    }
}
