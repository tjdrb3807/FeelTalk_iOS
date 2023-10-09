//
//  DefaultBreakUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit

final class DefaultBreakUpCoordinator: BreakUpCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var breakUpViewController: BreakUpViewController
    var type: CoordinatorType = .breakUp
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.breakUpViewController = BreakUpViewController()
    }
    
    func start() {
        self.breakUpViewController.viewModel = BreakUpViewModel(coordinator: self,
                                                                configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
        self.breakUpViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(breakUpViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func dismiss() {
        print("dismiss")
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true)
    }
}
