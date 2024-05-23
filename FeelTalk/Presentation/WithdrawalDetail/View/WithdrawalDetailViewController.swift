//
//  WithdrawalDetailViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WithdrawalDetailViewController: UIViewController {
    var viewModel: WithdrawalDetailViewModel!
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .withdrawal, isRootView: false) }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .black
        scrollView.setTapGesture()
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = WithdrawalDetailViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var reasonsSelectionView: WithdrawalReasonsSelectionView = { WithdrawalReasonsSelectionView() }()
    
    private lazy var reviewInputView: ReviewInputView = { ReviewInputView() }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    private lazy var descriptonView: WithdrawalDetailDescriptionView = { WithdrawalDetailDescriptionView() }()
    
    private lazy var withdrawalButtonBehindView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle(WithdrawalDetailViewNameSpace.withdrawalButtonTitleText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: WithdrawalDetailViewNameSpace.withdrawalButtonTitleTextSize)
        button.layer.cornerRadius = WithdrawalDetailViewNameSpace.withdrawalButtonCornerRadius
        button.layer.borderWidth = WithdrawalDetailViewNameSpace.withdrawalButtonBorderWidth
        button.clipsToBounds = true

        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind(to viewModel: WithdrawalDetailViewModel) {
        let alertRightButtonTapObserver = PublishRelay<CustomAlertType>()
        
        let input = WithdrawalDetailViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            cellTapObserver: reasonsSelectionView.cellTapObserver.asObservable(),
            popButtonTapObserver: navigationBar.leftButton.rx.tap,
            withdrawalButtonTapObserver: withdrawalButton.rx.tap)

        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind { vc, height in
                let keyboardHeight = height > 0.0 ? -height + vc.view.safeAreaInsets.bottom : 0.0
                vc.updateScrollViewConstraints(with: keyboardHeight)
            }.disposed(by: disposeBag)
        
        output.items
            .bind(to: reasonsSelectionView.modelList)
            .disposed(by: disposeBag)
        
        output.withdrawalButtonState
            .withUnretained(self)
            .bind { vc, state in
                vc.withdrawalButton.rx.isEnabled.onNext(state)
                vc.updateWithdrawalButtonProperties(with: state)
            }.disposed(by: disposeBag)
        
        output.popUpAlert
            .withUnretained(self)
            .bind { vc, type in
                guard !vc.view.subviews.contains(where: { $0 is CustomAlertView }) else { return }
                let alertView = CustomAlertView(type: type)
                alertView.rightButton.rx.tap
                    .map { type }
                    .bind { type in
                        alertRightButtonTapObserver.accept(type)
                        alertView.hide()
                    }.disposed(by: vc.disposeBag)
                
                vc.view.addSubview(alertView)
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                
                alertView.show()
            }.disposed(by: disposeBag)
        
        reasonsSelectionView.selectedCell
            .withUnretained(self)
            .bind { vc, _ in
                UIView.animate(withDuration: 0.2,
                               delay: 0.0,
                               options: .allowAnimatedContent,
                               animations: { vc.contentStackView.layoutSubviews() })
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
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
        makeReasonsSelectionViewConstraints()
        makeReviewInputViewConstraints()
        makeBottomSpacingConstraints()
        makeDescriptionViewConstraints()
        makeWithdrawalButtonBehindViewConstraints()
        makeWithdrawalButtonConstraints()
    }
}

extension WithdrawalDetailViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, descriptonView, withdrawalButtonBehindView, withdrawalButton].forEach { view.addSubview($0) }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(withdrawalButton.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [reasonsSelectionView, reviewInputView, bottomSpacing].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeReasonsSelectionViewConstraints() {
        reasonsSelectionView.snp.makeConstraints { $0.width.equalToSuperview() } }
    
    private func makeReviewInputViewConstraints() {
        reviewInputView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    private func makeBottomSpacingConstraints() {
        bottomSpacing.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(WithdrawalDetailViewNameSpace.bottomSpacingHeight)
        }
    }
    
    private func makeDescriptionViewConstraints() {
        descriptonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(withdrawalButton.snp.top)
            $0.height.equalTo(WithdrawalDetailDescriptionViewNameSpace.height)
        }
    }
    
    private func makeWithdrawalButtonBehindViewConstraints() {
        withdrawalButtonBehindView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(WithdrawalDetailViewNameSpace.withdrawalButtonHeight)
        }
    }
    
    private func makeWithdrawalButtonConstraints() {
        withdrawalButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(WithdrawalDetailViewNameSpace.withdrawalButtonHeight)
        }
    }
}

extension WithdrawalDetailViewController {
    private func updateWithdrawalButtonProperties(with isEnabled: Bool) {
        if isEnabled {
            withdrawalButton.rx.backgroundColor.onNext(.white)
            withdrawalButton.layer.rx.borderColor.onNext(UIColor.black.cgColor)
        } else {
            withdrawalButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray400))
            withdrawalButton.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
        }
    }
    
    private func updateScrollViewConstraints(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight)}
        
        if keyboardHeight == 0.0 {
            bottomSpacing.rx.isHidden.onNext(false)
        } else {
            bottomSpacing.rx.isHidden.onNext(true)
        }

        view.layoutIfNeeded()
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalDetailViweController_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetailViewController_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct WithdrawalDetailViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = WithdrawalDetailViewController()
            let vm = WithdrawalDetailViewModel(coordinator: DefaultWithdrawalDetailCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
