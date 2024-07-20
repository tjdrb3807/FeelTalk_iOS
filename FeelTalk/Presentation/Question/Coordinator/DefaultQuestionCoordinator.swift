//
//  DefaultQuestionCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultQuestionCoordinator: QuestionCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var questionViewController: QuestionViewController
    var type: CoordinatorType = .question
    
    var model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.questionViewController = QuestionViewController()
    }
    
    func start() {
        self.questionViewController.viewModel = QuestionViewModel(coordiantor: self,
                                                                  questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository(),
                                                                                                          userRepository: DefaultUserRepository()))
        self.navigationController.pushViewController(questionViewController, animated: true)
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
    
    func showChatFlow() {
        let chatCoordinator = DefaultChatCooridnator(self.navigationController)
        
        childCoordinators.append(chatCoordinator)
        chatCoordinator.finishDelegate = self
        chatCoordinator.start()
    }
    
    func reloadTodayQuestion() {
        questionViewController.viewModel.reloadTodayQuestion()
    }
}

extension DefaultQuestionCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
//        case .answer:
//            showChatFlow()
        case .answer, .answered,:
            reloadTodayQuestion()
        case .chatFromBottomSheet:
            showChatFlow()
        default:
            break
        }
        
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
