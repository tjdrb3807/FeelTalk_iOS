//
//  MainTabBarController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainTabBarController: UITabBarController {
    private var viewModel: MainTabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.bind(to: viewModel)
        self.setAttributes()
    }
    
    private func bind(to viewModel: MainTabBarViewModel) {

    }
    
    private func setAttributes() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
    }
}

extension MainTabBarController {
    final class func create(with viewModel: MainTabBarViewModel) -> MainTabBarController {
        let viewController = MainTabBarController()
        viewController.viewModel = viewModel
        
        return viewController        
    }
}

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 54
        
        return sizeThatFits
    }
}

#if DEBUG

import SwiftUI

struct MainTabBarController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct MainTabBarController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MainTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
