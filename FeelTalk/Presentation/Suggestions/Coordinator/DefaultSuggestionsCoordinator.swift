//
//  DefaultSuggestionsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import UIKit

final class DefaultSuggestionsCoordinator: SuggestionsCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var suggestionsViewController: SuggestionsViewController
    var type: CoordinatorType = .suggestions
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.suggestionsViewController = SuggestionsViewController()
    }
    
    func start() {
        self.suggestionsViewController.viewModel = SuggestionsViewModel(coordinator: self,
                                                                        useCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
        self.suggestionsViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(suggestionsViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true)
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
