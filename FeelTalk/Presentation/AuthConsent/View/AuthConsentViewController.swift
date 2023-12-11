//
//  AuthConsentViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AuthConsentViewController: BottomSheetViewController {
    var viewModel: AuthConsentViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AuthConsentViewControllerNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: AuthConsentViewControllerNameSpace.titleLabelTextSize)
        label.setLineHeight(height: AuthConsentViewControllerNameSpace.titleLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var fullConsentButton: AuthFullConsentButton = { AuthFullConsentButton() }()
    
    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = AuthConsentViewControllerNameSpace.itemStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var personalInfoConsentItem: InfoConsentItemView = {
        InfoConsentItemView(type: .AdultPersonalInfoConsent,
                            option: .essential)
    }()
    
    lazy var uniqueIdentificationInfoConsentItem: InfoConsentItemView = {
        InfoConsentItemView(type: .AdultUniqueIdentificationInfoConsent,
                            option: .essential)
    }()
    
    lazy var serviceConsentItem: InfoConsentItemView = {
        InfoConsentItemView(type: .AdultServiceConsent,
                            option: .essential)
    }()
    
    lazy var newsAgencyUseConsentItem: InfoConsentItemView = {
        InfoConsentItemView(type: .AdutlNewsAgencyUseConsent,
                            option: .essential)
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(AuthConsentViewControllerNameSpace.nextButtonTitleLabelText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: AuthConsentViewControllerNameSpace.nextButtonTitleLabelTextSize)
        button.layer.cornerRadius = AuthConsentViewControllerNameSpace.nextButtonCornerRadius
        button.clipsToBounds = true
        
        button.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.hide()
            }.disposed(by: disposeBag)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperites()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: AuthConsentViewModel) {
        let input = AuthConsentViewModel.Input(viewWillAppear: rx.viewWillAppear.asObservable(),
                                               tapFullConsentButton: fullConsentButton.rx.tap.asObservable(),
                                               tapPersonalInfoConsentButton: personalInfoConsentItem.checkButton.rx.tap.asObservable(),
                                               tapServiceConsentButton: serviceConsentItem.checkButton.rx.tap.asObservable(),
                                               tapUniqueIdentificationInfoConsentButton: uniqueIdentificationInfoConsentItem.checkButton.rx.tap.asObservable(),
                                               tapNewsAgencyUseConsentButton: newsAgencyUseConsentItem.checkButton.rx.tap.asObservable(),
                                               tapNextButton: nextButton.rx.tap.asObservable(),
                                               dismiss: super.dismiss)
        
        let output = viewModel.transfer(input: input)
        
        output.isFullConsentButtonSelected
            .bind(to: fullConsentButton.isConsented)
            .disposed(by: disposeBag)
        
        output.isPersonalInfoConsentButtonSelected
            .bind(to: personalInfoConsentItem.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isServiceConsentButtonSelected
            .bind(to: serviceConsentItem.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isUniqueIdentificationInfoConsentButtonSelected
            .bind(to: uniqueIdentificationInfoConsentItem.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isNewsAgencyUseConsentButtonSelected
            .bind(to: newsAgencyUseConsentItem.checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.isNextButtonEnable
            .withUnretained(self)
            .bind { vm, state in
                vm.updateNextButtonState(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperites() {
        setTopInset(AuthConsentViewControllerNameSpace.bottomSheetViewTopInset)
    }
    
    private func addSubComponents() {
        addBottomSheetViewSubComponents()
        addItemStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeFullConsentButtonConstraints()
        makeItemStackViewConstraints()
        makeNextButtonConstraints()
    }
}

extension AuthConsentViewController {
    private func addBottomSheetViewSubComponents() {
        [titleLabel, fullConsentButton, itemStackView, nextButton].forEach { super.bottomSheetView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AuthConsentViewControllerNameSpace.titleLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeFullConsentButtonConstraints() {
        fullConsentButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AuthFullConsentButtonNameSpace.topInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AuthFullConsentButtonNameSpace.height)
        }
    }
    
    private func makeItemStackViewConstraints() {
        itemStackView.snp.makeConstraints {
            $0.top.equalTo(AuthConsentViewControllerNameSpace.itemStackViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AuthConsentViewControllerNameSpace.itemStackViewheight)
        }
    }
    
    private func addItemStackViewSubComponents() {
        [personalInfoConsentItem, uniqueIdentificationInfoConsentItem, serviceConsentItem, newsAgencyUseConsentItem].forEach { itemStackView.addArrangedSubview($0) }
    }
    
    private func makeNextButtonConstraints() {
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AuthConsentViewControllerNameSpace.nextButtonTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(AuthConsentViewControllerNameSpace.nextbuttonHeight)
        }
    }
}

extension AuthConsentViewController {
    private func updateNextButtonState(with state: Bool) {
        nextButton.rx.isEnabled.onNext(state)
        
        state ?
        nextButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
        nextButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
    }
}

#if DEBUG

import SwiftUI

struct AuthConsentViewController_Previews: PreviewProvider {
    static var previews: some View {
        AuthConsentViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct AuthConsentViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = AuthConsentViewController()
            vc.viewModel = AuthConsentViewModel(coordinator: DefaultAuthConsentCoordinator(UINavigationController()))
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
