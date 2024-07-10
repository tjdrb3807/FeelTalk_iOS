//
//  DefaultHomeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultHomeCoordinator: HomeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var homeViewController: HomeViewController
    var type: CoordinatorType = .home
    
    var model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        homeViewController.viewModel = HomeViewModel(coordinator: self,
                                                     qustionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository(),
                                                                                            userRepository: DefaultUserRepository()),
                                                     signalUseCase: DefaultSignalUseCase(signalRepositroy: DefaultSignalRepository()))
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func showAnswerFlow() {
        let answerCoordinator = DefaultAnswerCoordinator(self.navigationController)
        
        model
            .bind(to: answerCoordinator.model)
            .disposed(by: disposeBag)
        
        childCoordinators.append(answerCoordinator)
        answerCoordinator.finishDelegate = self
        answerCoordinator.start()
    }
    
    func showSignalFlow() {
        let signalCoordinator = DefaultSignalCoordinator(self.navigationController)
        
        childCoordinators.append(signalCoordinator)
        signalCoordinator.finishDelegate = self
        signalCoordinator.start()
    }
    
    func showChatFlow() {
        let chatCoordinator = DefaultChatCooridnator(self.navigationController)
        
        childCoordinators.append(chatCoordinator)
        chatCoordinator.finishDelegate = self
        chatCoordinator.start()
    }
}

extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .signal:
            homeViewController.viewModel.reloadObservable.accept(.signal)
        case .answer:
            homeViewController.viewModel.reloadObservable.accept(.todayQuestion)
//            showChatFlow()
        case .chatFromBottomSheet:
            showChatFlow()
        default:
            break
        }
        
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
