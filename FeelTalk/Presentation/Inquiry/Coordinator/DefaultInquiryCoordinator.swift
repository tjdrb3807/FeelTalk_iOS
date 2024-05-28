//
//  DefaultInquiryCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultInquiryCoordinator: InquiryCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var inquiryViewController: InquiryViewController
    var type: CoordinatorType = .inquiry
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.inquiryViewController = InquiryViewController()
    }
    
    func start() {
        self.inquiryViewController.viewModel = InquiryViewModel(
            coordinator: self,
            useCase: DefaultConfigurationUseCase(
                configurationRepository: DefaultConfigurationRepository()
            )
        )
        self.inquiryViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(inquiryViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true)
    }
}
