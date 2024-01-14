//
//  DefaultChatCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit

final class DefaultChatCooridnator: ChatCoordinator {
    var chatViewController: ChatViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatViewController = ChatViewController()
    }
    
    func start() {
        self.navigationController.tabBarController?.tabBar.isHidden = true
        self.navigationController.navigationBar.isHidden = true
        
        self.chatViewController.viewModel = ChatViewModel(coordinator: self,
                                                          userUseCase: DefaultUserUseCase(
                                                            userRepository: DefaultUserRepository()),
                                                          chatUseCase: DefaultChatUseCase(
                                                            chatRepository: DefaultChatRepository()))
        self.chatViewController.modalPresentationStyle = .overFullScreen
        
        self.navigationController.present(chatViewController, animated: false)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
