//
//  InviteCodeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import UIKit

public enum InviteCodeFlow {
    case main
}

final class InviteCodeCoordinator: BaseCoordinator {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = InviteCodeViewModel(inviteCodeControllable: self,
                                            coupleUseCase: DefaultCoupleUaseCase(coupleRepository: DefaultCoupleRepository(),
                                                                                 authRepository: DefaultAuthRepository()))
        let vc = InviteCodeViewConroller.create(with: viewModel)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension InviteCodeCoordinator: InviteCodeViewControllable {
    func performTransition(_ inviteCodeViewModel: InviteCodeViewModel, to transition: InviteCodeFlow) {
        print("hello")
    }
}
