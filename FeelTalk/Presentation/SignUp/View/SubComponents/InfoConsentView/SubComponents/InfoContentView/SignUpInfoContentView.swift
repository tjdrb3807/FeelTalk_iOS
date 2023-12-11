//
//  SignUpInfoContentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum SignUpInfoType: String, CaseIterable {
    /// 성인 인증
    case adultAuth = "만 19세 이상입니다."
    /// 서비스 이용
    case serviceConsent = "서비스 이용 약관 동의"
    /// 개인정보
    case personalInfoConsent = "개인정보 수집 및 서비스 활용 동의"
    /// 민감정보
    case sensitiveInfoConsent = "민감정보 수집 및 서비스 활용 동의"
    /// 마케팅 정보
    case marketingInfoConsent = "마케팅 정보 수신 동의(푸시 알림)"
}

final class SignUpInfoContentView: UIStackView {
    private let type: SignUpInfoType
    
    private lazy var spacingView: UIView = { UIView() }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        
        switch type {
        case .adultAuth:
            button.setImage(UIImage(named: SignUpInfoContentViewNameSpace.checkButtonSelectedImage),
                            for: .normal)
            button.isUserInteractionEnabled = false
        case .serviceConsent, .personalInfoConsent, .sensitiveInfoConsent, .marketingInfoConsent:
            button.setImage(UIImage(named: SignUpInfoContentViewNameSpace.checkButtonNormalImage), for: .normal)
            button.setImage(UIImage(named: SignUpInfoContentViewNameSpace.checkButtonSelectedImage), for: .selected)
            button.isEnabled = true
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = SignUpInfoContentViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        
        switch type {
        case .adultAuth:
            break
        case .serviceConsent, .personalInfoConsent, .sensitiveInfoConsent:
            label.text = SignUpInfoContentViewNameSpace.OptionLabelEssentialText
            label.textColor = UIColor(named: CommonColorNameSpace.main500)
        case .marketingInfoConsent:
            label.text = SignUpInfoContentViewNameSpace.OptionLabelChoiceText
            label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        }
        
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SignUpInfoContentViewNameSpace.OptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        
        switch type {
        case .adultAuth:
            label.textColor = .black
        case .serviceConsent, .personalInfoConsent, .sensitiveInfoConsent, .marketingInfoConsent:
            label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        }
        
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SignUpInfoContentViewNameSpace.contentLabelTextSize)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    init(_ type: SignUpInfoType) {
        self.type = type
        super.init(frame: .zero)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = SignUpInfoContentViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeSpacingViewConstraints()
    }
}

extension SignUpInfoContentView {
    private func addViewSubComponents() {
        [spacingView, checkButton, contentStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeSpacingViewConstraints() {
        spacingView.snp.makeConstraints { $0.width.equalTo(SignUpInfoContentViewNameSpace.SpacingViewWidth) }
    }
    
    private func addContentStackViewSubComponents() {
        [optionLabel, contentLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct SignUpInfoContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpInfoContentView_Presentable()
            .edgesIgnoringSafeArea(.all)
//            .frame(width: 137,
//                   height: 21,
//                   alignment: .center)
    }
    
    struct SignUpInfoContentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignUpInfoContentView(.marketingInfoConsent)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
