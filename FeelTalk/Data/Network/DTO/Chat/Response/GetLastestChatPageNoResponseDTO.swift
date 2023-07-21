//
//  GetLastestChatPageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct GetLastestChatPageNoResponseDTO: Decodable {
    let pageNo: Int?
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}
