//
//  InviteCodeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation

struct InviteCodeResponseDTO: Decodable {
    let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case inviteCode
    }
}
