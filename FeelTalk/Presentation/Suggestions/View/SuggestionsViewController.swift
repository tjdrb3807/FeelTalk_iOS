//
//  SuggestionsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SuggestionsViewController: UIViewController {
    var viewModel: SuggestionsViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .suggestions, isRootView: true) }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.indicatorStyle = .black
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = SuggestionsViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var topSpacingView: UIView = { UIView() }()
    
    private lazy var descriptionView: SuggestionsDescriptionsView = { SuggestionsDescriptionsView() }()
    
    private lazy var ideaInputView: SuggestionsIdeaInputView = { SuggestionsIdeaInputView() }()
    
    private lazy var emailInputView: SuggestionsEmailInputView = { SuggestionsEmailInputView() }()
    
    private lazy var bottomSpacingView: UIView = { UIView() }()
    
    private lazy var submitButton: CustomButton = { CustomButton(type: .register,
                                                                 title: SuggestionsViewNameSpace.submitButtonTitleText) }()
    
    private lazy var alertView: CustomAlertView = { CustomAlertView(type: .suggestion) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
        self.bind()
        self.bind(to: viewModel)
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind() {
        ideaInputView.ideaInputTextView.textView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.scrollToTop()
            }.disposed(by: disposeBag)
        
        emailInputView.emailInputTextField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.scrollToBottom()
            }.disposed(by: disposeBag)
        
        ideaInputView.ideaInputTextViewAccessoryView.rightButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                DispatchQueue.main.async {
                    vc.emailInputView.emailInputTextField.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
    }
    
    private func bind(to viewModel: SuggestionsViewModel) {
        let input = SuggestionsViewModel.Input(ideaText: ideaInputView.ideaInputTextView.textView.rx.text.orEmpty,
                                               ideaTextCount: ideaInputView.ideaInputTextView.countingView.molecularCount.asObservable(),
                                               emailText: emailInputView.emailInputTextField.rx.text.orEmpty,
                                               tapSubmitButton: submitButton.rx.tap,
                                               tapCompletionButton: emailInputView.emailInputViewAccessoryView.rightButton.rx.tap,
                                               tapDismissButton: navigationBar.leftButton.rx.tap,
                                               tapAlertExitButton: alertView.rightButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeight(height)
            }.disposed(by: disposeBag)
    
        output.isValid
            .withUnretained(self)
            .bind { vc, state in
                vc.submitButton.isState.accept(state)
            }.disposed(by: disposeBag)
        
        output.focusingInputView
            .withUnretained(self)
            .bind { vc, focuseNumber in
                DispatchQueue.main.async { vc.isFocused(to: focuseNumber) }
            }.disposed(by: disposeBag)
        
        output.popUpAlert
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismissKeyboard()
                guard !vc.view.subviews.contains(where: { $0 is CustomAlertView }) else { return }
                let alertView = vc.alertView
                vc.view.addSubview(alertView)
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                
                alertView.show()
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeScrollViewConstraints()
        makeContentStackViewConstraints()
        makeDescriptionViewConstraints()
        makeIdeaInputViewConstraints()
        makeEmailInputViewconstraints()
        makeSubmitButtonConstratins()
    }
}

extension SuggestionsViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, submitButton].forEach { view.addSubview($0) }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
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
        [topSpacingView, descriptionView, ideaInputView, emailInputView, bottomSpacingView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionViewConstraints() {
        descriptionView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeIdeaInputViewConstraints() {
        ideaInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeEmailInputViewconstraints() {
        emailInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeSubmitButtonConstratins() {
        submitButton.snp.makeConstraints {
            $0.top.equalTo(submitButton.snp.bottom).offset(-CustomButtonNameSpace.height)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension SuggestionsViewController {
    fileprivate func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        view.layoutIfNeeded()
    }
    
    /// 0: ideaInputView
    /// 1: emailInputView
    private func isFocused(to number: Int) {
        if number == 0 {
            ideaInputView.ideaInputTextView.textView.becomeFirstResponder()
        } else if number == 1 {
            dismissKeyboard()
        }
    }
}

#if DEBUG

import SwiftUI

struct SuggestionsViewController_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct SuggestionsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = SuggestionsViewController()
            let viewModel = SuggestionsViewModel(coordinator: DefaultSuggestionsCoordinator(UINavigationController()),
                                                 useCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
            viewModel.popUpAlert.accept(())
            
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
