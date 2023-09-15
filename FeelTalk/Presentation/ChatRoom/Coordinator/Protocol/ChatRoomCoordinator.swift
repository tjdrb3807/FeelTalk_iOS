//
//  ChatRoomCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/11.
//

import UIKit

protocol ChatRoomCoodinator: Coordinator {
    var chatRoomViweController: ChatRoomViewController { get set }
}
