//
//  SignUpAdultAuthenticationDesctiptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpAdultAuthenticationDesctiptionView: UIStackView {
    /// 성인인증 성공 여부
    let adultAuthenticated = PublishRelay<AdultAuthStatus>()
    private let disposeBag = DisposeBag()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.numberOfLines = SignUpAdultAuthenticationDescriptionViewNameSpace.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()

    private lazy var checkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SignUpAdultAuthenticationDescriptionViewNameSpace.checkIconImage)
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        adultAuthenticated
            .withUnretained(self)
            .bind { vm, state in
                vm.setDescriptionLabelProperties(with: state)
                vm.setCheckIconProperties(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = SignUpAdultAuthenticationDescriptionViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() { makeCheckIconConstraints() }
}

extension SignUpAdultAuthenticationDesctiptionView {
    private func setDescriptionLabelProperties(with state: AdultAuthStatus) {
        switch state {
        case .authenticated:
            descriptionLabel.rx.text.onNext(SignUpAdultAuthenticationDescriptionViewNameSpace.descriptionCertificatedText)
        case .nonAuthenticated:
            descriptionLabel.rx.text.onNext(SignUpAdultAuthenticationDescriptionViewNameSpace.descriptionLabelDefaultText)
            descriptionLabel.setLineHeight(height: SignUpAdultAuthenticationDescriptionViewNameSpace.desctiptionLabelLineHeight)
            descriptionLabel.rx.textAlignment.onNext(.center)
        }
    }
    
    private func setCheckIconProperties(with state: AdultAuthStatus) {
        switch state {
        case .authenticated:
            checkIcon.rx.isHidden.onNext(false)
        case .nonAuthenticated:
            checkIcon.rx.isHidden.onNext(true)
        }
    }
}

extension SignUpAdultAuthenticationDesctiptionView {
    private func addViewSubComponents() { [descriptionLabel, checkIcon].forEach { addArrangedSubview($0) } }
    
    private func makeCheckIconConstraints() {
        checkIcon.snp.makeConstraints {
            $0.width.equalTo(SignUpAdultAuthenticationDescriptionViewNameSpace.checkIconWidth)
            $0.height.equalTo(SignUpAdultAuthenticationDescriptionViewNameSpace.checkIconHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct SignUpAdultAuthenticationDesctiptionView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpAdultAuthenticationDesctiptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: SignUpAdultAuthenticationDescriptionViewNameSpace.testAuthenticatedStatusWidth,
                   height: SignUpAdultAuthenticationDescriptionViewNameSpace.testAuthenticatedStatusHeight,
                   alignment: .center)
    }
    
    struct SignUpAdultAuthenticationDesctiptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignUpAdultAuthenticationDesctiptionView()
            v.adultAuthenticated.accept(AdultAuthStatus.authenticated)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
