//
//  GetConfigurationInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetConfigurationInfoResponseDTO: Decodable {
    let isLock: Bool
    
    enum CodingKeys: String, CodingKey {
        case isLock = "lock"
    }
}

extension GetConfigurationInfoResponseDTO {
    func toDomain() -> ConfigurationInfo {
        .init(isLock: isLock)
    }
}
