//
//  TextChatModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/18.
//

import Foundation

struct TextChatModel: ChatModel {
    var index: Int
    var type: ChatType
    var isMine: Bool
    var isRead: Bool
    var isSend: Bool
    var createAt: String
    var chatLocation: ChatLocation
    let message: String
}
