//
//  DefaultLockScreenCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/03.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultLockScreenCoordinator: LockScreenCoordinator {
    var lockScreenVC: LockScreenViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var lockScreenNV: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockScreen
    
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockScreenVC = LockScreenViewController()
        self.lockScreenNV = UINavigationController(rootViewController: self.lockScreenVC)
        self.lockScreenNV.navigationBar.isHidden = true
        self.lockScreenNV.modalPresentationStyle = .overFullScreen
    }
    
    func start() {
        let lockScreenVM = LockScreenViewModel(coordinator: self)
        
        lockScreenVC.viewModel = lockScreenVM
        navigationController.present(lockScreenNV, animated: false)
    }
    
    func showLockNumberPadFlow() {
        let lockNumberPadCN = DefaultLockNumberPadCoordinator(lockScreenNV)
        lockNumberPadCN.start()
        lockNumberPadCN.viewType.accept(.access)
        lockNumberPadCN.finishDelegate = self
        childCoordinators.append(lockNumberPadCN)
    }
    
    func finish() {
        childCoordinators.removeAll()
        navigationController.dismiss(animated: false)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultLockScreenCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .lockNumberPad:
            finish()
        default:
            break
        }
    }
}
