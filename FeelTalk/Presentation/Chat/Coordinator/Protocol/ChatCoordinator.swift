//
//  ChatCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import Foundation

protocol ChatCoordinator: Coordinator {
    var chatViewController: ChatViewController { get set }
}
