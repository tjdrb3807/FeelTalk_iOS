//
//  DefaultLockNumberHintCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/05.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultLockNumberHintCoordinator: LockNumberHintCoordinator {
    var lockNumberHintVC: LockNumberHintViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .lockNumberHint
    
    var viewType = PublishRelay<LockNumberHintViewType>()
    var initPWObserver = PublishRelay<String?>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
        self.lockNumberHintVC = LockNumberHintViewController()
    }
    
    func start() {
        let lockNumberHintVM = LockNumberHintViewModel(
            coordinator: self,
            configurationUseCase: DefaultConfigurationUseCase(
                configurationRepository: DefaultConfigurationRepository()))
        
        viewType
            .bind(to: lockNumberHintVM.viewType)
            .disposed(by: disposeBag)
        
        initPWObserver
            .compactMap { $0 }
            .bind(to: lockNumberHintVM.initPW)
            .disposed(by: disposeBag)
            
        lockNumberHintVC.viewModel = lockNumberHintVM
        navigationController.pushViewController(lockNumberHintVC, animated: false)
    }
    
    func showLockNumberFindFlow() {
        let lockNumberFindCN = DefaultLockNumberFindCoordinator(navigationController)
        lockNumberFindCN.finishDelegate = self
        lockNumberFindCN.start()
        childCoordinators.append(lockNumberFindCN)
    }
    
    func showLockNumberInitRequestFlow() {
        let lockNumberReqeustInitCN = DefaultLockNumberInitRequestCoordinator(navigationController)
        lockNumberReqeustInitCN.finishDelegate = self
        lockNumberReqeustInitCN.start()
        childCoordinators.append(lockNumberReqeustInitCN)
    }
    
    func pop() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeLast()
    }
    
    func finish() {
            childCoordinators.removeAll()
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultLockNumberHintCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        
        switch childCoordinator.type {
        case .lockNumberFind:
            showLockNumberInitRequestFlow()
        default:
            break
        }
    }
}
