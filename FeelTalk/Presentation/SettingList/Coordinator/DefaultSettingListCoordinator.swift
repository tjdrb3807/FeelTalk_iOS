//
//  DefaultSettingListCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import UIKit

final class DefaultSettionListCoordinator: SettingListCoordinator {
    var settingListViewController: SettingListViewController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .settingList
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingListViewController = SettingListViewController()
    }
    
    func start() {
        self.settingListViewController.viewModel = SettingListViewModel(coordinatro: self,
                                                                        configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
        self.navigationController.tabBarController?.tabBar.isHidden = true
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.pushViewController(self.settingListViewController, animated: true)
    }
}
