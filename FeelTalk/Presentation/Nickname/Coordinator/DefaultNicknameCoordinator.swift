//
//  DefaultNicknameCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultNicknameCoordinator: NicknameCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var nicknameViewController: NicknameViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .nickname
    var signUp: SignUp?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.nicknameViewController = NicknameViewController()
    }
    
    func start() { }
    
    func pushNicknameViewController(with data: SignUp) {
        self.nicknameViewController.viewModel = NicknameViewModel(coordinator: self,
                                                                  signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()),
                                                                  signUp: data)
        self.navigationController.pushViewController(self.nicknameViewController, animated: true)
    }
    
    func showInviteCodeFlow() {
        print("[ACTION]: NicknameViewController - nextButton tapped.")
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func popViewController() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.popViewController(animated: true)
    }
}
