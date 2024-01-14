//
//  DefaultSignalCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/22.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultSignalCoordinator: SignalCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var signalViewController: SignalViewController
    var type: CoordinatorType = .signal
    
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signalViewController = SignalViewController()
    }
    
    func start() {
        let viewModel = SignalViewModel(coordinator: self,
                                        signalUseCase: DefaultSignalUseCase(signalRepositroy: DefaultSignalRepository()))

        self.signalViewController.viewModel = viewModel
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.tabBarController?.tabBar.isHidden = true
        self.signalViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(signalViewController, animated: false)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.navigationController.dismiss(animated: false)
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
