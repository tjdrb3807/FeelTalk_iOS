//
//  GetLatestChatPageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

struct GetLatestChatPageNoResponseDTO: Decodable {
    let pageNo: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}
