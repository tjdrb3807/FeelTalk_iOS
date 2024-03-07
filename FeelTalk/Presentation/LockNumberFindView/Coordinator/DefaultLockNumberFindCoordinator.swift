//
//  DefaultLockNumberFindCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import UIKit

final class DefaultLockNumberFindCoordinator: LockNumberFindCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var lockNumberFindVC: LockNumberFindViewController
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockNumberFind
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockNumberFindVC = LockNumberFindViewController()
    }
    
    func start() {
        let lockNumberFindVM = LockNumberFindViewModel(coordinator: self)
        
        lockNumberFindVC.viewModel = lockNumberFindVM
        lockNumberFindVC.modalPresentationStyle = .overFullScreen
        navigationController.present(lockNumberFindVC, animated: false)
    }
    
    func dismiss() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: false)
    }
    
    func finish() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: false)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
