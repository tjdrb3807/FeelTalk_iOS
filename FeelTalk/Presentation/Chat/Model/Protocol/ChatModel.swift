//
//  ChatModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

protocol ChatModel {
    var index: Int { get set }
    var type: ChatType { get set }
    var isMine: Bool { get set }
    var isRead: Bool { get set }
    var isSend: Bool { get set }
    var createAt: String { get set }
    var chatLocation: ChatLocation { get set }
}
