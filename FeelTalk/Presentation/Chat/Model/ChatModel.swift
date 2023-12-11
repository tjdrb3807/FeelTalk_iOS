//
//  ChatModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import Foundation

protocol ChatModel {
    var index: Int { get set }
    var isMine: Bool { get set }
    var isRead: Bool { get set }
    var createAt: String { get set }
}
