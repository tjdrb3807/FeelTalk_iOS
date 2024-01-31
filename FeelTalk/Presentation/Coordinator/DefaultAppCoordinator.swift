//
//  DefaultAppCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultAppCoordinator: AppCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
//        DefaultAppCoordinator.isFirstRun() ? showOnboardingFlow() : showSplashFlow()
        
        showOnboardingFlow()
//        showSplashFlow()
    }
    
    func showSplashFlow() {
        let splashCoordinator = DefaultSplashCoordinator(self.navigationController)
        
        childCoordinators.append(splashCoordinator)
        splashCoordinator.finishDelegate = self
        splashCoordinator.start()
    }
    
    func showOnboardingFlow() {
        let onboardingCoordinator = DefaultOnboardingCoordinator(self.navigationController)
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.finishDelegate = self
        onboardingCoordinator.start()
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        
        childCoordinators.append(loginCoordinator)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = DefaultMainTabBarCoordinator(self.navigationController)
        
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
    }
}

extension DefaultAppCoordinator {
    static private func isFirstRun() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "isFirstRun") == nil {
            defaults.set("No", forKey: "isFirstRun")
            return true
        } else {
            return false
        }
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .onboarding:
            self.showLoginFlow()
        case .tab:
            self.showLoginFlow()
        case .login:
            self.showTabBarFlow()
        default:
            break
        }
    }
}
