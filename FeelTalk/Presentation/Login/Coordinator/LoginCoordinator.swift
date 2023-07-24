//
//  LoginCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/15.
//

import UIKit

enum loginFlow {
    case signUp
    case coupleCode
    case main
}

protocol LoginCoordinatorDependencies: AnyObject {
    func makeMainTabBarViewController(_ loginCoordinator: LoginCoordinator)
    func makeCopuleCodeViewController(_ loginCoordinaort: LoginCoordinator)
}

final class LoginCoordinator: BaseCoordinator {
    weak var dependencies: LoginCoordinatorDependencies?
    private var snsLogin: SNSLogin?
    
    init(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) {
        super.init(navigationController: navigationController)
        self.dependencies = dependencies
    }
    
    override func start() {
        let viewModel = LoginViewModel(loginControllable: self,
                                       delegate: self,
                                       loginUseCase: DefaultLoginUseCase(loginRepository: DefaultLoginRepository(),
                                                                         appleRepository: DefaultAppleRepository(),
                                                                         googleRepositroy: DefaultGoogleRepository(),
                                                                         naverRepository: DefaultNaverLoginRepository(),
                                                                         kakaoRepository: DefaultKakaoRepository()))
        let viewController = LoginViewController.create(with: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewControllable {
    func performTransition(_ loginViewModel: LoginViewModel, to transition: loginFlow) {
        switch transition {
        case .signUp:
            let signUpCoordinator = SignUpCoordinator(navigationController: navigationController, dependencies: self, snsLogin: snsLogin)
            signUpCoordinator.start()
            addChildCoordinator(signUpCoordinator)
        case .coupleCode:
            dependencies?.makeCopuleCodeViewController(self)
        case .main:
            dependencies?.makeMainTabBarViewController(self)
        }
    }
}

extension LoginCoordinator: SignUpCoordinatorDependencies {
    func makeCoupleCodeViewController(_ signUpCoordinator: SignUpCoordinator) {
        dependencies?.makeCopuleCodeViewController(self)
    }
}

extension LoginCoordinator: SendSNSLoginDataDelegate {
    func reciveData(reseponse: SNSLogin) {
        self.snsLogin = reseponse
    }
}

