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
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .withdrawal) }()
    
    private lazy var descriptionView: WithdrawalDescriptionView = { WithdrawalDescriptionView() }()
    
    fileprivate lazy var terminationStatementView: ServiceTerminationStatementView = { ServiceTerminationStatementView() }()
    
    private lazy var terminationButton: ServiceTerminationButton = { ServiceTerminationButton(type: .withdrawal) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind() {
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
        makeNavigationBarConstratins()
        makeDescriptionViewConstraints()
        makeTerminationStatementViewConstraints()
        makeTerminationButtonConstraints()
    }
}

extension WithdrawalViewController {
    private func makeNavigationBarConstratins() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(CustomNavigationBarNameSpace.height)
        }
    }
    
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
            let viewController = WithdrawalViewController()
            viewController.terminationStatementView.type.accept(.withdrawal)
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
