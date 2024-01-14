//
//  DefaultNicknameCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultNicknameCoordinator: NicknameCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var nicknameViewController: NicknameViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .nickname
    
    var isMarketingConsented = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.nicknameViewController = NicknameViewController()
    }
    
    func start() {
        let vm = NicknameViewModel(coordinator: self,
                                   signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
        
        self.isMarketingConsented
            .bind(to: vm.isMarketingConsented)
            .disposed(by: disposeBag)
        
        self.nicknameViewController.viewModel = vm
        self.navigationController.pushViewController(nicknameViewController, animated: true)
    }
    
    func popViewController() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.popViewController(animated: true)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
