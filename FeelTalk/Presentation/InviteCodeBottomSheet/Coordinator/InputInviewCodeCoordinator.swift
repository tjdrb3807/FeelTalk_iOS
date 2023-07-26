//
//  InviteCodeBottomSheetCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/22.
//

import UIKit

public enum InviteCodeBottomSheetFlow {
    case main
}

final class InviteCodeBottomSheetCoordinator: BaseCoordinator {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = InviteCodeBottomSheetViewModel(bottomSheetControllable: self,
                                             coupleUseCase: DefaultCoupleUaseCase(coupleRepository: DefaultCoupleRepository()))
        let viewController = InviteCodeBottomSheetViewController.create(with: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(viewController, animated: false)
        
    }
}

extension InviteCodeBottomSheetCoordinator: InviteCodeBottomSheetViewControllable {
    func performTransition(_ bottomSheetViewModel: InviteCodeBottomSheetViewModel, to transition: InviteCodeBottomSheetFlow) {
        print("커플 매칭 됐음 메인 tapBar로 이동할꺼임")
    }
}
