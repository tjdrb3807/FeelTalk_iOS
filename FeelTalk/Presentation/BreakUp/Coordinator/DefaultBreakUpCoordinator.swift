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
        let vm = BreakUpViewModel(coordinator: self,
                                  configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
        self.breakUpViewController.viewModel = vm
        self.breakUpViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(breakUpViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func dismiss() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: true)
    }
}
