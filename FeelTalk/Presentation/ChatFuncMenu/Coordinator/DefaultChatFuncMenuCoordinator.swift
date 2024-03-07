//
//  DefaultChatFuncMenuCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/19.
//

import UIKit

final class DefaultChatFuncMenuCoordinator: ChatFuncMenuCoordinator {
    var chatFuncMenuVC: ChatFuncMenuViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chatFuncMenu
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatFuncMenuVC = ChatFuncMenuViewController()
    }
    
    func start() {
        let chatFuncMenuVM = ChatFuncMenuViewModel(
            coordinator: self,
            questionUseCase: DefaultQuestionUseCase(
                questionRepository: DefaultQuestionRepository(),
                userRepository: DefaultUserRepository()),
            challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
        
        chatFuncMenuVC.viewModel = chatFuncMenuVM
        chatFuncMenuVC.modalPresentationStyle = .fullScreen
        navigationController.present(chatFuncMenuVC, animated: true)
    }
    
    func dismiss() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: true)
    }
}
