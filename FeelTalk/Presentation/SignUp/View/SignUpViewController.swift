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

/// Sscreen ID: L020
///
/// 회원가입 첫 화면
///
/// 성인 인증 화면 유도 화면
final class SignUpViewController: UIViewController {
    private var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    var snsLogin: SNSLogin?
    
    // MARK: SubComponents
    private lazy var fullVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(viewType: .signUp) }()
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: (1/3)) }()
    private lazy var informationPhrase: InformationPhraseView = { return InformationPhraseView() }()
    private lazy var spacing: UIView = { return UIView() }()
    private lazy var adultCertificationView: AdultCertificationView = { return AdultCertificationView() }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(SignUpViewNameSpace.nextButtonTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: SignUpViewNameSpace.nextButtonTitleFont, size: SignUpViewNameSpace.nextButtonTitleSize)
        button.backgroundColor = UIColor(named: SignUpViewNameSpace.nextButtonBackgroundColor)
        button.layer.cornerRadius = SignUpViewNameSpace.nextButtonHeight / 2
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
                vc.informationPhrase.informationLabel.rx.text.onNext(SignUpViewNameSpace.infomationLabelUpdateText)
                vc.spacing.snp.updateConstraints { $0.height.equalTo(SignUpViewNameSpace.signUpSpacingViewUpdateHeight) }
                vc.adultCertificationView.idCard.snp.updateConstraints { $0.height.equalTo(SignUpViewNameSpace.idCardUpdateHeight) }
                vc.adultCertificationView.idCard.rx.contentMode.onNext(.scaleAspectFit)
                vc.adultCertificationView.explanationLabel.rx.text.onNext(SignUpViewNameSpace.explanationLabelUpdateText)
                vc.adultCertificationView.setAuthSuccessUI()
                
                vc.view.addSubview(vc.nextButton)
                
                vc.nextButton.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(SignUpViewNameSpace.nextButtonUpdateHorizontalInset)
                    $0.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.bottom)
                    $0.height.equalTo(SignUpViewNameSpace.nextButtonUpdateHeight)
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
        
        [navigationBar, progressBar, fullVerticalStackView].forEach { view.addSubview($0) }
    }
    
    private func setConfiguration() {
        makeNavigationBarConstraints()
        makePrograssBarConstraints()
        makeInformationPhraseConstraints()
        makeSpacingConstraints()
        makeIdCardConstraints()
        makeFullVerticalStackViewConstraints()
    }
}

// MARK: UI setting method.
extension SignUpViewController {
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomNavigationBarNameSpace.navigationBarHeight)
        }
    }
    
    private func makePrograssBarConstraints() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomProgressBarNameSpace.progressBarHeight)
        }
    }
    
    private func addFullVerticalStackViewSubComponents() {
        [informationPhrase, spacing, adultCertificationView].forEach { fullVerticalStackView.addArrangedSubview($0) }
    }
    
    private func makeInformationPhraseConstraints() {
        informationPhrase.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpViewNameSpace.informationPhraseHeight)
        }
    }
    
    private func makeSpacingConstraints() {
        spacing.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpViewNameSpace.signUpSpacingViewHeight)
        }
    }
    
    private func makeIdCardConstraints() {
        adultCertificationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SignUpViewNameSpace.adutlCertificationViewHorizontalInset)
        }
    }
    
    private func makeFullVerticalStackViewConstraints() {
        fullVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(SignUpViewNameSpace.fullHorizontalStackViewTopOffset)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct SignUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignUpViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct SignUpViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            SignUpViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
