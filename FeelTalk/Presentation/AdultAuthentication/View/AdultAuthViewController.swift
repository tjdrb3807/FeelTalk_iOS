//
//  AdultAuthViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthViewController: UIViewController {
    var viewModel: AdultAuthViewModel!
    private let isConsentBottomSheetHidden = BehaviorRelay<Bool>(value: true)
    private let isNewsAgencyBottomSheetHidden = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .signUp) }()
    
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: (1/3)) }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     서비스 이용을 위해
                     인증 정보를 입력해 주세요.
                     """
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 24.0)
        label.setLineHeight(height: CommonConstraintNameSpace.verticalRatioCalculator * 4.43) // 36.0
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .black
        scrollView.setTapGesture()
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = CommonConstraintNameSpace.verticalRatioCalculator * 1.47    // 12.0
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var nameInputView: CustomTextField = {
        let view = CustomTextField(placeholder: "이름")
        view.inputAccessoryView = nameInputViewAccessoryView
        
        return view
    }()
    
    private lazy var nameInputViewAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    private lazy var idCardNumberInputView: AdultAuthIDCardNumberInputView = { AdultAuthIDCardNumberInputView() }()
    
    private lazy var phoneInfoInputView: AdultAuthPhoneInfoInputView = { AdultAuthPhoneInfoInputView() }()
    
    private lazy var consentView: AdultAuthConsentView = { AdultAuthConsentView() }()
    
    private lazy var authNumberInfoview: AdultAuthNumberInfoView = { AdultAuthNumberInfoView() }()
    
    private lazy var spacingView: UIView = { UIView() }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: 18.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = (CommonConstraintNameSpace.verticalRatioCalculator * 7.26) / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    private func bind() {
        nameInputViewAccessoryView
            .rightButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.idCardNumberInputView
                    .birthdayInputTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        idCardNumberInputView
            .birthdayInputTextFieldInputAccesscoryView
            .rightButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.idCardNumberInputView
                    .genderNumberInputView
                    .genderNumberInputTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
    }
    
    private func bind(to viewModel: AdultAuthViewModel) {
        let input = AdultAuthViewModel.Input(
            inputName: nameInputView.rx.text.orEmpty.asObservable(),
            inputBirthday: idCardNumberInputView.birthdayInputTextField.rx.text.orEmpty.asObservable(),
            inputGenderNumber: idCardNumberInputView.genderNumberInputView.genderNumberInputTextField.rx.text.orEmpty.asObservable(),
            tapNewsAgencyButton: phoneInfoInputView.newsAgencyButton.rx.tap.asObservable(),
            inputPhoneNumber: phoneInfoInputView.phoneNumberInputView.rx.text.orEmpty.asObservable(),
            tapConsentButton: consentView.consentButton.rx.tap.asObservable(),
            inputAuthNumber: authNumberInfoview.numberInputView.authNumberInputView.rx.text.orEmpty.asObservable(),
            tapAuthButton: authNumberInfoview.numberInputView.authButton.rx.tap.asObservable(),
            tapCompleteButton: completeButton.rx.tap.asObservable(),
            tapDismissButton: navigationBar.leftButton.rx.tap.asObservable())
        
        let output = viewModel.transfer(input: input)
        
        output
            .keyboardHeight
            .skip(1)
            .withUnretained(self)
            .bind { vc, height in
                let height = height > 0.0 ? -height + vc.view.safeAreaInsets.bottom : 0.0
                vc.updateKeyboardHeight(height)
            }.disposed(by: disposeBag)
        
        output
            .selectedNewsAgency
            .bind(to: phoneInfoInputView.selectedNewsAgency)
            .disposed(by: disposeBag)
        
        output
            .isConsented
            .bind(to: consentView.consentButton.isConsented)
            .disposed(by: disposeBag)
        
        output
            .isWarningViewHidden
            .bind(to: consentView.isWarningViewHidden)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() { view.backgroundColor = .white }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
        makePrograssBarConstraints()
        makeTitleLabelConstraints()
        makeScrollViewConstraints()
        makeContentStackViewConstraints()
        makeNameInputViewConstraints()
        makeIdCardInputViewConstraints()
        makePhoneInfoInputViewConstraints()
        makeConsentViewConstraints()
        makeAuthNumberInfoViewConstraints()
        makeSpacingViewConstraints()
        makeCompleteButtonConstrains()
    }
}

extension AdultAuthViewController {
    private func addViewSubComponents() {
        [navigationBar, progressBar, titleLabel, scrollView].forEach { view.addSubview($0) }
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
            $0.top.equalTo(progressBar.snp.bottom).offset(CommonConstraintNameSpace.verticalRatioCalculator * 3.44) // 28.0
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(CommonConstraintNameSpace.verticalRatioCalculator * 1.97) // 16.0
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [nameInputView, idCardNumberInputView, phoneInfoInputView,
         consentView, authNumberInfoview,
         spacingView, completeButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeNameInputViewConstraints() {
        nameInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(CommonConstraintNameSpace.verticalRatioCalculator * 6.89)
        }
    }
    
    private func makeIdCardInputViewConstraints() {
        idCardNumberInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AdultAuthIDCardNumberInputViewNameSpace.height)
        }
    }
    
    private func makePhoneInfoInputViewConstraints() {
        phoneInfoInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AdultAuthPhoneInfoInputViewNameSpace.height)
        }
    }
    
    private func makeConsentViewConstraints() {
        consentView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeAuthNumberInfoViewConstraints() {
        authNumberInfoview.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AdultAuthNumberInfoViewNameSpace.height)
        }
    }
    
    private func makeSpacingViewConstraints() {
        spacingView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(CommonConstraintNameSpace.verticalRatioCalculator * 10.46)
        }
    }
    
    private func makeCompleteButtonConstrains() {
        completeButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset))
            $0.height.equalTo(CommonConstraintNameSpace.verticalRatioCalculator * 7.26)
        }
    }
}

extension AdultAuthViewController {
    fileprivate func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        view.layoutIfNeeded()
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthViewController_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct AdultAuthViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = AdultAuthViewController()
            let vm = AdultAuthViewModel(coordiantor: DefaultAdultAuthCoordiantor(UINavigationController()),
                                        signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
