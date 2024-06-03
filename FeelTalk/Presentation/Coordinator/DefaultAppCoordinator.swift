//
//  DefaultAppCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultAppCoordinator: AppCoordinator {
    static let isLockScreenObserver = BehaviorRelay<Bool>(value: false)
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    var configurationUseCase = DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository())
    private let disposeBag = DisposeBag()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        // 앱을 처음 다운받아서 실행한 경우
        if DefaultAppCoordinator.isFirstRun() {
            showOnboardingFlow()
            return
        }
        
        guard let _ = KeychainRepository.getItem(key: "accessToken") as? String else {
            // 로그아웃 상태인 경우
            showLoginFlow()
            return
        }
        
        guard let _ = KeychainRepository.getItem(key: "userState") as? String else {
            // 커플 상태가 아니면 모두 로그인 페이지로
            showLoginFlow()
            return
        }
        
        bindIsLockScreenObserver()
        
        DefaultAppCoordinator
            .isLockScreenObserver
            .skip(1)
            .take(1)
            .withUnretained(self)
            .bind { cn, state in
                state ? cn.showLockNumberPadFlow() : cn.showTabBarFlow()
            }.disposed(by: disposeBag)
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
    
    func showLockNumberPadFlow() {
        let lockNumberPadCoordinator = DefaultLockNumberPadCoordinator(self.navigationController)
        
        lockNumberPadCoordinator.start()
        lockNumberPadCoordinator.viewType.accept(.access)
        lockNumberPadCoordinator.finishDelegate = self
        
        childCoordinators.append(lockNumberPadCoordinator)
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
    
    private func bindIsLockScreenObserver() {
        configurationUseCase
            .getLockNubmer()
            .map { $0?.count == 4 }
            .bind(to: DefaultAppCoordinator.isLockScreenObserver)
            .disposed(by: disposeBag)
        
//        configurationUseCase
//            .getConfigurationInfo()
//            .map { $0.isLock }
//            .bind(to: DefaultAppCoordinator.isLockScreenObserver)
//            .disposed(by: disposeBag)
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
            self.childCoordinators.removeAll()
            self.bindIsLockScreenObserver()
            self.showTabBarFlow()
        case .lockNumberPad:
            self.showTabBarFlow()
        default:
            break
        }
    }
}
