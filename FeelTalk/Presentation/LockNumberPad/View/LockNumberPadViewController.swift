//
//  LockNumberPadViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberPadViewController: UIViewController {
    var viewModel: LockNumberPadViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockNumberPadViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockNumberPadViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = LockNumberPadViewNameSpace.descriptionLabelNumberOfLines
        
        return label
    }()
    
    private lazy var passwordConfirmView: PasswordConfirmView = { PasswordConfirmView() }()
    
    private lazy var numberPadView: NumberPadView = { NumberPadView() }()

    private lazy var hintButton: CustomBottomBorderButton = { CustomBottomBorderButton(title: LockNumberPadViewNameSpace.hintButtonTitleText) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: LockNumberPadViewModel) {
        let input = LockNumberPadViewModel.Input(
            viewWillAppearObserver: rx.viewWillAppear,
            numberPadCellTapObserver: numberPadView.numberPadCellTapObserver,
            hintButtonTapOberver: hintButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.viewType
            .map { type -> Bool in type != .access ? true : false }
            .bind(to: hintButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.titleLabelModel
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.descriptionLabelType
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, type in
                vc.descriptionLabel.rx.text.onNext(type.rawValue)
                vc.descriptionLabel.setLineHeight(height: LockNumberPadViewNameSpace.descriptionLabelLineHeight)
                vc.descriptionLabel.rx.textAlignment.onNext(.center)
                switch type {
                case .newPasswordInput, .onemoreNewPasswordInput,
                        .initPasswordInput, .onemoreInitPasswordInput:
                    vc.descriptionLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
                case .differentPassword, .missMatchPassword:
                    vc.descriptionLabel.rx.textColor.onNext(.red)
                }
            }.disposed(by: disposeBag)
        
        output.passwordCount
            .bind(to: passwordConfirmView.passwordCountObserver)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeDescriptionLabelConstraints()
        makePasswordConfirmViewConstraints()
        makeHintButtonConstraints()
        makeNumberPadViewConstraints()
    }
}

extension LockNumberPadViewController {
    private func addViewSubComponents() {
        [titleLabel, passwordConfirmView, descriptionLabel, hintButton, numberPadView].forEach { view.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LockNumberPadViewNameSpace.titleLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LockNumberPadViewNameSpace.descriptionLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makePasswordConfirmViewConstraints() {
        passwordConfirmView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(NumberPadViewNameSpace.topOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(PasswordConfirmViewNameSpace.width)
        }
    }
    
    private func makeHintButtonConstraints() {
        hintButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordConfirmView.snp.bottom).offset(LockNumberPadViewNameSpace.hintButtonTopOffset)
            $0.height.equalTo(LockNumberPadViewNameSpace.hintButtonHeight)
        }
    }
    
    private func makeNumberPadViewConstraints() {
        numberPadView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(NumberPadViewNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberPadViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberPadViewController_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct LockNumberPadViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockNumberPadViewController()
            let vm = LockNumberPadViewModel(coordinator: DefaultLockNumberPadCoordinator(UINavigationController(rootViewController: vc)),
                                            configurationUseCase: DefaultConfigurationUseCase(
                                                configurationRepository: DefaultConfigurationRepository()))
            vm.viewType.accept(.access)
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
