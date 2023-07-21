//
//  SignUpViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    private var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    var snsLogin: SNSLogin?
    
    private lazy var fullVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var informationPhrase: InformationPhraseView = { return InformationPhraseView() }()
    private lazy var spacing: UIView = { return UIView() }()
    private lazy var adultCertificationView: AdultCertificationView = { return AdultCertificationView() }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(SignUpNameSpace.nextButtonTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: SignUpNameSpace.nextButtonTitleFont, size: SignUpNameSpace.nextButtonTitleSize)
        button.backgroundColor = UIColor(named: SignUpNameSpace.nextButtonBackgroundColor)
        button.layer.cornerRadius = SignUpNameSpace.nextButtonHeight / 2
        button.isEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttribute()
        self.addSubComponent()
        self.setConfiguration()
        self.bind(to: viewModel)
    }
    
    final class func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let viewController = SignUpViewController()
        viewController.viewModel = viewModel

        return viewController
    }
    
    private func bind(to viewModel: SignUpViewModel) {
        let input = SignUpViewModel.Input(
//            tapAuthButton: adultCertificationView.authButtton.rx.tap,
            tapAuthButton: adultCertificationView.authButtton.rx.tap.map { _ in self.snsLogin }.asObservable(),
                                          tapNextButton: nextButton.rx.tap,
                                          tapTotalConsentButton: adultCertificationView.informationConsentView.totalConsentButton.rx.tap,
                                          tapServiceConsentButton: adultCertificationView.informationConsentView.serviceConsentRow.checkButton.rx.tap,
                                          tapPersonalInfoConsentButton: adultCertificationView.informationConsentView.personalInfoConsentRow.checkButton.rx.tap,
                                          tapSensitiveInfoConsentButton: adultCertificationView.informationConsentView.sensitiveInfoConsentRow.checkButton.rx.tap,
                                          tapMarketingInfoConsentButton: adultCertificationView.informationConsentView.marketingInfoConsentRow.checkButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.setInfoConsentUI
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.informationPhrase.informationLabel.rx.text.onNext(SignUpNameSpace.infomationLabelUpdateText)
                vc.adultCertificationView.idCard.snp.updateConstraints { $0.height.equalTo(SignUpNameSpace.idCardUpdateHeight) }
                vc.adultCertificationView.idCard.rx.contentMode.onNext(.scaleAspectFit)
                vc.adultCertificationView.explanationLabel.rx.text.onNext(SignUpNameSpace.explanationLabelUpdateText)
                vc.adultCertificationView.setAuthSuccessUI()
                
                vc.view.addSubview(vc.nextButton)
                
                vc.nextButton.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(SignUpNameSpace.nextButtonUpdateHorizontalInset)
                    $0.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.bottom)
                    $0.height.equalTo(SignUpNameSpace.nextButtonUpdateHeight)
                }
            }).disposed(by: disposeBag)
        
        output.totalConsentIsSelected
            .bind(to: adultCertificationView.informationConsentView.totalConsentButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.serviceConsentIsSelected
            .bind(to: adultCertificationView.informationConsentView.serviceConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.personalInfoConsentIsSelected
            .bind(to: adultCertificationView.informationConsentView.personalInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.sensitiveInfoConsentIsSelected
            .bind(to: adultCertificationView.informationConsentView.sensitiveInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.marketingInfoConsentIsSelected
            .bind(to: adultCertificationView.informationConsentView.marketingInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnable
            .withUnretained(self)
            .bind(onNext: { vc, state in
                state ? vc.nextButton.rx.backgroundColor.onNext(UIColor(named: "main_500")) :
                vc.nextButton.rx.backgroundColor.onNext(UIColor(named: "main_400"))
                vc.nextButton.rx.isEnabled.onNext(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        view.backgroundColor = .white
    }
    
    private func addSubComponent() {
        addFullVerticalStackViewSubComponents()
        view.addSubview(fullVerticalStackView)
    }
    
    private func setConfiguration() {
        makeInformationPhraseConstraints()
        makeSpacingConstraints()
        makeIdCardConstraints()
        makeFullVerticalStackViewConstraints()
    }
}

// MARK: UI setting method.
extension SignUpViewController {
    private func addFullVerticalStackViewSubComponents() {
        [informationPhrase, spacing, adultCertificationView].forEach { fullVerticalStackView.addArrangedSubview($0) }
    }
    
    private func makeInformationPhraseConstraints() {
        informationPhrase.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpNameSpace.informationPhraseHeight)
        }
    }
    
    private func makeSpacingConstraints() {
        spacing.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpNameSpace.signUpSpacingViewHeight)
        }
    }
    
    private func makeIdCardConstraints() {
        adultCertificationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SignUpNameSpace.adutlCertificationViewHorizontalInset)
        }
    }
    
    private func makeFullVerticalStackViewConstraints() {
        fullVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(SignUpNameSpace.fullHorizontalStackViewTopOffset)
            $0.leading.trailing.equalToSuperview()
        }
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
