//
//  SendChallengeChatResponseDTO.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/20.
//

import Foundation

struct SendChallengeChatResponseDTO: Decodable {
    let index: Int
    let isRead: Bool
    let createAt: String
    let coupleChallenge: ChallengeChatResponseDTO
}
