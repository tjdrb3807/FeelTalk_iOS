//
//  AddChallengeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct AddChallengeResponseDTO: Decodable {
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case index
    }
}

