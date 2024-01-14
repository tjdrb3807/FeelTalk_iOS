//
//  InviteCodeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/18.
//

import Foundation

struct InviteCodeResponseDTO: Decodable {
    let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case inviteCode
    }
}
