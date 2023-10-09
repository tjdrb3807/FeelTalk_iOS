//
//  DefaultLockingSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/18.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultLockingSettingsCoordinator: LockingSettingsCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var lockingSettingViewController: LockingSettingViewController
    var type: CoordinatorType = .lockingSettings
    var lockTheScreenState = PublishRelay<Bool>()
    var lockingPasswordViewMode = PublishRelay<LockingPasswordViewMode>()
    private let disposeBag = DisposeBag()
    
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockingSettingViewController = LockingSettingViewController()
    }
    
    func start() {
        let viewModel = LockingSettingsViewModel(coordinator: self)
        self.lockTheScreenState
            .bind { state in
                viewModel.isLockScreen.accept(state)
            }.disposed(by: disposeBag)
        self.lockingSettingViewController.viewModel = viewModel
        self.navigationController.pushViewController(lockingSettingViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showLockingPasswordFlow() {
        let lockingPasswordCoordiantor = DefaultLockingPasswordCoordinator(self.navigationController)
        lockingPasswordViewMode
            .bind { mode in
                lockingPasswordCoordiantor.viewMode.accept(mode)
            }.disposed(by: disposeBag)
        
        childCoordinators.append(lockingPasswordCoordiantor)
        lockingPasswordCoordiantor.start()
    }
}
