//
//  SignUpInfoConsentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpInfoConsentView: UIStackView {
    lazy var fullInfoSelectionView: SignUpFullInfoSelectionView = { SignUpFullInfoSelectionView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = SignUpInfoConsentViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    lazy var adultAuthConsentRow: SignUpInfoContentView = { SignUpInfoContentView(.adultAuth) }()
    
    lazy var serviceConsentRow: SignUpInfoContentView = { SignUpInfoContentView(.serviceConsent) }()
    
    lazy var personalInfoConsentRow: SignUpInfoContentView = { SignUpInfoContentView(.personalInfoConsent) }()
    
    lazy var sensitiveInfoConsentRow: SignUpInfoContentView = { SignUpInfoContentView(.sensitiveInfoConsent) }()
    
    lazy var marketingInfoConsentRow: SignUpInfoContentView = { SignUpInfoContentView(.marketingInfoConsent) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = SignUpInfoConsentViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeFullInfoSelectionViewConstraints()
    }
}

extension SignUpInfoConsentView {
    private func addViewSubComponents() {
        [fullInfoSelectionView, contentStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeFullInfoSelectionViewConstraints() {
        fullInfoSelectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(SignUpFullInfoSelectionViewNameSpace.height)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [adultAuthConsentRow, serviceConsentRow, personalInfoConsentRow, sensitiveInfoConsentRow, marketingInfoConsentRow].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct SignUpInfoConsentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpInfoConsentView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: SignUpInfoConsentViewNameSpace.height,
                   alignment: .center)
    }
    
    struct SignUpInfoConsentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignUpInfoConsentView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
