//
//  SendQuestionChatResponseDTO.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/20.
//

import Foundation


struct SendQuestionChatResponseDTO: Decodable {
    let index: Int
    let pageNo: Int
    let isRead: Bool
    let createAt: String
    let chatSender: String
    let coupleQuestion: CoupleQuestionDTO
}

struct CoupleQuestionDTO: Decodable {
    let index: Int
    let title: String
    let selfAnswer: String?
    let partnerAnswer: String?
    let createAt: String
}
