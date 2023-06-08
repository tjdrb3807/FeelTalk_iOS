//
//  SignUpViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var buttonVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.23
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var kakaoButton = KakaoButton()
    private lazy var naverButton = NaverButton()
    private lazy var googleButton = GoogleButton()
    private lazy var appleButton = AppleButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.bindViewModel()
        self.setConfig()
    }
    
    private func setConfig() {
        [kakaoButton, naverButton, googleButton, appleButton].forEach { buttonVerticalStackView.addArrangedSubview($0) }
        
        kakaoButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 100 * 78.4)
            $0.height.equalTo(UIScreen.main.bounds.height / 100 * 6.15)
        }
        
        naverButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 100 * 78.4)
            $0.height.equalTo(UIScreen.main.bounds.height / 100 * 6.15)
        }
        
        googleButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 100 * 78.4)
            $0.height.equalTo(UIScreen.main.bounds.height / 100 * 6.15)
        }
        
        appleButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 100 * 78.4)
            $0.height.equalTo(UIScreen.main.bounds.height / 100 * 6.15)
        }
        
        [buttonVerticalStackView].forEach { view.addSubview($0) }
        
        buttonVerticalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        kakaoButton.rx.tap
            .bind(onNext: {
                let viewController = UserInfoConsentViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }).disposed(by: disposeBag)
    }
}

#if DEBUG

import SwiftUI

struct SignUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignUpViewController_Presentable()
    }
    
    struct SignUpViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            SignUpViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
