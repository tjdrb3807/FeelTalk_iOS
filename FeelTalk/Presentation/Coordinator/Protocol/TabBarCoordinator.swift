//
//  TabBarCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

enum TabBarPage: String, CaseIterable {
    case home, question, challenge
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .question
        case 2: self = .challenge
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .question: return 1
        case .challenge: return 2
        }
    }
    
    func tabIconName() -> String {
        switch self {
        case .home: return "icon_home_tab_bar_normal"
        case .question: return "icon_question_tab_bar_normal"
        case .challenge: return "icon_challenge_tab_bar_normal"
        }
    }
}

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}
