//
//  LoginCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

protocol LoginCoordinator: Coordinator {
//    func showSignUpFlow(with data: SNSLogin)
    
    func showSignUpFlow()
    
    func showInviteCodeFlow()
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
        self.loginViewController.viewModel = LoginViewModel(coordinator: self,
                                                            loginUseCase: DefaultLoginUseCase(loginRepository: DefaultLoginRepository(),
                                                                                              appleRepository: DefaultAppleRepository(),
                                                                                              googleRepositroy: DefaultGoogleRepository(),
                                                                                              naverRepository: DefaultNaverLoginRepository(),
                                                                                              kakaoRepository: DefaultKakaoRepository(),
                                                                                              userRepository: DefaultUserRepository()))
        
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
//    func showSignUpFlow(with data: SNSLogin) {
//        let signUpCoordinator = DefaultSignUpCoordinator(self.navigationController)
//        signUpCoordinator.finishDelegate = self
//        signUpCoordinator.snsLogin = data
//        signUpCoordinator.start()
//        self.childCoordinators.append(signUpCoordinator)
//    }
    
    func showSignUpFlow() {
        let signUpCoordinator = DefaultSignUpCoordinator(self.navigationController)
        signUpCoordinator.finishDelegate = self
        signUpCoordinator.start()
        self.childCoordinators.append(signUpCoordinator)
    }
    
    func showInviteCodeFlow() {
        let inviteCodeCoordinator = DefaultInviteCodeCoordinator(self.navigationController)
        inviteCodeCoordinator.finishDelegate = self
        inviteCodeCoordinator.start()
        self.childCoordinators.append(inviteCodeCoordinator)
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
        default:
            break
        }
    }
}
