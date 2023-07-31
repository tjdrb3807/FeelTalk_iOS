//
//  DefaultSignUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultSignUpCoordinator: SignUpCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var signUpViewController: SignUpViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .signUp
    var snsLogin: SNSLogin?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = SignUpViewController()
    }
    
    func start() {
        guard let snsLogin = snsLogin else { return }
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self,
                                                              signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()),
                                                              snsLogin: snsLogin)
        
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func showNicknameFlow(with data: SignUp) {
        let nicknameCoordinator = DefaultNicknameCoordinator(self.navigationController)
        nicknameCoordinator.finishDelegate = self
        self.childCoordinators.append(nicknameCoordinator)
        nicknameCoordinator.pushNicknameViewController(with: data)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.popViewController(animated: true)
    }
}

extension DefaultSignUpCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
