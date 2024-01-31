//
//  DefaultSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit

final class DefaultSettingsCoordinator: SettingsCoordinator {
    var settingsViewController: SettingsViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .settingList
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingsViewController = SettingsViewController()
    }
    
    func start() {
        self.settingsViewController.viewModel = SettingsViewModel(coordinator: self,
                                                             configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
        self.navigationController.tabBarController?.tabBar.isHidden = true
        self.navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    func showLockScreenSettingsFlow() {
        let lockScreenSettingsCoordinator = DefaultLockScreenSettingsCoordinator(self.navigationController)
        
        lockScreenSettingsCoordinator.start()
        childCoordinators.append(lockScreenSettingsCoordinator)
    }
    
    func showAccountInfoSettingsFlow() {
        let accountInfoSettingsCoordinator = DefaultAccountInfoSettingsCoordinator(self.navigationController)
        
        accountInfoSettingsCoordinator.start()
        childCoordinators.append(accountInfoSettingsCoordinator)
    }
    
    func finish() {
        childCoordinators.removeAll()
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultSettingsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
