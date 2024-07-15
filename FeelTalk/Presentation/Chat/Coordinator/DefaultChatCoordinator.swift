//
//  DefaultChatCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit

final class DefaultChatCooridnator: ChatCoordinator {
    var chatViewController: ChatViewController
    var chatViewNC: UINavigationController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatViewController = ChatViewController()
        self.chatViewNC = UINavigationController(rootViewController: chatViewController)
        self.chatViewNC.view.backgroundColor = .clear
        self.chatViewNC.navigationBar.isHidden = true
    }
    
    func start() {
        self.navigationController.tabBarController?.tabBar.isHidden = true
        self.navigationController.navigationBar.isHidden = true
        
        self.chatViewController.viewModel = ChatViewModel(
            coordinator: self,
            userUseCase: DefaultUserUseCase(
                userRepository: DefaultUserRepository()
            ),
            chatUseCase: DefaultChatUseCase(
                chatRepository: DefaultChatRepository()
            ),
            signalUseCase: DefaultSignalUseCase(
                signalRepositroy: DefaultSignalRepository()
            )
        )
        self.chatViewNC.modalPresentationStyle = .overFullScreen
        
        self.navigationController.present(chatViewNC, animated: false)
    }
    
    func showChatFuncMenuFlow() {
        let chatFuncMenuCN = DefaultChatFuncMenuCoordinator(chatViewNC)
        chatFuncMenuCN.start()
        childCoordinators.append(chatFuncMenuCN)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
