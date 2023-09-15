//
//  DefaultMyPageCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit

final class DefaultMyPageCoordinator: MyPageCoordinator {
    
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var myPageViewController: MyPageViewController
    var type: CoordinatorType = .myPage
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myPageViewController = MyPageViewController()
    }
    
    func start() {
        self.myPageViewController.viewModel = MyPageViewModel(coordinator: self,
                                                              userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
        self.navigationController.pushViewController(myPageViewController, animated: true)
    }
    
    func showConfigurationSettingsFlow() {
        let configurationSettingsCoordinator = DefaultConfigurationSettingsCoordinator(self.navigationController)
        configurationSettingsCoordinator.finishDelegate = self
        childCoordinators.append(configurationSettingsCoordinator)
        configurationSettingsCoordinator.start()
    }
}

extension DefaultMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}

