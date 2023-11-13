//
//  DefaultHomeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultHomeCoordinator: HomeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var homeViewController: HomeViewController
    var type: CoordinatorType = .home
    
    var signalModel = PublishRelay<Signal>()
    var reloadData = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        homeViewController.viewModel = HomeViewModel(coordinator: self,
                                                          qustionUseCase: DefaultQuestionUseCase(
                                                            questionRepository: DefaultQuestionRepository()))
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func showSignalFlow() {
        let signalCoordinator = DefaultSignalCoordinator(self.navigationController)
        signalModel
            .bind(to: signalCoordinator.signalModel)
            .disposed(by: disposeBag)
        
        childCoordinators.append(signalCoordinator)
        signalCoordinator.finishDelegate = self
        signalCoordinator.start()
    }
}

extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .signal:
            homeViewController.viewModel.showBottomSheet.accept(())
        default: break
        }
    }
}
