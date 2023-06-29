//
//  TestChatModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation

struct TestChatModel {
    enum ChatSender: CaseIterable {
        case partner
        case my
    }
    
    let message: String
    let chatSender: ChatSender
    let isRead: Bool
}
