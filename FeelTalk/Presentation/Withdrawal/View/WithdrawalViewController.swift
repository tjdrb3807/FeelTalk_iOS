//
//  WithdrawalViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WithdrawalViewController: UIViewController {
    var viewModel: WithdrawalViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .withdrawal, isRootView: true) }()
    
    private lazy var descriptionView: WithdrawalDescriptionView = { WithdrawalDescriptionView() }()
    
    fileprivate lazy var terminationStatementView: ServiceTerminationStatementView = { ServiceTerminationStatementView() }()
    
    private lazy var terminationButton: ServiceTerminationButton = { ServiceTerminationButton(type: .withdrawal) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind(to viewModel: WithdrawalViewModel) {
        let input = WithdrawalViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            dismissButtonTapObserver: navigationBar.leftButton.rx.tap,
            withdrawalButtonTapObserver: terminationButton.rx.tap)

        let output = viewModel.transfer(input: input)
        
        output.terminationStatementType
            .bind(to: terminationStatementView.type)
            .disposed(by: disposeBag)
        
        
        terminationStatementView.isConfirmButtonCheked
            .withUnretained(self)
            .bind { vc, state in
                vc.terminationButton.isState.accept(state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubComponents() {
        [navigationBar, descriptionView, terminationStatementView, terminationButton].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeDescriptionViewConstraints()
        makeTerminationStatementViewConstraints()
        makeTerminationButtonConstraints()
    }
}

extension WithdrawalViewController {
    private func makeDescriptionViewConstraints() {
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(WithdrawalDescriptionViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeTerminationStatementViewConstraints() {
        terminationStatementView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(WithdrawalViewNameSpace.terminationStatementViewTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(WithdrawalViewNameSpace.termiantionStatementViewHeight)
        }
    }
    
    private func makeTerminationButtonConstraints() {
        terminationButton.snp.makeConstraints {
            $0.top.equalTo(terminationButton.snp.bottom).offset(-ServiceTerminationButtonNameSpace.height)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalViewController_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalViewController_Presentable()
    }
    
    struct WithdrawalViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = WithdrawalViewController()
            let vm = WithdrawalViewModel(coordinator: DefaultWithdrawalCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            vc.terminationStatementView.type.accept(.withdrawal)
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
