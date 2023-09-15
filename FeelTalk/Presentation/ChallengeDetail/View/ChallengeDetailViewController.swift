//
//  ChallengeDetailViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailViewController: UIViewController {
    var viewModel: ChallengeDetailViewModel!

    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: ChallengeDetailNavigationBar = { ChallengeDetailNavigationBar() }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .black
        
        return scrollView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDetailViewNameSpace.verticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var descriptionView: ChallengeDetailDescriptionView = { ChallengeDetailDescriptionView() }()
    
    private lazy var contentView: ChallengeDetailStackView = { ChallengeDetailStackView() }()
    
    private lazy var challengeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: ChallengeDetailViewNameSpace.challengeButtonTitleFont,
                                         size: ChallengeDetailViewNameSpace.challengeButtonTitleSize)
        button.layer.cornerRadius = ChallengeDetailViewNameSpace.challengeButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
        self.bind(to: viewModel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bind(to viewModel: ChallengeDetailViewModel) {
        let input = ChallengeDetailViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                                   tapModifyButton: navigationBar.modifyButton.rx.tap,
                                                   tapRemoveButton: navigationBar.removeButton.rx.tap,
                                                   titleText: contentView.titleInputView.titleTextField.rx.text.orEmpty,
                                                   datePickerValueChanged: contentView.deadlineInputView.datePicker.rx.controlEvent(.valueChanged),
                                                   datePickerValue: contentView.deadlineInputView.datePicker.rx.value,
                                                   contentTextViewBeginEditing: contentView.contentInputView.contentTextView.rx.didBeginEditing,
                                                   contentTextViewEndEditing: contentView.contentInputView.contentTextView.rx.didEndEditing,
                                                   contentText: contentView.contentInputView.contentTextView.rx.text.orEmpty,
                                                   tapChallengeButton: challengeButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeight(height)
            }.disposed(by: disposeBag)
        
        /// mode에 따른 SubComponents 초기 설정
        output.viewMode
            .withUnretained(self)
            .bind { vc, mode in
                vc.navigationBar.viewMode.accept(mode)
                vc.descriptionView.viewMode.accept(mode)
                vc.contentView.titleInputView.viewMode.accept(mode)
                vc.contentView.deadlineInputView.viewMode.accept(mode)
                vc.contentView.contentInputView.viewMode.accept(mode)
                vc.setChallengeButton(with: mode)
            }.disposed(by: disposeBag)
        
        output.maxTitleText
            .withUnretained(self)
            .bind { vc, text in
                vc.contentView.titleInputView.titleTextField.rx.text.onNext(text)
            }.disposed(by: disposeBag)
        
        output.titleTextCount
            .withUnretained(self)
            .bind { vc, count in
                vc.contentView.titleInputView.textCountingView.molecularCount.accept(count)
                vc.contentView.titleInputView.titleTextCount.accept(count)
            }.disposed(by: disposeBag)
        
        output.deadline
            .withUnretained(self)
            .bind { vc, deadline in
                vc.contentView.deadlineInputView.deadlineTextField.rx.text.onNext(deadline)
            }.disposed(by: disposeBag)
        
        output.dDay
            .withUnretained(self)
            .bind { vc, dDay in
                vc.contentView.deadlineInputView.dDayLabel.rx.text.onNext(dDay)
            }.disposed(by: disposeBag)
        
        output.isContentPlaceholder
            .withUnretained(self)
            .bind { vc, state in
                vc.contentView.contentInputView.isPlaceholder.accept(state)
            }.disposed(by: disposeBag)
            
        
        /// contentViewView 글자 수
        output.contentTextCount
            .withUnretained(self)
            .bind { vc, count in
                vc.contentView.contentInputView.contentTextCountingView.molecularCount.accept(count)
            }.disposed(by: disposeBag)
        
        output.maxContentText
            .withUnretained(self)
            .bind { vc, text in
                vc.contentView.contentInputView.maxContentText.accept(text)
            }.disposed(by: disposeBag)
        
        /// challengeButton 활성화
        output.isChallengeButtonEnable
            .withUnretained(self)
            .bind { vc, state in
                vc.updateNewModeChallengeButton(state: state)
            }.disposed(by: disposeBag)
        

        contentView.titleInputView.toolbar.nextButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                DispatchQueue.main.async {
                    vc.contentView.deadlineInputView.deadlineTextField.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
        
        contentView.deadlineInputView.toolbar.nextButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                DispatchQueue.main.async {
                    vc.contentView.contentInputView.contentTextView.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeScrollViewConstraints()
        makeChallengeRegisterButtonConstraints()
        makeDescriptionViewConstraints()
        makeStackViewSubComponents()
        makeContentViewConstraints()
    }
}

// MARK: Default ChallengeDetailView UI setting method.
extension ChallengeDetailViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, challengeButton].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(ChallengeDetailNavigationBarNameSpace.height)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeChallengeRegisterButtonConstraints() {
        challengeButton.snp.makeConstraints {
            $0.top.equalTo(challengeButton.snp.bottom).offset(-ChallengeDetailViewNameSpace.challengeButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(ChallengeDetailViewNameSpace.challengeButtonSideInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(verticalStackView) }
    
    private func addStackViewSubComponents() {
        [descriptionView, contentView].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionViewConstraints() {
        descriptionView.snp.makeConstraints { $0.height.equalTo(ChallengeDetailDescriptionViewNameSpace.height) }
    }
    
    private func makeStackViewSubComponents() {
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
    }
}

// MARK: Update ChaellegeDetailView UI setting method.
extension ChallengeDetailViewController {
    private func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        
        view.layoutIfNeeded()
    }
    
    private func setChallengeButton(with mode: ChallengeDetailViewMode) {
        switch mode {
        case .new:
            challengeButton.rx.title().onNext(ChallengeDetailViewNameSpace.challengeButtonNewModeTitle)
            challengeButton.rx.backgroundColor.onNext(UIColor(named: ChallengeDetailViewNameSpace.challengeButtonNewModeDisableStateBackgroundColor))
            challengeButton.rx.isEnabled.onNext(false)
        case .ongoing:
            challengeButton.rx.title().onNext(ChallengeDetailViewNameSpace.challengeButtonOngoingModeTitle)
            challengeButton.rx.backgroundColor.onNext(UIColor(named: ChallengeDetailViewNameSpace.challengeButtonNewOrOngoingModeEnableStateBackgroundColor))
            challengeButton.rx.isEnabled.onNext(true)
        case .completed:
            challengeButton.rx.title().onNext(ChallengeDetailViewNameSpace.challengeButtonCompletedModeTitle)
            challengeButton.rx.backgroundColor.onNext(UIColor(named: ChallengeDetailViewNameSpace.challengeButtonCompletedModeBackgroundColor))
            challengeButton.rx.isEnabled.onNext(false)
        case .modify:
            challengeButton.rx.title().onNext(ChallengeDetailViewNameSpace.challengeButtonModifyModeTitle)
            challengeButton.rx.isEnabled.onNext(true)  // TODO: 아무런 수정없이 눌리게 해도 되는가???
            challengeButton.rx.backgroundColor.onNext(.black)
        }
    }
    
    private func updateNewModeChallengeButton(state: Bool) {
        challengeButton.rx.isEnabled.onNext(state)
        
        state ? challengeButton.rx.backgroundColor.onNext(UIColor(named: ChallengeDetailViewNameSpace.challengeButtonNewOrOngoingModeEnableStateBackgroundColor)) :
        challengeButton.rx.backgroundColor.onNext(UIColor(named: ChallengeDetailViewNameSpace.challengeButtonNewModeDisableStateBackgroundColor))
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailViewController_Presentable()
    }
    
    struct ChallengeDetailViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            ChallengeDetailViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
