//
//  LockNumberHintTypeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/14.
//

import Foundation

struct LockNumberHintTypeResponseDTO: Decodable {
    let lockNumberHintType: String
    
    enum CodingKeys: String, CodingKey {
        case lockNumberHintType = "questionType"
    }
}
