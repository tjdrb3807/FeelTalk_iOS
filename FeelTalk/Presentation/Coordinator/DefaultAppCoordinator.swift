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
    var loginUseCase = DefaultLoginUseCase(loginRepository: DefaultLoginRepository(),
                                           appleRepository: DefaultAppleRepository(),
                                           googleRepositroy: DefaultGoogleRepository(),
                                           naverRepository: DefaultNaverLoginRepository(),
                                           kakaoRepository: DefaultKakaoRepository(),
                                           userRepository: DefaultUserRepository())
    private let disposeBag = DisposeBag()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        
        // 앱을 처음 다운받아서 실행한 경우
        if DefaultAppCoordinator.isFirstRun() {
            print("isFirstRun: Onboarding Page")
            
            KeychainRepository.deleteItem(key: "accessToken")
            KeychainRepository.deleteItem(key: "refreshToken")
            KeychainRepository.deleteItem(key: "expiredTime")
            KeychainRepository.deleteItem(key: "userState")
            
            showOnboardingFlow()
            return
        }
        
        guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else {
            // 로그아웃 상태인 경우
            print("No accessToken: Login Page")
            showLoginFlow()
            return
        }
        
        Task {
            let data = await getUserState()
            DispatchQueue.main.async {
                if data?.userState == UserState.solo {
                    // 솔로 상태면 초대코드 페이지로
                    print("UserState is solo: Invite Code Page")
                    self.showInviteCodeFlow()
                    return
                }
                
                if data?.userState != UserState.couple {
                    // 커플 상태가 아니면 모두 로그인 페이지로
                    print("UserState is NOT couple: Log In Page")
                    self.showLoginFlow()
                    return
                }
                
                print("Other else: Main Page")
                
                if data?.isLock == true {
                    self.showLockNumberPadFlow()
                }
                if data?.isLock == false {
                    self.showTabBarFlow()
                }
                
                DefaultAppCoordinator
                    .isLockScreenObserver
                    .map({ isLock in
                        print("observe isLock: \(isLock)")
                    })
                    .skip(1)
                    .take(1)
                    .withUnretained(self)
                    .bind { cn, state in
//                        state ? cn.showLockNumberPadFlow() : cn.showTabBarFlow()
                    }.disposed(by: self.disposeBag)
            }
        }
//
//        if UserState.solo.rawValue == KeychainRepository.getItem(key: "userState") as? String {
//            // 솔로 상태면 초대코드 페이지로
//            print("UserState is solo: Invite Code Page")
//            showInviteCodeFlow()
//            return
//        }
//
//        if UserState.couple.rawValue != KeychainRepository.getItem(key: "userState") as? String {
//            // 커플 상태가 아니면 모두 로그인 페이지로
//            print("UserState is NOT couple: Log In Page")
//            showLoginFlow()
//            return
//        }
//
//        bindIsLockScreenObserver()
//
//        print("Other else: Main Page")
//
//
//        DefaultAppCoordinator
//            .isLockScreenObserver
//            .skip(1)
//            .take(1)
//            .withUnretained(self)
//            .bind { cn, state in
//                state ? cn.showLockNumberPadFlow() : cn.showTabBarFlow()
//            }.disposed(by: disposeBag)
    }
    
    func getUserState() async -> (isLock: Bool, userState: UserState)? {
        return try? await withCheckedThrowingContinuation({ continuation in
            configurationUseCase
                .getLockNubmer()
                .map { $0?.count == 4 }
                .withUnretained(self)
                .bind(onNext: { c, isLock in
                    DefaultAppCoordinator.isLockScreenObserver.accept(isLock)
                    
                    guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else {
                        continuation.resume(throwing: NSError(domain: "Access token is nil", code: 400))
                        return
                    }
                    
                    c.loginUseCase.getUserState(accessToken)
                        .subscribe { userState in
                            continuation.resume(returning: (isLock, userState))
                        } onError: { error in
                            continuation.resume(throwing: error)
                        }
                        .disposed(by: c.disposeBag)
                })
                .disposed(by: disposeBag)
        })
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
    
    func showInviteCodeFlow() {
        let inviteCodeCoordinator = DefaultInviteCodeCoordinator(self.navigationController)
        
        childCoordinators.append(inviteCodeCoordinator)
        inviteCodeCoordinator.finishDelegate = self
        inviteCodeCoordinator.start()
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
        case .loginFromLogout:
            self.showLoginFlow()
        case .login, .inviteCode, .inviteCodeBottomSheet:
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
