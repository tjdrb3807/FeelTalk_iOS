//
//  DefaultLockScreenSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

final class DefaultLockScreenSettingsCoordinator: LockScreenSettingsCoordinator  {
    var lockScreenSettingsViewController: LockScreenSettingsViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockScreenSettings
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockScreenSettingsViewController = LockScreenSettingsViewController()
    }
    
    func start() {
        lockScreenSettingsViewController.viewModel = LockScreenSettingsViewModel(coordinator: self)
        
        navigationController.pushViewController(lockScreenSettingsViewController, animated: true)
    }
}
