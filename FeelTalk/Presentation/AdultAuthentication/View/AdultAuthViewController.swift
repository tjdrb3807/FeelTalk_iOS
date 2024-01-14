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
import RxKeyboard

final class AdultAuthViewController: UIViewController {
    var viewModel: AdultAuthViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .signUp) }()
    
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: AdultAuthViewControllerNameSpace.ProgressBarPersentage) }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthViewControllerNameSpace.titleLabelText
        label.textColor = .black
        label.numberOfLines = AdultAuthViewControllerNameSpace.titleLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: AdultAuthViewControllerNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: AdultAuthViewControllerNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .black
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = AdultAuthViewControllerNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var nameInputView: CustomTextField = {
        let view = CustomTextField(placeholder: AdultAuthViewControllerNameSpace.nameInputViewPlaceholer)
        view.inputAccessoryView = nameInputViewAccessoryView
        
        return view
    }()
    
    private lazy var nameInputViewAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    private lazy var idCardNumberInputView: AdultAuthIDCardNumberInputView = { AdultAuthIDCardNumberInputView() }()
    
    private lazy var phoneInfoInputView: AdultAuthPhoneInfoInputView = { AdultAuthPhoneInfoInputView() }()
    
    private lazy var consentView: AdultAuthConsentView = { AdultAuthConsentView() }()
    
    private lazy var authNumberInfoView: AdultAuthNumberInfoView = { AdultAuthNumberInfoView() }()
    
    private lazy var firstSpacingView: UIView = { UIView() }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle(AdultAuthViewControllerNameSpace.completeButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: AdultAuthViewControllerNameSpace.completeButtonTitleTextSize)
        button.layer.cornerRadius = AdultAuthViewControllerNameSpace.completeButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var secondSpacingView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardListener()
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
        
        idCardNumberInputView
            .genderNumberInputView
            .genderNumberTextFiledInputAccessoryView
            .rightButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.phoneInfoInputView.newsAgencyButton.isEditing.accept(true)
            }.disposed(by: disposeBag)
        
        phoneInfoInputView
            .newsAgencyButton
            .selectedNewsAgency
            .skip(1)
            .withUnretained(self)
            .bind { vc, _ in
                vc.phoneInfoInputView.phoneNumberInputView.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        authNumberInfoView
            .numberInputView
            .authNumberInputAccessoryView
            .rightButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismissKeyboard()
            }.disposed(by: disposeBag)
        
        Observable<AdultAuthViewScrollDirection>
            .merge(nameInputView.rx.controlEvent(.editingDidBegin).map { .nameInputView },
                   idCardNumberInputView.isEditing.filter { $0 == true }.map { _ in .idCardNumberInputview },
                   phoneInfoInputView.phoneNumberInputView.rx.controlEvent(.editingDidBegin).map { .phoneInfoInputView },
                   authNumberInfoView.numberInputView.authNumberInputView.rx.controlEvent(.editingDidBegin).map { .authNumberInfoView })
            .withUnretained(self)
            .bind { vc, type in
                vc.scrollView.scroll(to: type)
            }.disposed(by: disposeBag)
        
        authNumberInfoView
            .numberInputView
            .authNumberInputView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .withUnretained(self)
            .bind { vc, state in
                vc.completeButton.rx.isEnabled.onNext(state)
                vc.updateCompleteButtonBackgroundColor(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func bind(to viewModel: AdultAuthViewModel) {
        let showNewsAgnecyBottomSheet = PublishRelay<Void>
            .merge(phoneInfoInputView.newsAgencyButton.rx.tap.asObservable(),
                   idCardNumberInputView.genderNumberInputView.genderNumberTextFiledInputAccessoryView.rightButton.rx.tap.asObservable())
        
        let showAuthConsentBottomSheet = PublishRelay<Void>
            .merge(phoneInfoInputView.phoneNumberInputAccessoryView.rightButton.rx.tap.asObservable(),
                   consentView.consentButton.rx.tap.asObservable())
        
        Observable
            .merge(showNewsAgnecyBottomSheet,
                   showAuthConsentBottomSheet)
            .withLatestFrom(RxKeyboard.instance.isHidden)
            .filter { $0 == false }
            .withUnretained(self)
            .bind { vc, state in
                vc.view.endEditing(state)
            }.disposed(by: disposeBag)
        
        let input = AdultAuthViewModel.Input(
            inputName: nameInputView.rx.text.orEmpty.asObservable(),
            inputBirthday: idCardNumberInputView.birthdayInputTextField.rx.text.orEmpty.asObservable(),
            inputGenderNumber: idCardNumberInputView.genderNumberInputView.genderNumberInputTextField.rx.text.orEmpty.asObservable(),
            tapNewsAgencyButton: showNewsAgnecyBottomSheet,
            inputPhoneNumber: phoneInfoInputView.phoneNumberInputView.rx.text.orEmpty.asObservable(),
            tapConsentButton: showAuthConsentBottomSheet,
            inputAuthNumber: authNumberInfoView.numberInputView.authNumberInputView.rx.text.orEmpty.asObservable(),
            tapAuthButton: authNumberInfoView.numberInputView.authButton.rx.tap.asObservable(),
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
            .withUnretained(self)
            .bind { vc, state in
                vc.consentView.isWarningViewHidden.accept(state)
            }.disposed(by: disposeBag)
        
        output.isRequested
            .bind(to: authNumberInfoView.numberInputView.isRequested)
            .disposed(by: disposeBag)
        
        output.authDescriptionState
            .bind(to: authNumberInfoView.descriptionState)
            .disposed(by: disposeBag)
            
        output.expiradTime
            .bind(to: authNumberInfoView.expiradTime)
            .disposed(by: disposeBag)
        
        output.focusedInputView
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .name:
                    vc.nameInputView.becomeFirstResponder()
                case .birthday:
                    vc.idCardNumberInputView.birthdayInputTextField.becomeFirstResponder()
                case .genderNumber:
                    vc.idCardNumberInputView.genderNumberInputView.genderNumberInputTextField.becomeFirstResponder()
                case .phoneNumber:
                    vc.phoneInfoInputView.phoneNumberInputView.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
        
        output.isAuthNumberInputViewEnable
            .bind(to: authNumberInfoView.numberInputView.authNumberInputView.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.popAlert
            .withUnretained(self)
            .bind { vc, _ in
                guard !vc.view.subviews.contains(where: {
                    $0 is AdultAuthAlertView
                }) else { return }
                
                let alertView = AdultAuthAlertView()
                vc.view.addSubview(alertView)
                
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                alertView.show()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
        self.scrollView.setTapGesture()
    }
    
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
        makeFristSpacingViewConstraints()
        makeCompleteButtonConstrains()
        makeSecondSpacingViewConstraints()
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
            $0.top.equalTo(progressBar.snp.bottom).offset(AdultAuthViewControllerNameSpace.titleLabelTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(AdultAuthViewControllerNameSpace.scrollViewTopOffset)
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
         consentView, authNumberInfoView,
         firstSpacingView, completeButton, secondSpacingView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeNameInputViewConstraints() {
        nameInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AdultAuthViewControllerNameSpace.nameInputViewHeight)
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
        authNumberInfoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AdultAuthNumberInfoViewNameSpace.height)
        }
    }
    
    private func makeFristSpacingViewConstraints() {
        firstSpacingView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(AdultAuthViewControllerNameSpace.firstSpacingViewHeight)
        }
    }
    
    private func makeCompleteButtonConstrains() {
        completeButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset))
            $0.height.equalTo(AdultAuthViewControllerNameSpace.completeButtonHeight)
        }
    }
    
    private func makeSecondSpacingViewConstraints() {
        secondSpacingView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(AdultAuthViewControllerNameSpace.secondSpacingViewHeight)
        }
    }
}

extension AdultAuthViewController {
    private func updateCompleteButtonBackgroundColor(with state: Bool) {
        state ?
        completeButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
        completeButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
    }
}

extension AdultAuthViewController {
    fileprivate func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        view.layoutIfNeeded()
    }
    
    private func addKeyboardListener() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        firstSpacingView.rx.isHidden.onNext(true)
        secondSpacingView.rx.isHidden.onNext(false)
    }
    
    @objc func keyboardWillHide(_ nofification: Notification) {
        firstSpacingView.rx.isHidden.onNext(false)
        secondSpacingView.rx.isHidden.onNext(true)
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
