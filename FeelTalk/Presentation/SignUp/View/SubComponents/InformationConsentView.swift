//
//  InformationConsentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/16.
//

import UIKit
import SnapKit

final class InformationConsentView: UIStackView {
    private lazy var totalConsentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: SignUpNameSpace.totalConsentViewBackgroundColor)
        view.layer.cornerRadius = SignUpNameSpace.totalConsentViewCornerRadius
        
        return view
    }()
    
    private lazy var totalConsentViewFullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = SignUpNameSpace.totalConsentViewFullHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var totalConsentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SignUpNameSpace.totalConsentButtonImage), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var totalConsentLabel: UILabel = {
        let label = UILabel()
        label.text = SignUpNameSpace.totalConsentLabelText
        label.textColor = .black
        label.font = UIFont(name: SignUpNameSpace.totalConsentLabelTextFont, size: SignUpNameSpace.totalConsentLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var presentDetailConsentViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SignUpNameSpace.presentDetailConsentViewButtonImage), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var consentHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = SignUpNameSpace.consentHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var spacingView: UIView = { UIView() }()
    
    private lazy var consentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = SignUpNameSpace.consentVerticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var adultConsentRow: EachConsentView = { EachConsentView(infoContent: .adultConsent) }()
    lazy var serviceConsentRow: EachConsentView = { EachConsentView(infoContent: .serviceConsent )}()
    lazy var personalInfoConsentRow: EachConsentView = { EachConsentView(infoContent: .personalInfoConsent) }()
    lazy var sensitiveInfoConsentRow: EachConsentView = { EachConsentView(infoContent: .sensitiveInfoConsent) }()
    lazy var marketingInfoConsentRow: EachConsentView = { EachConsentView(infoContent: .marketingInfoConsent) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = SignUpNameSpace.informationConsentViewSpacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [totalConsentButton, totalConsentLabel, presentDetailConsentViewButton].forEach { totalConsentViewFullHorizontalStackView.addArrangedSubview($0) }
        
        totalConsentView.addSubview(totalConsentViewFullHorizontalStackView)
        
        [adultConsentRow, serviceConsentRow, personalInfoConsentRow, sensitiveInfoConsentRow, marketingInfoConsentRow].forEach { consentVerticalStackView.addArrangedSubview($0) }
        
        [spacingView, consentVerticalStackView].forEach { consentHorizontalStackView.addArrangedSubview($0) }
        
        [totalConsentView, consentHorizontalStackView].forEach { addArrangedSubview($0) }
    }
    
    private func setConfiguration() {
        totalConsentButton.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.totalConsentButtonWidth) }
        
        presentDetailConsentViewButton.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.presentDetailConsetnViewButtonWidth) }
        
        totalConsentViewFullHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(SignUpNameSpace.totalConsentViewFullhorizontalStackViewVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(SignUpNameSpace.totalConsetnViewFullhorizontalStackViewHorizontalInset)
        }
        
        totalConsentView.snp.makeConstraints { $0.height.equalTo(SignUpNameSpace.totalConsetnViewHeight) }
        
        spacingView.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.spacingViewHeight) }
    }
}

#if DEBUG

import SwiftUI

struct InformationConsentView_Previews: PreviewProvider {
    static var previews: some View {
        InformationConsentView_Presentable()
    }
    
    struct InformationConsentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InformationConsentView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
