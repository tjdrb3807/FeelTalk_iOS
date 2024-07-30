//
//  DefaultWithdrawalDetailCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

final class DefaultWithdrawalDetailCoordinator: WithdrawalDetailCoordinator {
    var withdrawalDetailViewController: WithdrawalDetailViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .withdrawalDetail
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.withdrawalDetailViewController = WithdrawalDetailViewController()
    }
    
    func start() {
        withdrawalDetailViewController.viewModel = WithdrawalDetailViewModel(coordinator: self)
        navigationController.pushViewController(withdrawalDetailViewController, animated: true)
    }
    
    func pop() {
        childCoordinators.removeAll()
        navigationController.popViewController(animated: true)
    }
    
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.navigationController.dismiss(animated: true)
    }
}
