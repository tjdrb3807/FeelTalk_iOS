//
//  DefaultNewsAgencyCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import UIKit
import RxSwift
import RxCocoa

final class DefaultNewsAgencyCoordinator: NewsAgencyCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var newsAgencyViewController: NewsAgencyViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .newsAgency
    
    var selectedNewsAgency = PublishRelay<NewsAgencyType>()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.newsAgencyViewController = NewsAgencyViewController()
        
        selectedNewsAgency
            .withUnretained(self)
            .bind { c, type in
                let adultAutnVC = c.navigationController.viewControllers.last as! AdultAuthViewController
                adultAutnVC.viewModel.selectedNewsAgnecy.accept(type)
                
            }.disposed(by: disposeBag)
    }
    
    func start() {
        self.newsAgencyViewController.viewModel = NewsAgencyViewModel(coordinator: self)
        newsAgencyViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(newsAgencyViewController, animated: false)
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
    }
}
