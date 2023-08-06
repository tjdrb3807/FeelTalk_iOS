//
//  DefaultQuestionCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit

final class DefaultQuestionCoordinator: QuestionCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var questionViewController: QuestionViewController
    var type: CoordinatorType = .question
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.questionViewController = QuestionViewController()
    }
    
    func start() {
        self.questionViewController.viewModel = QuestionViewModel(coordiantor: self,
                                                                  questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository()))
        self.navigationController.pushViewController(questionViewController, animated: true)
    }
    
    func showAnswerFlow(with question: Question) {
        let answerCoordinator = DefaultAnswerCoordinator(self.navigationController)
        answerCoordinator.finishDelegate = self
        self.childCoordinators.append(answerCoordinator)
        answerCoordinator.question = question
        answerCoordinator.start()
    }
}

extension DefaultQuestionCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
