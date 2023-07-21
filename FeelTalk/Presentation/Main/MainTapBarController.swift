//
//  MainTapBarController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainTapBarController: UITabBarController {
    
}

#if DEBUG

import SwiftUI

struct MainTapBarController_Previews: PreviewProvider {
    static var previews: some View {
        MainTapBarController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct MainTapBarController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MainTapBarController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
