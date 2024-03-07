//
//  LockScreenViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockScreenViewController: UIViewController {
    var viewModel: LockScreenViewModel!
    
    private lazy var logo: UIImageView = { UIImageView(image: UIImage(named: "logo_feeltalk_white")) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    private func setProperties() {
        view.backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    private func addSubComponents() {
        view.addSubview(logo)
    }
    
    private func setConstratins() {
        logo.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct LockScreenViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenViewController_Presentable()
    }
    
    struct LockScreenViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockScreenViewController()
            let vm = LockScreenViewModel(coordinator: DefaultLockScreenCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
