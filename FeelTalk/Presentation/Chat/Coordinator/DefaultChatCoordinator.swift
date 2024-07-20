//
//  DefaultChatCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit
import SwiftUI

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
        
        let userRepository = DefaultUserRepository()
        self.chatViewController.viewModel = ChatViewModel(
            coordinator: self,
            userUseCase: DefaultUserUseCase(
                userRepository: userRepository
            ),
            chatUseCase: DefaultChatUseCase(
                chatRepository: DefaultChatRepository()
            ),
            signalUseCase: DefaultSignalUseCase(
                signalRepositroy: DefaultSignalRepository()
            ),
            questionUseCase: DefaultQuestionUseCase(
                questionRepository: DefaultQuestionRepository(),
                userRepository: userRepository
            ),
            challengeUseCase: DefaultChallengeUseCase(
                challengeRepository: DefaultChallengeRepository()
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
    
    func showAnswerSheetFlow(question: Question) {
        finish()
        
        let answerCoordinator = DefaultAnswerCoordinator(self.navigationController)
        childCoordinators.append(answerCoordinator)
        answerCoordinator.finishDelegate = self.finishDelegate
        answerCoordinator.start()
        
        answerCoordinator.model.accept(question)
    }
    
    func showChallengeDetailFlow(challenge: Challenge) {
        let challengeDetailCoordinator = DefaultChallengeDetailCoordinator(chatViewNC)
        challengeDetailCoordinator.start()
        childCoordinators.append(challengeDetailCoordinator)
        
        challengeDetailCoordinator.challengeModel.accept(challenge)
    }
    
    func showImageDeatilFlow(chat: ImageChat, ownerNickname: String, ownerSignal: Signal) {
        let imageDetailController = UIHostingController(
            rootView: ImageDetailView(
                chat: chat,
                ownerNickname: ownerNickname,
                ownerSignal: ownerSignal,
                onBack: { [weak self] in
                    self?.chatViewNC.popViewController(animated: true)
                }
            )
        )
        
        chatViewNC.pushViewController(imageDetailController, animated: true)
    }
    
    func showImageShareFlow(image: UIImage) {
        if chatViewNC.viewControllers.contains(
            where:{ $0 is UIHostingController<ImageShareView> }
        ) {
            return
        }
        
        let imageShareController = UIHostingController(
            rootView: ImageShareView(
                image: image,
                onBack: { [weak self] in
                    self?.chatViewNC.popViewController(animated: true)
                }
            )
        )
        
        chatViewNC.pushViewController(imageShareController, animated: true)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
