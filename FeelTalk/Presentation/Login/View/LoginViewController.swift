//
//  LoginViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// ScressID: L010
///
/// 구글, 카카오, 네이버, 애플 로그인, 하단 문의하기 버튼
final class LoginViewController: UIViewController {
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var logoView: LoginLogoView = { LoginLogoView() }()
    
    private lazy var bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = LoginViewNameSpace.loginButtonStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var kakaoLoginButton: LoginButton = { LoginButton(snsType: .kakao) }()
    
    private lazy var googleLoginButton: LoginButton = { LoginButton(snsType: .google) }()
    
    private lazy var naverLoginButton: LoginButton = { LoginButton(snsType: .naver) }()
    
    private lazy var appleLoginButton: LoginButton = { LoginButton(snsType: .apple) }()
    
    private lazy var speechBubble: LoginSpeechBubbleView = { LoginSpeechBubbleView() }()
    
    private lazy var inquiryButton: CustomBottomBorderButton = { CustomBottomBorderButton(title: LoginViewNameSpace.inquiryButtonTitleText) }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttribute()
        self.addSubComponent()
        self.setConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func bind(to viewModel: LoginViewModel) {
        let input = LoginViewModel.Input(tapAppleLoginButton: appleLoginButton.rx.tap,
                                         tapGoogleLoginButton: googleLoginButton.rx.tap,
                                         tapKakaoLoginButton: kakaoLoginButton.rx.tap,
                                         tapNaverLoginButton: naverLoginButton.rx.tap,
                                         tapInquiryButton: inquiryButton.rx.tap)
        
        _ = viewModel.transfer(input: input)
    }
    
    private func setAttribute() {
//        view.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubComponent() {
        addViewSubComponents()
        addLoginButtonStackViewComponents()
    }
    
    private func setConfiguration() {
        makeLogoViewConstraints()
        makeBottomSheetConstraints()
        makeLoginButtonStackViewConstraints()
        makeLoginButtonsConstraints()
        makeSpeechBubbleConstraints()
        makeInquiryButtonConstraints()
    }
}

extension LoginViewController {
    private func addViewSubComponents() {
        [logoView, bottomSheet, loginButtonStackView, speechBubble, inquiryButton].forEach { view.addSubview($0) }
    }
    
    private func makeLogoViewConstraints() {
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LoginLogoViewNameSpace.topOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeBottomSheetConstraints() {
        bottomSheet.snp.makeConstraints {
            $0.top.equalToSuperview().inset(CommonConstraintNameSpace.verticalRatioCalculator * 42.98) // 349
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeLoginButtonStackViewConstraints() {
        loginButtonStackView.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(LoginViewNameSpace.loginButtonStackViewTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func addLoginButtonStackViewComponents() {
        [kakaoLoginButton, googleLoginButton, naverLoginButton, appleLoginButton].forEach { loginButtonStackView.addArrangedSubview($0) }
    }
    
    private func makeLoginButtonsConstraints() {
        [kakaoLoginButton, googleLoginButton, naverLoginButton, appleLoginButton].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(LoginButtonNameSpace.buttonHeight) }
        }
    }
    
    private func makeSpeechBubbleConstraints() {
        speechBubble.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(LoginSpeechBubbleViewNameSpace.leadingInset)
            $0.bottom.equalTo(loginButtonStackView.snp.top).offset(LoginSpeechBubbleViewNameSpace.bottomOffset)
            $0.width.equalTo(LoginSpeechBubbleViewNameSpace.width)
            $0.height.equalTo(LoginSpeechBubbleViewNameSpace.height)
        }
    }
    
    private func makeInquiryButtonConstraints() {
        inquiryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButtonStackView.snp.bottom).offset(LoginViewNameSpace.inquiryButtonTopOffset)
            $0.height.equalTo(LoginViewNameSpace.inquiryButtonHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LoginViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LoginViewController()
            let vm = LoginViewModel(coordinator: DefaultLoginCoordinator(UINavigationController()),
                                    loginUseCase: DefaultLoginUseCase(loginRepository: DefaultLoginRepository(),
                                                                      appleRepository: DefaultAppleRepository(),
                                                                      googleRepositroy: DefaultGoogleRepository(),
                                                                      naverRepository: DefaultNaverLoginRepository(),
                                                                      kakaoRepository: DefaultKakaoRepository(),
                                                                      userRepository: DefaultUserRepository()))
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
