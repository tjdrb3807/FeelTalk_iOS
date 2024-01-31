//
//  LockingHintSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum LockingHintSettingsViewMode {
    case settings
    case input
}

final class LockingHintSettingsViewController: UIViewController {
    let viewMode = PublishRelay<LockingHintSettingsViewMode>()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .lockingHintSettings, isRootView: false) }()
    
    private lazy var descriptionView: LockingHintSettingsDescriptionView = { LockingHintSettingsDescriptionView() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind() {
        
    }
    
    private func setConfigurations() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeNavigationBarConstratins()
        makeDescriptionViewConstraints()
    }
}

extension LockingHintSettingsViewController {
    private func addViewSubComponents() {
        [navigationBar, descriptionView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstratins() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(CustomNavigationBarNameSpace.height)
        }
    }
    
    private func makeDescriptionViewConstraints() {
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(126)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingHintSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockingHintSettingsViewController_Presentable()
    }
    
    struct LockingHintSettingsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = LockingHintSettingsViewController()
            
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
