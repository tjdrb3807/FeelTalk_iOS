//
//  HomeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 2.46
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var topSectionView = HomeTopSectionView()
    private lazy var bottomSectionView = HomeBottomSectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.bindViewModel()
        self.setConfig()
    }
    
    private func bindViewModel() {
        bottomSectionView.coupleSignalView.mySignalButton.rx.tap
            .bind(onNext: {
                print("hello")
            }).disposed(by: disposeBag)
        
        topSectionView.homeNavigationBar.pushChatViewButton.rx.tap
            .bind(onNext: {
                self.navigationController?.present(ChatViewController().self, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setConfig() {
        [topSectionView, bottomSectionView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        topSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 56.60)
        }
        
        view.addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct HomeViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            HomeViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
