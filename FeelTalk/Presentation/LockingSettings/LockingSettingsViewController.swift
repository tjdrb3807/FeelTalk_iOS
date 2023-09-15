//
//  LockingSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingSettingViewController: UIViewController {
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(mode: .lockingSetting) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func setConfigurations() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        [navigationBar].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
    }
}

extension LockingSettingViewController {
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(60)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingSettingViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockingSettingViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LockingSettingViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            LockingSettingViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
