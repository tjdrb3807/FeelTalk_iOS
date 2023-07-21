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

final class LoginViewController: UIViewController {
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: LoginViewController sub components.
    
    /// introductionVerticalStackView
    /// - SubComponents
    ///
    ///     - feelTalkImageView
    ///     - introductionLabel
    private lazy var introVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = LoginViewNameSpace.introductionVerticalStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    // TODO: 디자인 미완성, 추후 변경작업 진행
    private lazy var feelTalkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "gray_300")
        
        return imageView
    }()
    
    private lazy var introLabel: UILabel = {
        let label = UILabel()
        label.text = LoginViewNameSpace.introductionText
        label.textColor = .black
        label.font = UIFont(name: LoginViewNameSpace.introductionLableFont, size: LoginViewNameSpace.introductionLabelSize)
        label.numberOfLines = LoginViewNameSpace.introductionLabelLines
        label.backgroundColor = .clear
        
        
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = LoginViewNameSpace.introductionLabelLineSpacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        return label
    }()
    
    /// loginButtonVerticalStackView
    /// - SubComponents
    ///
    ///     - kakaoLoginButton
    ///     - googleLoginButton
    ///     - naverLoginButton
    ///     - appleLoginButton
    private lazy var loginButtonVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = LoginViewNameSpace.loginButtonVerticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var kakaoLoginButton: LoginButton = { LoginButton(snsType: .kakao) }()
    private lazy var googleLoginButton: LoginButton = { LoginButton(snsType: .google) }()
    private lazy var naverLoginButton: LoginButton = { LoginButton(snsType: .naver) }()
    private lazy var appleLoginButton: LoginButton = { LoginButton(snsType: .appleIOS) }()
    
    // MARK: Life cycle method.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setAttribute()
        self.addSubComponent()
        self.setConfiguration()
        self.bind(to: viewModel)
    }
    
    final class func create(with viewModel: LoginViewModel) -> LoginViewController {
        let viewController = LoginViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func bind(to viewModel: LoginViewModel) {
        let input = LoginViewModel.Input(tapAppleLoginButton: appleLoginButton.rx.tap,
                                         tapGoogleLoginButton: googleLoginButton.rx.tap,
                                         tapKakaoLoginButton: kakaoLoginButton.rx.tap,
                                         tapNaverLoginButton: naverLoginButton.rx.tap)



        let output = viewModel.transfer(input: input)
    }
    
    // MARK: Default ui settings method.
    private func setAttribute() {
        view.backgroundColor = UIColor(named: LoginViewNameSpace.loginViewBackgroundColor)
    }
    
    private func addSubComponent() {
        addIntroVerticalStackViewSubViews()
        addLoginButtonVerticalStackViewSubViews()
        [introVerticalStackView, loginButtonVerticalStackView].forEach { view.addSubview($0) }
    }
    
    private func setConfiguration() {
        makeFeelTalkImageViewConstraints()
        makeIntroVerticalStackViewConstraints()
        makeLoginButtonsConstraints()
        makeLoginButtonVerticalStackViewConstraints()
    }
}

// MARK: UI settings method.
extension LoginViewController {
    private func addIntroVerticalStackViewSubViews() {
        [feelTalkImageView, introLabel].forEach { introVerticalStackView.addArrangedSubview($0) }
    }
    
    private func makeFeelTalkImageViewConstraints() {
        feelTalkImageView.snp.makeConstraints {
            $0.width.equalTo(LoginViewNameSpace.feelTalkImageViewWidth)
            $0.height.equalTo(feelTalkImageView.snp.width)
        }
    }
    
    private func makeIntroVerticalStackViewConstraints() {
        introVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(LoginViewNameSpace.introductionVerticalSatckViewTopInset)
            $0.leading.equalToSuperview().inset(LoginViewNameSpace.introductionVerticalStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(LoginViewNameSpace.introductionVerticalStackViewTrailingInset)
        }
    }
    
    private func addLoginButtonVerticalStackViewSubViews() {
        [kakaoLoginButton, googleLoginButton, naverLoginButton, appleLoginButton].forEach { loginButtonVerticalStackView.addArrangedSubview($0) }
    }
    
    private func makeLoginButtonsConstraints() {
        [kakaoLoginButton, googleLoginButton, naverLoginButton, appleLoginButton].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(LoginButtonNameSpace.buttonHeight) }
        }
    }
    
    private func makeLoginButtonVerticalStackViewConstraints() {
        loginButtonVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(introVerticalStackView.snp.bottom).offset(LoginViewNameSpace.loginButtonVerticalStackViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(LoginViewNameSpace.loginButtonVerticalStackViewLeadingInset)
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
            LoginViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
