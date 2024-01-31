//
//  PartnerInfoViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PartnerInfoViewController: UIViewController {
    var viewModel: PartnerInfoViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .myPartner, isRootView: false) }()
    
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
        stackView.spacing = PartnerInfoViewControllerNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var topSpacingView: UIView = { UIView() }()
    
    private lazy var partnerInfoView: PartnerInfoView = { PartnerInfoView() }()  
    
    private lazy var breakUpButton: PartnerInfoBreakUpButton = { PartnerInfoBreakUpButton() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: PartnerInfoViewModel) {
        let input = PartnerInfoViewModel.Input(viewWillAppearObserver: rx.viewWillAppear,
                                               viewDidDisappearObserver: rx.viewDidDisappear,
                                               popButtonTapObserver: navigationBar.leftButton.rx.tap,
                                               breakButtonTapObserver: breakUpButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.partnerModel
            .bind(to: partnerInfoView.model)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
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
        makeTopSpacingViewConstraints()
        makePartnerInfoViewConstraints()
        makeBreakUpButtonConstraints()
    }
}

extension PartnerInfoViewController {
    private func addViewSubComponents() { [navigationBar, scrollView].forEach { view.addSubview($0) } }
    
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
        [topSpacingView, partnerInfoView, breakUpButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTopSpacingViewConstraints() {
        topSpacingView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(PartnerInfoViewControllerNameSpace.topSpacingViewHeight)
        }
    }
    
    private func makePartnerInfoViewConstraints() {
        partnerInfoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(PartnerInfoViewNameSpcae.leadingInset)
            $0.trailing.equalToSuperview().inset(PartnerInfoViewNameSpcae.trailingInset)
            $0.height.equalTo(PartnerInfoViewNameSpcae.height)
        }
    }
    
    private func makeBreakUpButtonConstraints() {
        breakUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(PartnerInfoBreakUpButtonNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(PartnerInfoBreakUpButtonNameSpace.trailingInset)
            $0.height.equalTo(PartnerInfoBreakUpButtonNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerInfoViewController_Preveiws: PreviewProvider {
    static var previews: some View {
        PartnerInfoViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct PartnerInfoViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = PartnerInfoViewController()
            let viewModel = PartnerInfoViewModel(coordinator: DefaultPartnerInfoCoordinator(UINavigationController()),
                                                 userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
            
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
