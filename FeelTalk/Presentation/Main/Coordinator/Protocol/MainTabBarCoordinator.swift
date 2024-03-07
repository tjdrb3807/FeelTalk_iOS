//
//  MainTabBarCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainTabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    /// 화면 잠금 설정 여부 판단
    var lockScreenStateObserver: BehaviorRelay<Bool> { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}
