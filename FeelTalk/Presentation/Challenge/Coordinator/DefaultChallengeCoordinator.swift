//
//  DefaultChallengeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultChallengeCoordinator: ChallengeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var challengeViewController: ChallengeViewController
    var type: CoordinatorType = .challenge
    
    var challengeModel = PublishRelay<Challenge>()
    var typeObserver = PublishRelay<ChallengeDetailViewType>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.challengeViewController = ChallengeViewController()
    }
    
    func start() {
        self.challengeViewController.viewModel = ChallengeViewModel(coordinator: self, challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
        self.navigationController.pushViewController(challengeViewController, animated: true)
    }
    
    func showChallengeDetailFlow() {
        let challengeDetailCoordinator = DefaultChallengeDetailCoordinator(self.navigationController)
        
        typeObserver
            .bind(to: challengeDetailCoordinator.typeObserver)
            .disposed(by: disposeBag)
        
        challengeModel
            .bind(to: challengeDetailCoordinator.challengeModel)
            .disposed(by: disposeBag)
        
        childCoordinators.append(challengeDetailCoordinator)
        challengeDetailCoordinator.finishDelegate = self
        challengeDetailCoordinator.start()
    }
}

extension DefaultChallengeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
