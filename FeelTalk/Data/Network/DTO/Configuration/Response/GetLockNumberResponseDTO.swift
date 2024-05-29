//
//  GetLockNumberResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/14.
//

import Foundation

struct GetLockNumberResponseDTO: Decodable {
    let lockNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case lockNumber = "password"
    }
}
