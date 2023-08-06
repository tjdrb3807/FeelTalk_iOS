//
//  DefaultHomeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var homeViewController: HomeViewController
    var type: CoordinatorType = .home
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        self.homeViewController.viewModel = HomeViewModel(coordinator: self)
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
}
