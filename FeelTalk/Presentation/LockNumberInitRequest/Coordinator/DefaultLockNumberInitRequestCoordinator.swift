//
//  DefaultLockNumberInitRequestCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import UIKit

final class DefaultLockNumberInitRequestCoordinator: LockNumberInitRequestCoordinator {
    var lockNumberInitRequestVC: LockNumberInitRequestViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockNumberInitRequest
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockNumberInitRequestVC = LockNumberInitRequestViewController()
    }
    
    func start() {
        let lockNumberInitRequestVM = LockNumberInitRequestViewModel(coordinator: self)
        
        lockNumberInitRequestVC.viewModel = lockNumberInitRequestVM
        lockNumberInitRequestVC.modalPresentationStyle = .fullScreen
        navigationController.present(lockNumberInitRequestVC, animated: true)
    }
    
    func dismiss() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: false)
    }
}
