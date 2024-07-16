//
//  LockNumberInitRequestViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberInitRequestViewController: UIViewController {
    var viewModel: LockNumberInitRequestViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = {
        CustomNavigationBar(
            type: .lockNumberReset,
            isRootView: true)
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberInitRequestViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: LockNumberInitRequestViewNameSpace.titleLabelTextSize)
        label.numberOfLines = LockNumberInitRequestViewNameSpace.titleLabelNumberOfLines
        label.setLineHeight(height: LockNumberInitRequestViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var sosImage: UIImageView = {
        UIImageView(
            image: UIImage(
                named: LockNumberInitRequestViewNameSpace.sosImage))
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberInitRequestViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberInitRequestViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = LockNumberInitRequestViewNameSpace.descriptionLabelNumberOfLines
        label.setLineHeight(height: LockNumberInitRequestViewNameSpace.descriptionLabelLineHeight)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle(
            LockNumberInitRequestViewNameSpace.requestButtonTitleText,
            for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: LockNumberInitRequestViewNameSpace.requestButtonTitleTextSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = LockNumberInitRequestViewNameSpace.requestButtonCornerRadius
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
    
    private func bind(to viewModel: LockNumberInitRequestViewModel) {
        let input = LockNumberInitRequestViewModel.Input(
            dismissButtonTapObserver: navigationBar.leftButton.rx.tap,
            requestButtonTapObserver: requestButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.popToastMessage
            .withUnretained(self)
            .bind { vc, message in
                guard !vc.view.subviews.contains(where: { $0 is CustomToastMessage }) else { return }
                let toastMessage = CustomToastMessage(message: message)
                
                vc.view.addSubview(toastMessage)
                toastMessage.setConstraints()
                vc.view.layoutIfNeeded()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    toastMessage.show()
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeTitleLabelConstraints()
        makeSOSImageConstraints()
        makeDescriptionLabelConstraints()
        makeRequestButtonConstraints()
    }
}

extension LockNumberInitRequestViewController {
    private func addViewSubComponents() {
        [navigationBar, titleLabel, sosImage, descriptionLabel, requestButton].forEach { view.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(LockNumberInitRequestViewNameSpace.titleLabelTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeSOSImageConstraints() {
        sosImage.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(LockNumberInitRequestViewNameSpace.sosImageTopOffset)
            $0.leading.equalToSuperview().inset(LockNumberInitRequestViewNameSpace.sosImageLeadingInset)
            $0.trailing.equalToSuperview().inset(LockNumberInitRequestViewNameSpace.sosImageTrailingInset)
            $0.height.equalTo(LockNumberInitRequestViewNameSpace.sosImageHeight)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(LockNumberInitRequestViewNameSpace.descriptionLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeRequestButtonConstraints() {
        requestButton.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(LockNumberInitRequestViewNameSpace.requestButtonTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(LockNumberInitRequestViewNameSpace.requestButtonHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberInitRequestViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberInitRequestViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LockNumberInitRequestViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockNumberInitRequestViewController()
            let vm = LockNumberInitRequestViewModel(coordinator: DefaultLockNumberInitRequestCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
