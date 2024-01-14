//
//  DefaultAuthConsentCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultAuthConsentCoordinator: AuthConsentCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var authConsentViewController: AuthConsentViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .authConsent
    
    var isConsented = PublishRelay<Bool>()
    private let dispoeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.authConsentViewController = AuthConsentViewController()
    }
    
    func start() {
        let vm = AuthConsentViewModel(coordinator: self)
        
        self.isConsented
            .bind(to: vm.isConsented)
            .disposed(by: dispoeBag)
        
        self.authConsentViewController.viewModel = vm
        authConsentViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(authConsentViewController, animated: false)
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
