//
//  BaseCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/15.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Start method must be implemented.")
    }
}
