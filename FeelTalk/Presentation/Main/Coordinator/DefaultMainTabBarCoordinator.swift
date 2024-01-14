//
//  DefaultMainTabBarCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit
import SnapKit

enum TabBarPage: String, CaseIterable {
    case home, question, challenge, myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .question
        case 2: self = .challenge
        case 3: self = .myPage
        default: return nil
        }
    }
    
    func toTitle() -> String {
        switch self {
        case .home: return "홈"
        case .question: return "질문"
        case .challenge: return "챌린지"
        case .myPage: return "마이"
        }
    }
    
    func pageOfNumber() -> Int {
        switch self {
        case .home: return 0
        case .question: return 1
        case .challenge: return 2
        case .myPage: return 3
        }
    }
    
    func toIconName() -> String {
        switch self {
        case .home: return "icon_tab_home_normal"
        case .question: return "icon_tab_question_normal"
        case .challenge: return "icon_tab_challenge_normal"
        case .myPage: return "icon_tab_my_normal"  // TODO: 추후 변경
        }
    }
    
    func toSelectedIconName() -> String {
        switch self {
        case .home: return "icon_tab_home_selected"
        case .question: return "icon_tab_question_selected"
        case .challenge: return "icon_tab_challenge_selected"
        case .myPage: return "icon_tab_my_selected"
        }
    }
}

final class DefaultMainTabBarCoordinator: MainTabBarCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = MainTabBarController()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map { self.createTabNavigationController(of: $0) }

        self.configureTabBarController(with: controllers)
    }
    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOfNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOfNumber()
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOfNumber()
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        UITabBarItem(title: page.toTitle(),
                     image: UIImage(named: page.toIconName())?.withRenderingMode(.alwaysOriginal),
                     selectedImage: UIImage(named: page.toSelectedIconName())?.withRenderingMode(.alwaysOriginal))
    }
    
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        
        self.startTabCoordinator(of: page, to: tabNavigationController)
        
        return tabNavigationController
    }
    
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .question:
            let questionCoordinator = DefaultQuestionCoordinator(tabNavigationController)
            questionCoordinator.finishDelegate = self
            self.childCoordinators.append(questionCoordinator)
            questionCoordinator.start()
        case .challenge:
            let challengeCoordiantor = DefaultChallengeCoordinator(tabNavigationController)
            challengeCoordiantor.finishDelegate = self
            self.childCoordinators.append(challengeCoordiantor)
            challengeCoordiantor.start()
        case .myPage:
            let myPageCoordinator = DefaultMyPageCoordinator(tabNavigationController)
            myPageCoordinator.finishDelegate = self
            self.childCoordinators.append(myPageCoordinator)
            myPageCoordinator.start()
        }
    }
}

extension DefaultMainTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        if childCoordinator.type == .home {
            // TODO: logic
            selectPage(.question)
        }
    }
}
