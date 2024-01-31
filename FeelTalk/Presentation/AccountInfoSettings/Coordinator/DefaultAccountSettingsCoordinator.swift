//
//  DefaultAccountSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

final class DefaultAccountInfoSettingsCoordinator: AccountInfoSettingsCoordinator {
    var accountInfoSettingsViewController: AccountInfoSettingsViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .accountInfoSettings
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.accountInfoSettingsViewController = AccountInfoSettingsViewController()
    }
    
    func start() {
        accountInfoSettingsViewController.viewModel = AccountInfoSettingsViewModel(coordinator: self)
        navigationController.pushViewController(accountInfoSettingsViewController, animated: true)
    }
    
    func showWithdrawalFlow() {
        let withdrawalCoordinator = DefaultWithdrawalCoordinator(self.navigationController)
        childCoordinators.append(withdrawalCoordinator)
        withdrawalCoordinator.start()
    }
    
    func pop() {
        childCoordinators.removeAll()
        navigationController.popViewController(animated: true)
    }
}
