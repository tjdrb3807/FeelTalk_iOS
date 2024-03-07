//
//  DefaultLockNumberPadCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultLockNumberPadCoordinator: LockNumberPadCoordinator {
    var lockNumberPadVC: LockNumberPadViewController
    var lockNumberNV: UINavigationController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockNumberPad
    
    var viewType = PublishRelay<LockNumberPadViewType>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.lockNumberPadVC = LockNumberPadViewController()
        self.lockNumberNV = UINavigationController(rootViewController: self.lockNumberPadVC)
        self.lockNumberNV.navigationBar.isHidden = true
    }
    
    func start() {
        let lockNumberPadVM = LockNumberPadViewModel(coordinator: self,
                                                     configurationUseCase: DefaultConfigurationUseCase(
                                                        configurationRepository: DefaultConfigurationRepository()))
        
        viewType
            .bind(to: lockNumberPadVM.viewType)
            .disposed(by: disposeBag)
        
        lockNumberPadVC.viewModel = lockNumberPadVM
        lockNumberNV.modalPresentationStyle = .fullScreen
        navigationController.present(lockNumberNV, animated: false)
    }
    
    func showLockNumberHintFlow(type: LockNumberHintViewType, with password: String?) {
        let lockNumberHintCN = DefaultLockNumberHintCoordinator(lockNumberNV)
        lockNumberHintCN.start()
        lockNumberHintCN.viewType.accept(type)
        lockNumberHintCN.initPWObserver.accept(password)
        lockNumberHintCN.finishDelegate = self
        childCoordinators.append(lockNumberHintCN)
        
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.lockNumberNV.viewControllers.removeAll()
        self.navigationController.dismiss(animated: true)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.lockNumberNV.viewControllers.removeAll()
        self.navigationController.dismiss(animated: true)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultLockNumberPadCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .lockNumberHint:
            finish()
            LockScreenSettingsViewModel.toastMessagePopObserver.accept(.settings)
        default:
            break
        }
    }
}
