//
//  AppCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/15.
//

import UIKit

public enum AppFlow {
    case login
    case inviteCode
    case main
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    let flow: AppFlow
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.flow = .login
    }
    
    func start() {
        switch flow {
        case .login:
            let loginCoordinator = LoginCoordinator(navigationController: self.navigationController, dependencies: self)
            loginCoordinator.start()
            addChildCoordinator(loginCoordinator)
        case.inviteCode:
            break
        case .main:
            break
        }
    }
}

extension AppCoordinator: LoginCoordinatorDependencies {
    func makeMainTabBarViewController(_ loginCoordinator: LoginCoordinator) {
        print("[CALL]: AppCoordinator - makeMainTabBarViewController")
    }
    
    func makeCopuleCodeViewController(_ loginCoordinaort: LoginCoordinator) {
        print("[CALL]: AppCoordinator - makeCoupleCodeViewController")
        removeChildCoordinators()
        let inviteCodeCoordinator = InviteCodeCoordinator(navigationController: self.navigationController)
        inviteCodeCoordinator.start()
        addChildCoordinator(inviteCodeCoordinator)
    }
}
