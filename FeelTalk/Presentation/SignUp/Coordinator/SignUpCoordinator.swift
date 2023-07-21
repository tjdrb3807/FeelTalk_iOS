//
//  SignUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/15.
//

import UIKit

public enum SignUpFlow {
    case nickname
}
protocol SignUpCoordinatorDependencies: AnyObject {
    func makeCoupleCodeViewController(_ signUpCoordinator: SignUpCoordinator)
}

final class SignUpCoordinator: BaseCoordinator {
    weak var dependencies: SignUpCoordinatorDependencies?
    private var snsLogin: SNSLogin?
    private var signUpInfo: SignUpInfo?
    
    init(navigationController: UINavigationController, dependencies: SignUpCoordinatorDependencies, snsLogin: SNSLogin?) {
        self.snsLogin = snsLogin
        super.init(navigationController: navigationController)
        self.dependencies = dependencies
    }
    
    override func start() {
        let viewModel = SignUpViewModel(signUpControllable: self,
                                        delegate: self,
                                        signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository(),
                                                                            authRepository: DefaultAuthRepository()))
        let vc = SignUpViewController.create(with: viewModel)
        vc.snsLogin = self.snsLogin
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension SignUpCoordinator: SignUpViewControllable {
    func performTransition(_ signUpViewModel: SignUpViewModel, to transition: SignUpFlow) {
        switch transition {
        case .nickname:
            let nicknameCoordiantor = NicknameCoordiantor(navigationController: navigationController, dependencies: self, signUpInfo: signUpInfo)
            nicknameCoordiantor.start()
            addChildCoordinator(nicknameCoordiantor)
        }
    }
}

extension SignUpCoordinator: NicknameCoordinatorDependencies {
    func makeCoupleCodeViewController(_ nicknameCoordinator: NicknameCoordiantor) {
        dependencies?.makeCoupleCodeViewController(self)
    }
}

extension SignUpCoordinator: SendSignUpInfoDataDelegate {
    func reciveData(response: SignUpInfo) {
        self.signUpInfo = response
    }
}
