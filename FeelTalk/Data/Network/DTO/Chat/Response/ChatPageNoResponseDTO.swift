//
//  ChatPageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import Foundation

struct ChatPageNoResponseDTO: Decodable {
    let pageNo: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}
