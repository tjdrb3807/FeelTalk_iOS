//
//  DefaultWithdrawalCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

final class DefaultWithdrawalCoordinator: WithdrawalCoordiantor {
    var withdrawalViewController: WithdrawalViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var withdrawalNavigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .withdrawal
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.withdrawalViewController = WithdrawalViewController()
        self.withdrawalNavigationController = UINavigationController(rootViewController: self.withdrawalViewController)
    }
    
    func start() {
        withdrawalViewController.viewModel = WithdrawalViewModel(coordinator: self)
        withdrawalNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(withdrawalNavigationController, animated: true)
    }
    
    func showWithdrawalDetailFlow() {
        let withdrawalDetailCoordinator = DefaultWithdrawalDetailCoordinator(withdrawalNavigationController)
        withdrawalDetailCoordinator.finishDelegate = self
        withdrawalDetailCoordinator.start()
        childCoordinators.append(withdrawalDetailCoordinator)
    }
    
    func dismiss() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: true)
    }
}

extension DefaultWithdrawalCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .withdrawalDetail:
            self.childCoordinators.removeAll()
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        default:
            break
        }
    }
}
