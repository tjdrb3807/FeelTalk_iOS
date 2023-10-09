//
//  DefaultLockingPasswordCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultLockingPasswordCoordinator: LockingPasswordCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var lockingPasswordViewController: LockingPasswordViewController
    var type: CoordinatorType = .lockingPassword
    var viewMode = PublishRelay<LockingPasswordViewMode>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockingPasswordViewController = LockingPasswordViewController()
    }
    
    func start() {
        let viewModel = LockingPasswordViewModel(coordinator: self)
        self.viewMode
            .bind { mode in
                viewModel.viewMode.accept(mode)
            }.disposed(by: disposeBag)
        self.lockingPasswordViewController.viewModel = viewModel
        self.lockingPasswordViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(lockingPasswordViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func finish() {
        self.navigationController.popViewController(animated: true)
    }
}
