//
//  BreakUpViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BreakUpViewController: UIViewController {
    var viewModel: BreakUpViewModel!
    let isTerminationButtonAlbe = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .breakUp, isRootView: true) }()
    
    fileprivate lazy var serviceDataCountView: BreakUpServiceDataCountView = { BreakUpServiceDataCountView() }()
    
    fileprivate lazy var terminationStatementView: ServiceTerminationStatementView = { ServiceTerminationStatementView() }()
    
    private lazy var breakUpDescriptionLable: UILabel = {
        let label = UILabel()
        label.text = BreakUpViewNameSpace.breakUpDescriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: BreakUpViewNameSpace.breakUpDescriptionLabelTextSize)
        label.numberOfLines = BreakUpViewNameSpace.breakUpDescriptionLabelNumberOfLines
        label.backgroundColor = .clear
        label.setLineHeight(height: BreakUpViewNameSpace.breakUpDescriptionLabelLineHeight)
        label.textAlignment = .center
    
        return label
    }()
    
    private lazy var terminationButton: ServiceTerminationButton = { ServiceTerminationButton(type: .breakUp) }()
    
    private lazy var alertView: CustomAlertView = { CustomAlertView(type: .breakUp) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.bind(to: viewModel)
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
        
        terminationButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                guard !vc.view.subviews.contains(where: { $0 is CustomAlertView }) else { return }
                let alertView = vc.alertView
                vc.view.addSubview(alertView)
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                
                alertView.show()
            }.disposed(by: disposeBag)
    }
    
    
    private func bind(to viewModel: BreakUpViewModel) {
        let input = BreakUpViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                           navigationBarLeftButtonTapObserver: navigationBar.leftButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.questionCount
            .distinctUntilChanged()
            .bind(to: serviceDataCountView.questionCount)
            .disposed(by: disposeBag)
        
        output.challengeCount
            .distinctUntilChanged()
            .bind(to: serviceDataCountView.challengeCount)
            .disposed(by: disposeBag)
        
        output.terminationType
            .distinctUntilChanged()
            .bind(to: terminationStatementView.type)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents(){
        addViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeServiceDataCountViewConstraints()
        makeTerminationStatementViewConstraints()
        makeBreakUpDescriptionLabelConstraints()
        makeTerminationButtonConstraints()
    }
}

extension BreakUpViewController {
    private func addViewSubComponents() {
        [navigationBar, serviceDataCountView, terminationStatementView, breakUpDescriptionLable, terminationButton].forEach { view.addSubview($0) }
    }
    
    private func makeServiceDataCountViewConstraints() {
        serviceDataCountView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(BreakUpServiceDataCountViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeTerminationStatementViewConstraints() {
        terminationStatementView.snp.makeConstraints {
            $0.top.equalTo(serviceDataCountView.snp.bottom).offset(BreakUpViewNameSpace.terminationStatementViewTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(terminationStatementView.snp.top).offset(BreakUpViewNameSpace.terminationStatementViewHeight)
        }
    }
    
    private func makeBreakUpDescriptionLabelConstraints() {
        breakUpDescriptionLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(terminationStatementView.snp.bottom).offset(BreakUpViewNameSpace.breakUpDescriptionLabelTopOffset)
            $0.height.equalTo(BreakUpViewNameSpace.breakUpDescriptionLabelHeight)
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

struct BreakUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        BreakUpViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct BreakUpViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = BreakUpViewController()
            let viewModel = BreakUpViewModel(coordinator: DefaultBreakUpCoordinator(UINavigationController()),
                                             configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
            
            viewController.serviceDataCountView.questionCount.accept(67)
            viewController.serviceDataCountView.challengeCount.accept(4)
            viewController.terminationStatementView.type.accept(.breakUp)
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
