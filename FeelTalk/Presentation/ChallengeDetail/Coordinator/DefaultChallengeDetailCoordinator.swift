//
//  DefaultChallengeDetailCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultChallengeDetailCoordinator: ChallengeDetailCoordinator {
    var challengeDetailViewController: ChallengeDetailViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .challengeDetail
    var challengeModel = PublishRelay<Challenge>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.challengeDetailViewController = ChallengeDetailViewController()
    }
    
    func start() {
        let viewModel = ChallengeDetailViewModel(coordinator: self,
                                                 challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
        
        self.challengeModel
            .bind { model in
                viewModel.model.accept(model)
            }.disposed(by: disposeBag)
        
        self.challengeDetailViewController.viewModel = viewModel
        self.navigationController.pushViewController(challengeDetailViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
}

