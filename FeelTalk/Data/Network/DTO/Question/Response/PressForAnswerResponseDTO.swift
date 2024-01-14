//
//  PressForAnswerResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/10.
//

import Foundation

struct PressForAnswerResponseDTO: Decodable {
    let chatIndex: Int
    let chatPageIndex: Int
    let isRead: Bool
    let createAt: String
    
    enum CodingKeys: String, CodingKey {
        case chatIndex = "index"
        case chatPageIndex = "pageIndex"
        case isRead
        case createAt
    }
}
