//
//  DefaultChatRoomCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/11.
//

import UIKit

final class DefaultChatRoomCoordinator: ChatRoomCoodinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var chatRoomViweController: ChatRoomViewController
    var type: CoordinatorType = .chat
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatRoomViweController = ChatRoomViewController()
    }
    
    func start() {
        
    }
}
