//
//  InquiryViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InquiryViewController: UIViewController {
    var viewModel: InquiryViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .inquiry) }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .black
        scrollView.setTapGesture()
        
        return scrollView
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = InquriyVIewNameSpace.totalStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var topSeparator: UIView = { UIView() }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = InquriyVIewNameSpace.descriptionLabelText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: InquriyVIewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = InquriyVIewNameSpace.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        label.setLineHeight(height: InquriyVIewNameSpace.descriptionLabelLineHeight)
        
        return label
    }()
    
    private lazy var contentInputView: InquiryContentInputView = { InquiryContentInputView() }()
    
    private lazy var emailInputView: InquiryEmailInputView = { InquiryEmailInputView() }()
    
    private lazy var spacingView: UIView = { UIView() }()
    
    private lazy var submitButton: CustomButton = { CustomButton(type: .register, title: InquriyVIewNameSpace.submitButtonTitleText) }()
    
    private lazy var alertView: CustomAlertView = { CustomAlertView(type: .inquiry) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
        self.bind(to: viewModel)
    }
    
    private func bind(to viewModel: InquiryViewModel) {
        let input = InquiryViewModel.Input(titleText: contentInputView.titleInputTextField.rx.text.orEmpty,
                                           contentText: contentInputView.contentInputTextView.textView.rx.text.orEmpty,
                                           emailText: emailInputView.emailInputTextField.rx.text.orEmpty,
                                           tapSubmitButton: submitButton.rx.tap,
                                           tapDismissButton: navigationBar.leftButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeight(height)
            }.disposed(by: disposeBag)
        
        output.isDataSubmitEnabled
            .withUnretained(self)
            .bind { vc, state in
                vc.submitButton.isState.accept(state)
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
    
    private func setConstratins() {
        navigationBar.makeNavigationBarConstraints()
        makeScrollViewConstraints()
        makeTotalStackViewConstratins()
        makeDescriptionLabelConstraints()
        makeContentInputViewConstraints()
        makeEmailInputViewMakeConstraints()
        makeSubmitButtonConstratins()
    }
}

extension InquiryViewController {
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
    
    private func addScrollViewSubComponents() {
        scrollView.addSubview(totalStackView)
    }
    
    private func makeTotalStackViewConstratins() {
        totalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [topSeparator, descriptionLabel, contentInputView, emailInputView, spacingView].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeContentInputViewConstraints() {
        contentInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeEmailInputViewMakeConstraints() {
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

extension InquiryViewController {
    fileprivate func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        view.layoutIfNeeded()
    }
}

#if DEBUG

import SwiftUI

struct InquiryViewController_Previews: PreviewProvider {
    static var previews: some View {
        InquiryViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct InquiryViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = InquiryViewController()
            let viewModel = InquiryViewModel(coordinator: DefaultInquiryCoordinator(UINavigationController()))
        
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif

