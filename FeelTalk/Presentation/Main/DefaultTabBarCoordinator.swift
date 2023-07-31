//
//  DefaultTabBarCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

final class DefaultTabBarCoordinator: NSObject, TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        super.init()
    }
    
    func start() {
        // MainTabBarCoordinator ViewModel 지울것
//        let pages: [TabBarPage] = TabBarPage.allCases
        
        
        
        
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func configureTabBarControllers(with tabViewController: [UINavigationController]) {
        self.tabBarController.setViewControllers(tabViewController, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
        
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(title: nil,
                            image: UIImage(named: page.tabIconName()),
                            tag: page.pageOrderNumber())
    }
//
//    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
//        let tabNavigationController = UINavigationController()
//
//        tabNavigationController.setNavigationBarHidden(false, animated: false)
//        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
//        // TODO:
//    }
}
