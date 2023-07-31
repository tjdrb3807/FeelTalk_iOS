//
//  DefaultInviteCodeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultInviteCodeCoordinator: InviteCodeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var inviteCodeViewController: InviteCodeViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .inviteCode
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.inviteCodeViewController = InviteCodeViewController()
    }
    
    func start() {
        self.inviteCodeViewController.viewModel = InviteCodeViewModel(coordinator: self,
                                                                      coupleUseCase: DefaultCoupleUaseCase(coupleRepository: DefaultCoupleRepository()))
        self.navigationController.viewControllers = [self.inviteCodeViewController]
    }
    
    func showInviteCodeBottomSheetCoordinator() {
        let inviteCodeBottomSheetCoordinator = DefaultInviteCodeBottomSheetCoordinator(self.navigationController)
        inviteCodeBottomSheetCoordinator.finishDelegate = self
        self.childCoordinators.append(inviteCodeBottomSheetCoordinator)
        inviteCodeBottomSheetCoordinator.start()
    }
}

extension DefaultInviteCodeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
