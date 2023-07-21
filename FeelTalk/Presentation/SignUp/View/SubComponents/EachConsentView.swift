//
//  EachConsentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/16.
//

import UIKit
import SnapKit

public enum InfoContent: CaseIterable {
    case adultConsent
    case serviceConsent
    case personalInfoConsent
    case sensitiveInfoConsent
    case marketingInfoConsent
}

final class EachConsentView: UIStackView {
    private let infoContent: InfoContent
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        
        switch infoContent {
        case .adultConsent:
            button.setImage(UIImage(named: SignUpNameSpace.checkButtonSelectedImage), for: .normal)
            button.isUserInteractionEnabled = false
        case .serviceConsent, .personalInfoConsent, .sensitiveInfoConsent, .marketingInfoConsent:
            button.setImage(UIImage(named: SignUpNameSpace.checkButtonUnselectedImage), for: .normal)
            button.setImage(UIImage(named: "icon_check_selected"), for: .selected)
            button.isEnabled = true
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var firstSpacing: UIView = { return UIView() }()
    
    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        
        switch infoContent {
        case .adultConsent:
            break
        case .serviceConsent, .personalInfoConsent, .sensitiveInfoConsent:
            label.text = SignUpNameSpace.restConsentOptionLabelText
            label.textColor = UIColor(named: SignUpNameSpace.restConsentOptionLabelTextColor)
        case .marketingInfoConsent:
            label.text = SignUpNameSpace.marketingConsentOptionLabelText
            label.textColor = UIColor(named: SignUpNameSpace.marketingConsetnOptionLabelTextColor)
        }
        
        label.font = UIFont(name: SignUpNameSpace.optionLabelTextFont, size: SignUpNameSpace.optionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var secondSpacing: UIView = { return UIView() }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        
        switch infoContent {
        case .adultConsent:
            label.text = SignUpNameSpace.adultConsentLabelText
            label.textColor = .black
        case .serviceConsent:
            label.text = SignUpNameSpace.serviceConsentLabelText
            label.textColor = UIColor(named: SignUpNameSpace.contentLabelTextColor)
        case .personalInfoConsent:
            label.text = SignUpNameSpace.personalInfoConsentLabelText
            label.textColor = UIColor(named: SignUpNameSpace.contentLabelTextColor)
        case .sensitiveInfoConsent:
            label.text = SignUpNameSpace.sensitiveInfoConsentLabelText
            label.textColor = UIColor(named: SignUpNameSpace.contentLabelTextColor)
        case .marketingInfoConsent:
            label.text = SignUpNameSpace.marketingInfoConsentLabelText
            label.textColor = UIColor(named: SignUpNameSpace.contentLabelTextColor)
        }

        label.font = UIFont(name: SignUpNameSpace.contentLabelTextFont, size: SignUpNameSpace.contentLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    init(infoContent: InfoContent) {
        self.infoContent = infoContent
        
        super.init(frame: .zero)
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [checkButton, firstSpacing].forEach { addArrangedSubview($0) }
        
        if infoContent != .adultConsent { [optionLabel, secondSpacing].forEach { addArrangedSubview($0) } }
        
        addArrangedSubview(contentLabel)
    }
    
    private func setConfiguration() {
        checkButton.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.checkButtonWidth) }
        firstSpacing.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.eachConsentViewFirstSpacingWidth)}
        optionLabel.snp.makeConstraints { $0.width.equalTo(optionLabel.intrinsicContentSize) }
        secondSpacing.snp.makeConstraints { $0.width.equalTo(SignUpNameSpace.eachConsetnViewSecontSpacinWidth)}
    }
}

#if DEBUG

import SwiftUI

struct EachConsentView_Previews: PreviewProvider {
    static var previews: some View {
        EachConsentView_Presentable()
    }
    
    struct EachConsentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            EachConsentView(infoContent: .sensitiveInfoConsent)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
#endif
