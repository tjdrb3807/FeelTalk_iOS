//
//  UserStateResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

struct UserStateResponseDTO: Decodable {
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case state = "memberStatus"
    }
}
