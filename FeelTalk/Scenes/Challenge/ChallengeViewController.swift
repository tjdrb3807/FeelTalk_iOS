//
//  ChallengeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeViewController: UIViewController {
    private var childVCs = [WantChallengeCollectionViewController(), DoneChallengeCollectionViewController()]
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar = ChallengeViewNavigationBar()
    private lazy var countLabel = ChallengeViewCountLabel()
    fileprivate lazy var tabBar = ChallengeViewTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        self.setTabBarController()
        self.setBind()
    }
    
    private func setConfig() {
        [navigationBar, countLabel, tabBar].forEach { view.addSubview($0) }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 5.41)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 8.86)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 1.47)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 8.86)
        }
        
        tabBar.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 3.44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 5.91)
        }
    }
    
    private func setTabBarController() {
        tabBar.items
            .enumerated()
            .forEach { index, item in
                let vc = childVCs[index]
                
                addChild(vc)
                view.addSubview(vc.view)
                vc.didMove(toParent: self)
                
                vc.view.snp.makeConstraints {
                    $0.top.equalTo(tabBar.snp.bottom)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
                
                childVCs.append(vc)
            }
        
        guard let shouldFrontView = childVCs[0].view else { return }
        view.bringSubviewToFront(shouldFrontView)
    }
    
    private func setBind() {
        tabBar.rx.tapButton
            .bind(with: self) { ss, index in
                guard let shouldFrontView = ss.childVCs[index].view else { return }
                ss.view.bringSubviewToFront(shouldFrontView)
            }
            .disposed(by: disposeBag)
    }
        
}

//extension Reactive where Base: ChallengeViewController {
//    var changeIndex: Binder<Int> {
//        Binder(base) { base, index in
//            base.tabBar.rx.changeIndex.onNext(index)
//        }
//    }
//}

#if DEBUG

import SwiftUI

struct ChallengeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewController_Presentable()
    }
    
    struct ChallengeViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            ChallengeViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
