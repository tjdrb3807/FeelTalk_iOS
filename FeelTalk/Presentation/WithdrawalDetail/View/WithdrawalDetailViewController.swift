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
    }
    
    private func bind(to viewModel: WithdrawalDetailViewModel) {
        
        let input = WithdrawalDetailViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            cellTapObserver: reasonsSelectionView.cellTapObserver.asObservable(),
            popButtonTapObserver: navigationBar.leftButton.rx.tap)

        let output = viewModel.transfer(input: input)
        
        output.items
            .bind(to: reasonsSelectionView.modelList)
            .disposed(by: disposeBag)
        
        output.withdrawalButtonState
            .withUnretained(self)
            .bind { vc, state in
                vc.withdrawalButton.rx.isEnabled.onNext(state)
                vc.updateWithdrawalButtonProperties(with: state)
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
        makeWithdrawalButtonConstraints()
    }
}

extension WithdrawalDetailViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, descriptonView, withdrawalButton].forEach { view.addSubview($0) }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(withdrawalButton.snp.top)
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
