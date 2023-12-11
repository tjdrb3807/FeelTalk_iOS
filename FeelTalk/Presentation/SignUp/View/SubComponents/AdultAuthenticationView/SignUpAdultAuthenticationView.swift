//
//  SignUpAdultAuthenticationView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpAdultAuthenticationView: UIStackView {
    /// 성인인증 성공 여부
    let adultAuthenticated = PublishRelay<AdultAuthStatus>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleImageView: UIImageView = { UIImageView() }()
    
    private lazy var descriptionLabel: SignUpAdultAuthenticationDesctiptionView = { SignUpAdultAuthenticationDesctiptionView() }()
    
    lazy var authButton: UIButton = {
        let button = UIButton()
        button.setTitle(SignUpAdultAuthenticationViewNameSpace.authButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: SignUpAdultAuthenticationViewNameSpace.authButtonTitleTextSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = SignUpAdultAuthenticationViewNameSpace.authButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubCompoents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind () {
        adultAuthenticated
            .withUnretained(self)
            .bind { vm, state in
                vm.setStackViewProperties(with: state)
                vm.setTitleImageViewProperties(with: state)
                vm.descriptionLabel.adultAuthenticated.accept(state)
                vm.setAuthButtonProperties(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        backgroundColor = .clear
    }
    
    private func addSubCompoents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleImageViewConstraints()
        makeAuthButtonConstraints()
    }
}

extension SignUpAdultAuthenticationView {
    private func setStackViewProperties(with state: AdultAuthStatus) {
        switch state {
        case .authenticated:
            rx.spacing.onNext(SignUpAdultAuthenticationViewNameSpace.authenticatedStatusSpacing)
        case .nonAuthenticated:
            rx.spacing.onNext(SignUpAdultAuthenticationViewNameSpace.nonAuthenticatedStatusSpacing)
        }
    }
    
    private func setTitleImageViewProperties(with state: AdultAuthStatus) {
        switch state {
        case .authenticated:
            UIView.transition(
                with: titleImageView,
                duration: 0.3,
                options: .allowAnimatedContent,
                animations: { [weak self] in
                    guard let self = self else { return }
                    titleImageView.rx.image.onNext(UIImage(named: SignUpAdultAuthenticationViewNameSpace.titleImageViewAuthenticatedStatusImage))
                    titleImageView.snp.remakeConstraints {
                        $0.width.equalTo(SignUpAdultAuthenticationViewNameSpace.titleImageViewAuthenticatedStatusWidth)
                        $0.height.equalTo(SignUpAdultAuthenticationViewNameSpace.titleImageViewAuthenticatedStatusHeight)
                    }
                })
        case .nonAuthenticated:
            titleImageView.rx.image.onNext(UIImage(named: SignUpAdultAuthenticationViewNameSpace.titleImageViewNonAuthenticatedStatusImage))
        }
    }
    
    private func setAuthButtonProperties(with state: AdultAuthStatus) {
        switch state {
        case .authenticated:
            authButton.rx.isHidden.onNext(true)
        case .nonAuthenticated:
            authButton.rx.isHidden.onNext(false)
        }
    }
}

extension SignUpAdultAuthenticationView {
    private func addViewSubComponents() {
        [titleImageView, descriptionLabel, authButton].forEach { addArrangedSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(SignUpAdultAuthenticationViewNameSpace.titleImageViewNonAuthenticatedStatusHeight)
        }
    }
    
    private func makeAuthButtonConstraints() {
        authButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(SignUpAdultAuthenticationViewNameSpace.authButtonHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct SignUpAdultAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpAdultAuthenticationView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: SignUpAdultAuthenticationViewNameSpace.testAuthenticatedStatusHeight,
                   alignment: .center)
    }
    
    struct SignUpAdultAuthenticationView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignUpAdultAuthenticationView()
            v.adultAuthenticated.accept(AdultAuthStatus.authenticated)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
