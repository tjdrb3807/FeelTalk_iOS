//
//  DefaultSplashCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/21.
//

import UIKit

final class DefaultSplashCoordinator: SplashCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var splashViewController: SplashViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .splash
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.splashViewController = SplashViewController()
    }
    
    func start() {
        self.splashViewController.viewModel = SplashViewModel(coordinator: self,
                                                              userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
        self.splashViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(splashViewController, animated: false)
    }
}
