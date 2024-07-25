//
//  LoginCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

protocol LoginCoordinator: Coordinator {
    func showSignUpFlow()
    
    func showInquiryFlow()
    
    func showInviteCodeFlow()
    
    func showTabBarFlow()
    
    func showLockNumberPadFlow()
}

final class DefaultLoginCoordinator: LoginCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var loginViewController: LoginViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        self.loginViewController.viewModel = LoginViewModel(
            coordinator: self,
            loginUseCase: DefaultLoginUseCase(
                loginRepository: DefaultLoginRepository(),
                appleRepository: DefaultAppleRepository(),
                googleRepositroy: DefaultGoogleRepository(),
                naverRepository: DefaultNaverLoginRepository(),
                kakaoRepository: DefaultKakaoRepository(),
                userRepository: DefaultUserRepository()),
            configurationUseCase: DefaultConfigurationUseCase(
                configurationRepository: DefaultConfigurationRepository()
            )
        )
        
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSignUpFlow() {
        let signUpCoordinator = DefaultSignUpCoordinator(self.navigationController)
        signUpCoordinator.finishDelegate = self
        signUpCoordinator.start()
        self.childCoordinators.append(signUpCoordinator)
    }
    
    func showInquiryFlow() {
        let inquiryCoordinator = DefaultInquiryCoordinator(self.navigationController)
        inquiryCoordinator.finishDelegate = self
        inquiryCoordinator.start()
        self.childCoordinators.append(inquiryCoordinator)
    }
    
    func showInviteCodeFlow() {
        let inviteCodeCoordinator = DefaultInviteCodeCoordinator(self.navigationController)
        inviteCodeCoordinator.finishDelegate = self
        inviteCodeCoordinator.start()
        self.childCoordinators.append(inviteCodeCoordinator)
    }
    
    func showTabBarFlow() {
        if self.childCoordinators.contains(where: { $0 is MainTabBarCoordinator }) {
            return
        }
        
        let tabBarCoordinator = DefaultMainTabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
    
    func showLockNumberPadFlow() {
        if self.childCoordinators.contains(where: { $0 is LockNumberPadCoordinator }) {
            return
        }
        
        let lockNumberPadCoordinator = DefaultLockNumberPadCoordinator(self.navigationController)
        lockNumberPadCoordinator.start()
        lockNumberPadCoordinator.viewType.accept(.access)
        lockNumberPadCoordinator.finishDelegate = self
        
        childCoordinators.append(lockNumberPadCoordinator)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultLoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .signUp:
            childCoordinator.navigationController.popToRootViewController(animated: true)
            self.childCoordinators.removeAll()
            self.navigationController.viewControllers.removeLast()
            self.showInviteCodeFlow()
        case .inviteCode:
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        case .lockNumberPad:
            self.showTabBarFlow()
        case .tab:
            self.type = .loginFromLogout
            self.childCoordinators.removeAll()
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        default:
            break
        }
    }
}
