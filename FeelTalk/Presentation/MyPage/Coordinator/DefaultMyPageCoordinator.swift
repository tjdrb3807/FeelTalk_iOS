//
//  DefaultMyPageCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit

final class DefaultMyPageCoordinator: MyPageCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var myPageViewController: MyPageViewController
    var type: CoordinatorType = .myPage
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myPageViewController = MyPageViewController()
    }
    
    func start() {
        self.myPageViewController.viewModel = MyPageViewModel(coordinator: self,
                                                              userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
        self.navigationController.tabBarController?.tabBar.isHidden = false
        self.navigationController.pushViewController(myPageViewController, animated: false)
    }
    
    func showChatFlow() {
//        let chatCoordinator = DefaultChatCooridnator(self.navigationController)
//        
//        self.childCoordinators.append(chatCoordinator)
//        chatCoordinator.finishDelegate = self
//        chatCoordinator.start()
    }
    
    func showPartnerInfoFlow() {
        let partnerInfoCoordinator = DefaultPartnerInfoCoordinator(self.navigationController)
        
        childCoordinators.append(partnerInfoCoordinator)
        partnerInfoCoordinator.finishDelegate = self
        partnerInfoCoordinator.start()
    }
    
    func showSettingsFlow() {
        let settingsCoordinator = DefaultSettingsCoordinator(self.navigationController)
        
        self.childCoordinators.append(settingsCoordinator)
        settingsCoordinator.finishDelegate = self
        settingsCoordinator.start()
    }
    
    func showInquiryFlow() {
        let inquiryCoordinator = DefaultInquiryCoordinator(self.navigationController)
        
        inquiryCoordinator.finishDelegate = self
        childCoordinators.append(inquiryCoordinator)
        inquiryCoordinator.start()
    }
    
    func showSuggestionsFlow() {
        let suggestionsCoordinator = DefaultSuggestionsCoordinator(self.navigationController)
        
        suggestionsCoordinator.finishDelegate = self
        childCoordinators.append(suggestionsCoordinator)
        suggestionsCoordinator.start()
    }
}

extension DefaultMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .inquiry:
            self.myPageViewController.viewModel.showBottomSheet.accept(.inquiry)
        case .suggestions:
            self.myPageViewController.viewModel.showBottomSheet.accept(.suggestions)
        case .partnerInfo:
            navigationController.tabBarController?.tabBar.isHidden = false
        case .settingList:
            self.childCoordinators.removeAll()
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        default:
            break
        }
    }
}

