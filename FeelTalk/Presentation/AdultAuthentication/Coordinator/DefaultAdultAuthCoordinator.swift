//
//  DefaultAdultAuthCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultAdultAuthCoordiantor: AdultAuthCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var adultAuthViewController: AdultAuthViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .adultAuth
    
    var isFullConsented = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.adultAuthViewController = AdultAuthViewController()
    }
    
    func start() {
        self.adultAuthViewController.viewModel = AdultAuthViewModel(coordiantor: self,
                                                                    signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
        self.navigationController.pushViewController(adultAuthViewController, animated: false)
    }
    
    func showNewsAgencyFlow() {
        let newsAgencyCoordinator = DefaultNewsAgencyCoordinator(self.navigationController)
        newsAgencyCoordinator.finishDelegate = self
        self.childCoordinators.append(newsAgencyCoordinator)
        newsAgencyCoordinator.start()
    }
    
    func showAuthConsentFlow() {
        let authConsentCoordinator = DefaultAuthConsentCoordinator(self.navigationController)
        
        isFullConsented
            .bind(to: authConsentCoordinator.isConsented)
            .disposed(by: disposeBag)
        
        authConsentCoordinator.finishDelegate = self
        self.childCoordinators.append(authConsentCoordinator)
        authConsentCoordinator.start()
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.dismiss(animated: false)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultAdultAuthCoordiantor: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .authConsent:
            self.adultAuthViewController.viewModel.isConsented.accept(true)
        default:
            break
        }
    }
}
