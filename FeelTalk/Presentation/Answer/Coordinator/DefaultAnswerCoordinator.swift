//
//  DefaultAnswerCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

final class DefaultAnswerCoordinator: AnswerCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var answerViewController: AnswerViewController
    var type: CoordinatorType = .answer
    var question: Question?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.answerViewController = AnswerViewController()
    }
    
    func start() {
        let viewModel = AnswerViewModel(coordinator: self,
                                        questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository()))
        guard let question = question else { return }
        viewModel.model = question
        
        self.answerViewController.viewModel = viewModel
        self.answerViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(self.answerViewController, animated: false)
    }
    
    func finish() {
        self.navigationController.dismiss(animated: false)
    }
}
