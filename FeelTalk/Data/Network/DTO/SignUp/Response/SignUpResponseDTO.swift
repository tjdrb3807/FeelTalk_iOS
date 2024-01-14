//
//  SignUpResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/18.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let memberId: Int
    
    enum CodingKeys: String, CodingKey {
        case memberId
    }
}
