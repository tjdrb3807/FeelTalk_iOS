//
//  SendTextChatResponseDTO.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/03/08.
//

import Foundation

struct SendChatResponseDTO: Decodable {
    let index: Int
    let pageIndex: Int
    let isRead: Bool
    let createAt: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case pageIndex
        case isRead
        case createAt
    }
}
