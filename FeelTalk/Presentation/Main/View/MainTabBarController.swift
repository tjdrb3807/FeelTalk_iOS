//
//  MainTabBarController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProperties()
        
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = MainTabBarNameSpace.height + view.safeAreaInsets.bottom
        tabFrame.origin.y = self.view.frame.size.height - (MainTabBarNameSpace.height + view.safeAreaInsets.bottom)
        self.tabBar.frame = tabFrame
    }
    
    private func setProperties() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        
        tabBar.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero,
                                                                   size: CGSize(width: UIScreen.main.bounds.width,
                                                                                height: (CommonConstraintNameSpace.verticalRatioCalculator * MainTabBarNameSpace.height) + view.safeAreaInsets.bottom)),
                                               cornerRadius: MainTabBarNameSpace.shadowCornerRadius).cgPath
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(MainTabBarNameSpace.shadowBackgroundColorAlpha).cgColor
        tabBar.layer.shadowOpacity = MainTabBarNameSpace.shadowOpacity
        tabBar.layer.shadowRadius = MainTabBarNameSpace.shadowRadius
        tabBar.layer.shadowOffset = CGSize(width: MainTabBarNameSpace.shadowOffsetWidth,
                                           height: MainTabBarNameSpace.shadowOffsetHeight)
    }
}

#if DEBUG

import SwiftUI

struct MainTabBarController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct MainTabBarController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MainTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
