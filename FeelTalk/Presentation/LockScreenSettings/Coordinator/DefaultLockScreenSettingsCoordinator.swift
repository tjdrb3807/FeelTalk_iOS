//
//  DefaultLockScreenSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit
import RxSwift
import RxCocoa

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
        lockScreenSettingsViewController.viewModel = LockScreenSettingsViewModel(
            coordinator: self,
            configurationUseCase: DefaultConfigurationUseCase(
                configurationRepository: DefaultConfigurationRepository()))
        
        navigationController.pushViewController(lockScreenSettingsViewController, animated: true)
    }
    
    func showLockNumberPadFlow(with type: LockNumberPadViewType) {
        let lockNumberPadCN = DefaultLockNumberPadCoordinator(self.navigationController)
        lockNumberPadCN.start()
        lockNumberPadCN.viewType.accept(type)
        lockNumberPadCN.finishDelegate = self
        
        childCoordinators.append(lockNumberPadCN)
    }
    
    func pop() {
        childCoordinators.removeAll()
        navigationController.popViewController(animated: true)
    }
}

extension DefaultLockScreenSettingsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .lockNumberPad:
            childCoordinators.removeLast()
        default:
            break
        }
    }
}
