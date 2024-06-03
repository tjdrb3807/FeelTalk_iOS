//
//  DefaultAnswerCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultAnswerCoordinator: AnswerCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var answerViewController: AnswerViewController
    var type: CoordinatorType = .answer
    
    var model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.answerViewController = AnswerViewController()
    }
    
    func start() {
        let viewModel = AnswerViewModel(coordinator: self,
                                        questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository(), userRepository: DefaultUserRepository()),
                                        userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))

        self.model
            .bind(to: viewModel.model)
            .disposed(by: disposeBag)
        
        self.answerViewController.viewModel = viewModel
        self.answerViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(self.answerViewController, animated: false)
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
    }
    
    func finish() {
        self.type = .answered
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
