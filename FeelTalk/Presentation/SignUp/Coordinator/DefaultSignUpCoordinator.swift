//
//  DefaultSignUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultSignUpCoordinator: SignUpCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var signUpViewController: SignUpViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .signUp
    
    var isMarketingConsented = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = SignUpViewController()
    }
    
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self,
                                                              signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
        
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func showAdultAuthFlow() {
        let adultAuthCoordinator = DefaultAdultAuthCoordiantor(self.navigationController)
        adultAuthCoordinator.finishDelegate = self
        self.childCoordinators.append(adultAuthCoordinator)
        adultAuthCoordinator.start()
    }
    
    func showNicknameFlow() {
        let nicknameCoordinator = DefaultNicknameCoordinator(self.navigationController)
        
        isMarketingConsented
            .bind(to: nicknameCoordinator.isMarketingConsented)
            .disposed(by: disposeBag)
            
        nicknameCoordinator.finishDelegate = self
        self.childCoordinators.append(nicknameCoordinator)
        nicknameCoordinator.start()
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.popViewController(animated: true)
    }
}

extension DefaultSignUpCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .adultAuth:
            self.signUpViewController.viewModel.adultAuthenticated.accept(.authenticated)
        case .nickname:
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        default:
            break
        }
    }
}
