//
//  DefaultOnboardingCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/29.
//

import UIKit

final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var onboardingViewController: OnboardingViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .onboarding
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.onboardingViewController = OnboardingViewController()
    }
    
    func start() {
        self.onboardingViewController.viewModel = OnboardingViewModel(coordinator: self)
        self.navigationController.pushViewController(onboardingViewController, animated: false)
    }
    
    func showInquiryFlow() {
        let inquiryCoordinator = DefaultInquiryCoordinator(self.navigationController)
        inquiryCoordinator.finishDelegate = self
        self.childCoordinators.append(inquiryCoordinator)
        inquiryCoordinator.start()
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultOnboardingCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
