//
//  InviteCodeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import UIKit

public enum InviteCodeFlow {
    case bottomSheet
}

final class InviteCodeCoordinator: BaseCoordinator {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = InviteCodeViewModel(inviteCodeControllable: self,
                                            coupleUseCase: DefaultCoupleUaseCase(coupleRepository: DefaultCoupleRepository()))
        let vc = InviteCodeViewController.create(with: viewModel)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension InviteCodeCoordinator: InviteCodeViewControllable {
    func performTransition(_ inviteCodeViewModel: InviteCodeViewModel, to transition: InviteCodeFlow) {
        let inviteCodeBottomSheetCoordinator = InviteCodeBottomSheetCoordinator(navigationController: navigationController)
        inviteCodeBottomSheetCoordinator.start()
        addChildCoordinator(inviteCodeBottomSheetCoordinator)
    }
}
