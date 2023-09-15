//
//  DefaultConfigurationSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit

final class DefaultConfigurationSettingsCoordinator: ConfigurationSettingsCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var configurationSettingsViewController: ConfigurationSettingsViewController
    var type: CoordinatorType = .configurationSettings
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.configurationSettingsViewController = ConfigurationSettingsViewController()
    }
    
    func start() {
        let viewModel = ConfigurationSettingsViewModel(coordinator: self)
        self.configurationSettingsViewController.viewModel = viewModel
        self.navigationController.pushViewController(configurationSettingsViewController, animated: true)
        self.navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeLast()
        self.navigationController.popViewController(animated: true)
        
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
