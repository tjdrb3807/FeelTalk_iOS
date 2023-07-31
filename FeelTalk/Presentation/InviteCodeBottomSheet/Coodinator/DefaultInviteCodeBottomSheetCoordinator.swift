//
//  DefaultInviteCodeBottomSheetCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultInviteCodeBottomSheetCoordinator: InviteCodeBottomSheetCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var inviteCodeBottomSheetViewController: InviteCodeBottomSheetViewController
    var type: CoordinatorType = .inviteCodeBottomSheet
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.inviteCodeBottomSheetViewController = InviteCodeBottomSheetViewController()
    }
    
    func start() {
        self.inviteCodeBottomSheetViewController.viewModel = InviteCodeBottomSheetViewModel(coordinator: self,
                                                                                            coupleUseCase: DefaultCoupleUaseCase(coupleRepository: DefaultCoupleRepository()))
        self.inviteCodeBottomSheetViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(self.inviteCodeBottomSheetViewController, animated: false)
    }
    
    func finish() {
        self.navigationController.dismiss(animated: false)
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
