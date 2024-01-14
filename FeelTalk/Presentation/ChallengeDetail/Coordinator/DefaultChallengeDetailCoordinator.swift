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
    var typeObserver = PublishRelay<ChallengeDetailViewType>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.challengeDetailViewController = ChallengeDetailViewController()
    }
    
    func start() {
        let vm = ChallengeDetailViewModel(coordinator: self,
                                          challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
        
        typeObserver
            .bind(to: vm.typeObserver)
            .disposed(by: disposeBag)
        
        challengeModel
            .bind(to: vm.modelObserver)
            .disposed(by: disposeBag)
        
        challengeDetailViewController.viewModel = vm
        navigationController.pushViewController(challengeDetailViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}

