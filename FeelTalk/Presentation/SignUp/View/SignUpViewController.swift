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
    var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .signUp) }()
    
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: (1/3)) }()
    
    private lazy var titleLabel: SignUpTitleView = { SignUpTitleView() }()
    
    private lazy var adultAuthenticationView: SignUpAdultAuthenticationView = { SignUpAdultAuthenticationView() }()
    
    private lazy var infoConsentView: SignUpInfoConsentView = { SignUpInfoConsentView() }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8) // 18.0
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main400)
        button.layer.cornerRadius = (CommonConstraintNameSpace.verticalRatioCalculator * 7.26 ) / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponent()
        self.setConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    private func bind(to viewModel: SignUpViewModel) {
        let input = SignUpViewModel.Input(tapAuthButton: adultAuthenticationView.authButton.rx.tap.asObservable(),
                                          tapNextButton: nextButton.rx.tap.asObservable(),
                                          tapFullSelectionButton: infoConsentView.fullInfoSelectionView.fullSelectionButton.rx.tap.asObservable(),
                                          tapServiceConsentButton: infoConsentView.serviceConsentRow.checkButton.rx.tap.asObservable(),
                                          tapPersonalInfoConsentButton: infoConsentView.personalInfoConsentRow.checkButton.rx.tap.asObservable(),
                                          tapSensitiveInfoConsentButton: infoConsentView.sensitiveInfoConsentRow.checkButton.rx.tap.asObservable(),
                                          tapMarketingInfoConsentButton: infoConsentView.marketingInfoConsentRow.checkButton.rx.tap.asObservable(),
                                          tapPopButton: navigationBar.leftButton.rx.tap.asObservable())
        
        let output = viewModel.transfer(input: input)
        
        output.adultAuthenticated
            .withUnretained(self)
            .bind { vc, status in
                vc.titleLabel.adultAuthenticated.accept(status)
                vc.adultAuthenticationView.adultAuthenticated.accept(status)
                if status == .authenticated {
                    vc.updateAuthenticationViewConstraints()
                    vc.updateViewSubComponents()
                    vc.makeInfoConsentviewConstraints()
                    vc.makeNextButtonConstraints()
                }
            }.disposed(by: disposeBag)
        
        output.isFullConsentSeleted
            .bind(to: infoConsentView.fullInfoSelectionView.fullSelectionButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isServiceConsentSeleted
            .bind(to: infoConsentView.serviceConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isPersonalInfoConsentSeleted
            .bind(to: infoConsentView.personalInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isSensitiveInfoConsentSelected
            .bind(to: infoConsentView.sensitiveInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isMarketingInfoConsentSelected
            .bind(to: infoConsentView.marketingInfoConsentRow.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .withUnretained(self)
            .bind { vc, state in
                state ?
                vc.nextButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
                vc.nextButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
                
                vc.nextButton.rx.isEnabled.onNext(state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { view.backgroundColor = .white }
    
    private func addSubComponent() { addViewSusbComponents() }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
        makePrograssBarConstraints()
        makeTitleLabelConstraints()
        makeAdutlAuthenticationViewConstraints()
    }
}

// MARK: UI setting method.
extension SignUpViewController {
    private func addViewSusbComponents() {
        [navigationBar, progressBar, titleLabel, adultAuthenticationView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpFlowNavigationBarNameSpace.navigationBarHeight)
        }
    }
    
    private func makePrograssBarConstraints() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomProgressBarNameSpace.progressBarHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(SignUpTitleViewNameSpace.topOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpTitleViewNameSpace.height)
        }
    }
    
    private func makeAdutlAuthenticationViewConstraints() {
        adultAuthenticationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(SignUpAdultAuthenticationViewNameSpace.nonAuthenticatedStatusTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeInfoConsentviewConstraints() {
        infoConsentView.snp.makeConstraints {
            $0.top.equalTo(adultAuthenticationView.snp.bottom).offset(SignUpInfoConsentViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeNextButtonConstraints() {
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaInsets)
            $0.height.equalTo(CommonConstraintNameSpace.verticalRatioCalculator * 7.26)
        }
    }
}

extension SignUpViewController {
    private func updateAuthenticationViewConstraints() {
        adultAuthenticationView.snp.updateConstraints { $0.top.equalTo(titleLabel.snp.bottom) }
    }
    
    private func updateViewSubComponents() {
        [infoConsentView, nextButton].forEach { view.addSubview($0) }
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
            let vc = SignUpViewController()
            let vm = SignUpViewModel(coordinator: DefaultSignUpCoordinator(UINavigationController()),
                                     signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
