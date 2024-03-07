//
//  LockNumberHintViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class LockNumberHintViewController: UIViewController {
    var viewModel: LockNumberHintViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .lockNumberSettings, isRootView: false) }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.setTapGesture()
        
        let isCrtAnswerInputViewFocused = PublishRelay<Void>()
        
        answerView
            .crtInputViewObserver
            .withUnretained(self)
            .bind { vc, inputView in
                inputView.textField.rx.controlEvent(.editingDidBegin)
                    .asObservable()
                    .bind(to: isCrtAnswerInputViewFocused)
                    .disposed(by: vc.disposeBag)
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(isCrtAnswerInputViewFocused.asObservable(),
                           RxKeyboard.instance.visibleHeight.asObservable()
            ).bind { _ in scrollView.scrollToBottom() }
            .disposed(by: disposeBag)
        
        return scrollView
    }()
    
    private lazy var scrollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var headerView: LockNumberHintHeaderView = { LockNumberHintHeaderView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberHintViewNameSpace.contentStakcViewSpacing
        
        return stackView
    }()
    
    private lazy var selectionView: LockNumberHintSelectionView = { LockNumberHintSelectionView() }()
    
    private lazy var answerView: LockNumberHintAnswerView = { LockNumberHintAnswerView() }()
    
    private lazy var helpButton: CustomBottomBorderButton = { CustomBottomBorderButton(title: "답변이 기억나지 않아요") }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    private lazy var pickerView: LockNubmerHintPickerView = {
        let view = LockNubmerHintPickerView()
        
        selectionView.isPickerSelectedObserver
            .skip(1)
            .asObservable()
            .map { state -> CGFloat in state ? LockNumberHintPickerViewNameSpace.height : LockNumberHintPickerViewNameSpace.hiddenHight }
            .bind { height in
                view.snp.updateConstraints {
                    $0.bottom.equalTo(view.snp.top).offset(height)
                }
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.0,
                    options: .allowAnimatedContent,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.view.layoutSubviews()
                    })
            }.disposed(by: disposeBag)
        
        view.rx.modelSelected(LockNumberHintType.self)
            .withLatestFrom(selectionView.isPickerSelectedObserver)
            .map { !$0 }
            .bind(to: selectionView.isPickerSelectedObserver)
            .disposed(by: disposeBag)

        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(
            LockNumberHintViewNameSpace.confirmButtonTitleText,
            for: .normal)
        button.setTitleColor(
            .white,
            for: .normal)
        button.titleLabel?.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: LockNumberHintViewNameSpace.confirmButtonTextSize)
        button.layer.cornerRadius = LockNumberHintViewNameSpace.confirmButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bind(to viewModel: LockNumberHintViewModel) {
        let input = LockNumberHintViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            hintPickerCellTabObserver: pickerView.rx.modelSelected(LockNumberHintType.self),
            textAnswerObserver: answerView.textObserver.asObservable(),
            dateAnswerObserver: answerView.dateObserver.asObservable(),
            confirmButtonTapObserver: confirmButton.rx.tap,
            popButtonTapObserver: navigationBar.leftButton.rx.tap,
            helpButtonTapObserver: helpButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .skip(1)
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let keyboardHeight = keyboardHeight > 0.0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0.0
                vc.updateScrollViewConstraints(with: keyboardHeight)
            }.disposed(by: disposeBag)
        
        output.viewTypeObserber
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .settings:
                    vc.navigationBar.titleLabel.rx.text.onNext(LockNumberHintViewNameSpace.navigationBarSettingsTypeTitleText)
                    vc.scrollStackView.rx.spacing.onNext(LockNumberHintViewNameSpace.scrollStackViewSettingsTypeSpacing)
                    vc.helpButton.rx.isHidden.onNext(true)
                case .reset:
                    vc.navigationBar.titleLabel.rx.text.onNext(LockNumberHintViewNameSpace.navigationBarResetTypeTitleText)
                    vc.scrollStackView.rx.spacing.onNext(LockNumberHintViewNameSpace.scrollStackViewResetTypeSpacing)
                    vc.helpButton.rx.isHidden.onNext(false)
                }
                vc.headerView.viewTypeObserver.accept(type)
                vc.selectionView.viewTypeObserver.accept(type)
            }.disposed(by: disposeBag)
        
        output.selectedHint
            .withUnretained(self)
            .bind { vc, type in
                vc.selectionView.selectedHintObserver.accept(type)
                vc.answerView.selectedHintObserver.accept(type)
            }.disposed(by: disposeBag)
        
        output.confirmButtonState
            .asObservable()
            .withUnretained(self)
            .bind { vc, state in
                vc.confirmButton.rx.isEnabled.onNext(state)
                state ?
                vc.confirmButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
                vc.confirmButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
        
        answerView
            .toolBarButtonTapObserver
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismissKeyboard()
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addScrollStackViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeScrollViewConstraints()
        makeScrollStackViewConstraints()
        makeHeaderViewConstraints()
        makeContentStackViewConstraints()
        makeSelectionViewConstraints()
        makeAnswerViewConstraints()
        makeBottomSpacingConstraints()
        makePickerViewConstraints()
        makeHelpButtonConstraints()
        makeConfirmButtonConstraints()
    }
}

extension LockNumberHintViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, pickerView, helpButton, confirmButton].forEach { view.addSubview($0) }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(scrollStackView) }
    
    private func makeScrollStackViewConstraints() {
        scrollStackView.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func addScrollStackViewSubComponents() {
        [headerView, contentStackView].forEach { scrollStackView.addArrangedSubview($0) }
    }
    
    private func makeHeaderViewConstraints() {
        headerView.snp.makeConstraints { $0.width.equalToSuperview() }
    }

    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.width.equalToSuperview() }
    }

    private func addContentStackViewSubComponents() {
        [selectionView, answerView, bottomSpacing].forEach { contentStackView.addArrangedSubview($0) }
    }

    private func makeSelectionViewConstraints() {
        selectionView.snp.makeConstraints { $0.width.equalToSuperview() }
    }

    private func makeAnswerViewConstraints() {
        answerView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    private func makeBottomSpacingConstraints() {
        bottomSpacing.snp.makeConstraints {
            $0.height.equalTo(4.0)
            $0.width.equalToSuperview()
        }
    }

    private func makePickerViewConstraints() {
        pickerView.snp.makeConstraints {
            $0.top.equalTo(selectionView.snp.bottom).offset(LockNumberHintPickerViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(pickerView.snp.top)
        }
    }
    
    private func makeHelpButtonConstraints() {
        helpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-91.0)
            $0.height.equalTo(21.0)
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(LockNumberHintViewNameSpace.confirmButtonHeight)
        }
    }
}

extension LockNumberHintViewController {
    private func updateScrollViewConstraints(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        
        scrollView.scrollToBottom()
        
        view.layoutIfNeeded()
    }
}

#if DEBUG

import SwiftUI

struct LockNumberHintViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberHintViewController_Presentable()
    }
    
    struct LockNumberHintViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockNumberHintViewController()
            let vm = LockNumberHintViewModel(coordinator: DefaultLockNumberHintCoordinator(UINavigationController()),
                                             configurationUseCase: DefaultConfigurationUseCase(
                                                configurationRepository: DefaultConfigurationRepository()))

            vm.viewType.accept(.settings)
            vc.viewModel = vm

            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
