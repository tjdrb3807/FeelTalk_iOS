//
//  DefaultPartnerInfoCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit

final class DefaultPartnerInfoCoordinator: PartnerInfoCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var partnerInfoViewController: PartnerInfoViewController
    var type: CoordinatorType = .partnerInfo
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.partnerInfoViewController = PartnerInfoViewController()
    }
    
    func start() {
        self.partnerInfoViewController.viewModel = PartnerInfoViewModel(coordinator: self,
                                                                        userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
        self.navigationController.pushViewController(partnerInfoViewController.self, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showBreakUpFlow() {
        let breakUpCoordinator = DefaultBreakUpCoordinator(self.navigationController)
        
        childCoordinators.append(breakUpCoordinator)
        breakUpCoordinator.finishDelegate = self
        breakUpCoordinator.start()
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.tabBarController?.tabBar.isHidden = false
        self.navigationController.popViewController(animated: true)
    }
}

extension DefaultPartnerInfoCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
